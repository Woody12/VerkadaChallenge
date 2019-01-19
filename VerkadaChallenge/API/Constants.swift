//
//  Constants.swift
//  VerkadaChallenge
//
//  Created by Woody Lee on 1/18/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import Foundation

public let APIServer = "http://ec2-54-187-236-58.us-west-2.compute.amazonaws.com:8021"
public let ImageResult = "/ios/thumbnail/"
public let SearchQuery = "/ios/search"

public let MinX = 0
public let MinY = 0
public let MaxX = 9
public let MaxY = 9
public let TotalGrid = ((MinX + MaxX) + 1) * ((MinY + MinY) + 1)
