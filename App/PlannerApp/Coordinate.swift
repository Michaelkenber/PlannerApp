//
//  Coordinate.swift
//  PlannerApp
//
//  Created by Michael Berend on 27/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//
// A coordinate struct that holds the coordinates and place names and confirms to the codable protocol

import Foundation

struct Coordinate: Codable {
    
    var latitude: Double
    var longitude: Double
    var placeName: String
}
