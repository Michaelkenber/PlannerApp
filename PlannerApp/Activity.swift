//
//  Activity.swift
//  PlannerApp
//
//  Created by Michael Berend on 11/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import Foundation
import GooglePlaces


struct Activity {
    var activity: String
    var time: Date
    var location: String
    var transport: String
    var timeString: String
    var coordinates: CLLocation
    //var preferences: [String]
    
    static func < (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.time < rhs.time
    }
}


