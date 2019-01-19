//
//  ViewController.swift
//  VerkadaChallenge
//
//  Created by Woody Lee on 1/18/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		let motionAPI = MotionAPI()
		let motionCell1 = MotionCell(x: 0, y: 3)
		let motionCell2 = MotionCell(x: 0, y: 5)
		let motionCells = [motionCell1, motionCell2]
		
		motionAPI.searchMotion(motionCells: motionCells, startTimeSec: 1547848281, endTimeSec: 1547851881)
	}


	
}

