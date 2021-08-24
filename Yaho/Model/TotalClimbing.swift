//
//  TotalClimbing.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/13.
//

import Foundation
extension Model {
    struct TotalClimbing: Codable, ParsingProtocol {
        let allDistance: Double
        let allHeight  : Double
        let allTime    : Int
        let totalCount : Int
        
        init(allDistance: Double = 0.0, allHeight: Double = 0.0, allTime: Int = 0, totalCount: Int = 0) {
            self.allDistance = allDistance
            self.allHeight   = allHeight
            self.allTime     = allTime
            self.totalCount  = totalCount
        }
        
        var asDictionary: [String: Any] {
            return ["allDistance": self.allDistance,
                    "allHeight"  : self.allHeight,
                    "allTime"    : self.allTime,
                    "totalCount" : self.totalCount]
        }
    }

}
