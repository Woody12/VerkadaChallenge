//
//  Constants.swift
//  VerkadaChallenge
//
//  Created by Woody Lee on 1/18/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import Foundation

// Server Information
public let APIServer = "http://ec2-54-187-236-58.us-west-2.compute.amazonaws.com:8021"
public let ImageResult = "/ios/thumbnail/"
public let SearchQuery = "/ios/search"

// Grid Information
public let NumRow = 10
public let NumCol = 10
public let TotalGrid = NumRow * NumCol

// Collection Cell
public let GridReuse = "GridID"
public let ThumbnailReuse = "MotionCollectionID"
public let EmbedSegue = "EmbedContainerID"

// Search Parameter
public let DefaultHourLag: Double = 3600
