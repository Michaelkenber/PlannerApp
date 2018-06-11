//
//  transport.swift
//  PlannerApp
//
//  Created by Michael Berend on 11/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import Foundation

struct TransportType: Equatable {
    var id: Int
    var name: String
    
    static var all: [TransportType] {
        return[TransportType(id: 0, name: "Walking"), TransportType(id: 1, name: "Bycicle"), TransportType(id: 2, name: "Car"), TransportType(id: 3, name: "Train")]
    }
}

func == (lhs: TransportType, rhs: TransportType) -> Bool {
    return lhs.id == rhs.id
}
