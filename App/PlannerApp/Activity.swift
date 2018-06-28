//
//  Activity.swift
//  PlannerApp
//
//  Created by Michael Berend on 11/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//
// An struct that holds an activity from the user

import Foundation
import GooglePlaces


struct Activity: Equatable, Comparable, Codable {
    var activity: String
    var time: Date
    var endTime: Date
    var location: String
    var transport: String
    var timeString: String
    var endTimeString: String
    var coordinates: Coordinate
    var travelTime: Int
    var type: String
    
    // Allow for time comparison between activities
    static func < (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.time < rhs.time
    }
    
    // Allow to check if activities are equal
    static func ==(lhs: Activity, rhs: Activity) -> Bool {
        return lhs.activity == rhs.activity && lhs.time ==
            rhs.time && lhs.endTime == rhs.endTime &&
            lhs.location == rhs.location && lhs.transport ==
            rhs.transport && lhs.timeString == rhs.timeString &&
            lhs.endTimeString == rhs.endTimeString && lhs.travelTime == rhs.travelTime &&
            lhs.type == rhs.type
    }
}


