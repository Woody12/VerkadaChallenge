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
	
	static func display(dateStyle: DateFormatter.Style = .long, timeStyle: DateFormatter.Style = .long, date: Date) -> String {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = dateStyle
		
		let timeFormatter = DateFormatter()
		timeFormatter.timeStyle = timeStyle
		
		let dateSelected = dateFormatter.string(from: date)
		let timeSelected = timeFormatter.string(from: date)
		
		return(dateSelected + " " + timeSelected)
	}
}
