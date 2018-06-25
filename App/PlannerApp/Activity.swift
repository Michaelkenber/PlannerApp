//
//  Activity.swift
//  PlannerApp
//
//  Created by Michael Berend on 11/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import Foundation
import GooglePlaces


struct Activity: Equatable, Comparable {
    var activity: String
    var time: Date
    var endTime: Date
    var location: String
    var transport: String
    var timeString: String
    var endTimeString: String
    var coordinates: CLLocation
    var travelTime: Int
    var type: String
    //var preferences: [String]
    
    static func < (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.time < rhs.time
    }
    
    static func ==(lhs: Activity, rhs: Activity) -> Bool {
        return lhs.activity == rhs.activity && lhs.time ==
            rhs.time && lhs.endTime == rhs.endTime &&
            lhs.location == rhs.location && lhs.transport ==
            rhs.transport && lhs.timeString == rhs.timeString &&
            lhs.endTimeString == rhs.endTimeString && lhs.coordinates ==
            rhs.coordinates && lhs.travelTime == rhs.travelTime &&
            lhs.type == rhs.type
    }
}


