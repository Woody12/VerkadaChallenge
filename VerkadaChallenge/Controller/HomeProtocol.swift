//
//  HomeProtocol.swift
//  VerkadaChallenge
//
//  Created by Woody Lee on 1/19/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import Foundation
import UIKit

protocol HomeViewProtocol: class {
	var presenter: HomePresenterProtocol? { get set }
	
	func displayCamImage(camImage: UIImage?)
	func reloadThumbnail(thumbnailCount: Int)
	func displayNoResult()
}

protocol HomePresenterProtocol: class {
	var homeView: HomeViewProtocol? { get set }
	
	func search()
	func storeGrid(gridX: Int, gridY: Int)
	func removeGrid(gridX: Int, gridY: Int)
	func clearSearch()
	
	func retrieveImage(index: Int) -> Data
	func retrieveInfo(index: Int) -> String?
}
