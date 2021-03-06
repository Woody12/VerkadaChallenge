//
//  MotionResult.swift
//  VerkadaChallenge
//
//  Created by Woody Lee on 1/22/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import Foundation
import UIKit

struct MotionResult {
	
	var dateUTC = 0
	var duration = 0
	var imageName = ""
	var image: UIImage?
	
	init(dateUTC: Int, duration: Int) {
		self.dateUTC = dateUTC
		self.duration = duration
		self.imageName = String(dateUTC) + ".jpg"
	}
}
