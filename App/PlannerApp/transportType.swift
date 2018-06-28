//
//  transport.swift
//  PlannerApp
//
//  Created by Michael Berend on 11/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//
// This is a struct for the transport type that confirms to the equatable protocol

import Foundation


struct TransportType: Equatable {
    var id: Int
    var name: String
    
    static var all: [TransportType] {
        return[TransportType(id: 0, name: "walking"), TransportType(id: 1, name: "bicycling"), TransportType(id: 2, name: "driving"), TransportType(id: 3, name: "transit")]
    }
}

// Make the transport type comparable by id
func == (lhs: TransportType, rhs: TransportType) -> Bool {
    return lhs.id == rhs.id
}
