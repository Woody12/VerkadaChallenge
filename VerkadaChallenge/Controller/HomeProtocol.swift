//
//  HomeProtocol.swift
//  VerkadaChallenge
//
//  Created by Woody Lee on 1/19/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import Foundation

protocol HomeViewProtocol {
	
}

protocol HomePresenterProtocol {
	func storeGrid(gridX: Int, gridY: Int)
	func removeGrid(gridX: Int, gridY: Int)
	func clearSearch()
}
	
