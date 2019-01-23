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
	

	public func search(startTimeDate: Date, endTimeDate: Date) {
//		let motionCell1 = MotionCell(x: 0, y: 3)
//		let motionCell2 = MotionCell(x: 0, y: 5)
		//let motionCells = [motionCell1, motionCell2]
		//1547848281
		//1547851881
		// Create Default motion grid
		if motionCells.count == 0 {
			let motionCell1 = MotionCell(x: 0, y: 3)
			let motionCell2 = MotionCell(x: 0, y: 5)
			motionCells.append(motionCell1)
			motionCells.append(motionCell2)
		}
		//Param is {"motionZones":[[0,0],[0,1]],"startTimeSec": 1548176238,"endTimeSec": 1548179838}
		
		// Create UTC Date
		let startTimeSec = startTimeDate.timeIntervalSince1970
		let endTimeSec = endTimeDate.timeIntervalSince1970
		
		motionAPI.searchMotion(motionCells: motionCells, startTimeSec: startTimeSec, endTimeSec: endTimeSec) { (status, motionZones: [[Int]]) in
			
			// Check status to see whether if loaded successfully
			if (status && motionZones.count > 0) {
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
	
	public func retrieveInfo(index: Int) -> String? {
		
		// Check for image name
		if motionResults.count <= index {
			return nil
		}
		
		let dateUTC = Double(motionResults[index].dateUTC)
		let date = Date.display(dateStyle: .short, timeStyle: .short, date: Date(timeIntervalSince1970: dateUTC))
		
		return "\(date) \(motionResults[index].duration) secs"
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
