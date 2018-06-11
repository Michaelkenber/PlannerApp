//
//  Activity.swift
//  PlannerApp
//
//  Created by Michael Berend on 11/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import Foundation

enum Transport {
    case car, walking, bycicle, train
}

struct Activity {
    var activity: String
    var time: Date
    var location: String
    var transport: Transport
    var preferences: [String]
}
