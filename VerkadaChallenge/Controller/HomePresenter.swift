//
//  HomePresenter.swift
//  VerkadaChallenge
//
//  Created by Woody Lee on 1/19/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import Foundation
import UIKit

typealias MotionHandler = ((_ status: Bool, _ motionResult: [[Int]]) -> Void)

class HomePresenter: HomePresenterProtocol {
	
	weak var homeView: HomeViewProtocol?
	
	private var motionCells = [MotionCell]()
	private var motionResults = [MotionResult]()
	private let motionAPI = MotionAPI()
	
	public func search() {
		let motionCell1 = MotionCell(x: 0, y: 3)
		let motionCell2 = MotionCell(x: 0, y: 5)
		let motionCells = [motionCell1, motionCell2]
		
		motionAPI.searchMotion(motionCells: motionCells, startTimeSec: 1547848281, endTimeSec: 1547851881) { (status, motionZones: [[Int]]) in
			
			// Check status to see whether if loaded successfully
			if status {
				motionZones.forEach({ (motionCoord) in
					let motionResult = MotionResult(dateUTC: motionCoord[0], duration: motionCoord[1])
					print("motionCoord is \(String(describing: motionResult))")
					
					// Store the result
					self.motionResults.append(motionResult)
				})
				
				// Re-display thumbnail
				self.updateThumbnail()
				
			} else {
				self.homeView?.displayNoResult()
			}
		}
	}
	
	public func retrieveImage(index: Int) -> Data {
		
		// Create Image Data
		let previewImage = UIImage(named: "Preview")
		let previewData = previewImage!.pngData()!
		
		// Check for image name
		if motionResults.count <= index {
			return previewData
		}
		
		let imageName = motionResults[index].imageName
		if imageName == "" {
			return previewData
		}
		
		// Check for image
		if let imageData = self.motionResults[index].imageData {
			return imageData
		} else {
			// Retrieve the image
			motionAPI.retrieveImage(imageName: imageName) { (imageData) in
				self.motionResults[index].imageData = imageData
				self.updateThumbnail()
			}
			
			return previewData
		}
	}
	
	public func storeGrid(gridX: Int, gridY: Int) {
		
		// Add selected grid
		let motionCell = MotionCell(x: gridX, y: gridY)
		motionCells.append(motionCell)
	}
	
	public func removeGrid(gridX: Int, gridY: Int) {
		
		// Remove deselected grid
		motionCells = motionCells.filter { (motionCell) -> Bool in
			return (motionCell.x != gridX) && (motionCell.y != gridY)
		}
	}
	
	public func clearSearch() {
		motionCells.removeAll()
	}
	
	// Private Method
	
	private func updateThumbnail() {
		DispatchQueue.main.async {
			self.homeView?.reloadThumbnail(thumbnailCount: self.motionResults.count)
		}
	}
}
