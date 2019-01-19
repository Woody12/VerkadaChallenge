//
//  MotionAPI.swift
//  VerkadaChallenge
//
//  Created by Woody Lee on 1/18/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import Foundation

class MotionAPI: NSObject {
	
	public func searchMotion(motionCells: [MotionCell]?, startTimeSec: Double?, endTimeSec: Double?) {
	
		// Construct parameters
		guard let paramString = createSearchParameters(motionCells: motionCells, startTimeSec: startTimeSec, endTimeSec: endTimeSec) else {
			print("Invalid parameters")
			return
		}
		
		print("Param is \(paramString)")
		
		// Formulate API Query
		var urlRequest = URLRequest(url: URL(string: APIServer + SearchQuery)! as URL)
		urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
		urlRequest.httpMethod = "POST"
		urlRequest.httpBody = paramString.data(using: .utf8)
		urlRequest.timeoutInterval = 10
		
		// Run query
		let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
			
			if let data = data {
				do {
					// Convert data to JSON
					let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
					
					if let jsonResult = jsonSerialized,
						let motionZones = jsonResult["motionAt"] as? [[Int]] {
						
						motionZones.forEach({ (motionCoord) in
							let motionCell = MotionCell(x: motionCoord[0], y: motionCoord[1])
							print("motionCoord is \(String(describing: motionCell))")
						})
						
						print("next end time sec is \(String(describing: jsonResult["nextEndTimeSec"]))")
					}
					
				} catch let error as NSError {
					
					// Log Error
					print(error.localizedDescription)
					
				}
			} else {
				
				// Log Error
				if let error = error {
					print(error.localizedDescription)
					
				}
			}
		}
		
		// Begin download
		task.resume()
	}
	
	
	// Private Method
	private func createSearchParameters(motionCells: [MotionCell]?, startTimeSec: Double?, endTimeSec: Double?) -> String? {
		
		// Verify parameters
		guard let motionCells = motionCells, let startTimeSec = startTimeSec, let endTimeSec = endTimeSec else {
			return nil
		}
		
		if motionCells.count == 0 {
			return nil
		}
		
		// Retrieve motion cell
		var motionZones = "["
		motionCells.forEach { (motionCell) in
			motionZones = motionZones + ((motionZones.count > 1) ? "," : "")
			
			let x = String(motionCell.x)
			let y = String(motionCell.y)
			motionZones = motionZones + "[\(x),\(y)]"
		}
		
		motionZones = motionZones + "]"
		
		let paramString = "{\"motionZones\":\(motionZones),\"startTimeSec\": \(Int(startTimeSec)),\"endTimeSec\": \(Int(endTimeSec))}"
		
		return paramString
	}
}
