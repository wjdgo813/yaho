//
//  TotalClimbing.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/13.
//

import Foundation

struct TotalClimbing {
    let allDistance: Double
    let allHeight  : Double
    let allTime    : Int
    let totalCount : Int
    
    init() {
        self.allDistance = 0.0
        self.allHeight   = 0.0
        self.allTime     = 0
        self.totalCount  = 0
    }
    
    var asDictionary: [String: Any] {
        return ["allDistance": self.allDistance,
                "allHeight"  : self.allHeight,
                "allTime"    : self.allTime,
                "totalCount" : self.totalCount]
    }
}
