//
//  DateUtil.swift
//  VerkadaChallenge
//
//  Created by Woody Lee on 1/18/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import Foundation

extension Date {
	private static let LastHrMilliSec: TimeInterval = 60 * 60
	
	static func forLastHour() -> Date {
		return Date(timeInterval: -1 * LastHrMilliSec, since: Date())
	}
}
