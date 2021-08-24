//
//  Record.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/22.
//

import Foundation

extension Model {
    struct Record: Codable, Equatable {
        let id: String
        let mountainID  : String
        let mountainName: String
        let visitCount  : Int
        let date        : Date
        let totalTime   : Int
        let runningTime : Int
        let distance    : Double
        let calrories   : Double
        let maxSpeed    : Double
        let averageSpeed: Double
        let startHeight : Double
        let maxHeight   : Double
        let section     : [Model.Record.SectionHiking]?
        let points      : [Model.Record.HikingPoint]?
        
        enum CodingKeys: String,CodingKey {
            case id = "recordId"
            case mountainID = "mountainId"
            case mountainName = "mountainName"
            case visitCount   = "mountainVisitCount"
            case date         = "climbingDate"
            case totalTime    = "allRunningTime"
            case runningTime  = "totalClimbingTime"
            case distance     = "totalDistance"
            case calrories    = "totalCalrories"
            case maxSpeed     = "maxSpeed"
            case averageSpeed = "averageSpeed"
            case startHeight  = "startHeight"
            case maxHeight    = "maxHeight"
            case section
            case points
        }
        
         init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id           = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
            self.mountainID   = try container.decodeIfPresent(String.self, forKey: .mountainID) ?? ""
            self.mountainName = try container.decodeIfPresent(String.self, forKey: .mountainName) ?? ""
            self.visitCount   = try container.decodeIfPresent(Int.self, forKey: .visitCount) ?? 0
            self.date         = try container.decodeIfPresent(Date.self, forKey: .date) ?? Date()
            self.totalTime    = try container.decodeIfPresent(Int.self, forKey: .totalTime) ?? 0
            self.runningTime  = try container.decodeIfPresent(Int.self, forKey: .runningTime) ?? 0
            self.distance     = try container.decodeIfPresent(Double.self, forKey: .distance) ?? 0.0
            self.calrories    = try container.decodeIfPresent(Double.self, forKey: .calrories) ?? 0.0
            self.maxSpeed     = try container.decodeIfPresent(Double.self, forKey: .maxSpeed) ?? 0.0
            self.averageSpeed = try container.decodeIfPresent(Double.self, forKey: .averageSpeed) ?? 0.0
            self.startHeight  = try container.decodeIfPresent(Double.self, forKey: .startHeight) ?? 0.0
            self.maxHeight    = try container.decodeIfPresent(Double.self, forKey: .maxHeight) ?? 0.0
            self.section      = try container.decodeIfPresent([SectionHiking].self, forKey: .section)
            self.points       = try container.decodeIfPresent([HikingPoint].self, forKey: .points)
         }
        
        init(id: String, mountainID: String, mountainName: String, visitCount: Int, date: Date, totalTime: Int, runningTime : Int, distance: Double, calrories: Double, maxSpeed: Double, averageSpeed: Double, startHeight: Double, maxHeight: Double, section: [SectionHiking], points: [HikingPoint]) {
            self.id = id
            self.mountainID = mountainID
            self.mountainName = mountainName
            self.visitCount = visitCount
            self.date = date
            self.totalTime = totalTime
            self.runningTime = runningTime
            self.distance = distance
            self.calrories = calrories
            self.maxSpeed = maxSpeed
            self.averageSpeed = averageSpeed
            self.startHeight = startHeight
            self.maxHeight = maxHeight
            self.section = section
            self.points = points
        }

        var asDictionary: [String: Any] {
            return ["recordId"     : self.id,
                    "mountainId"   : self.mountainID,
                    "mountainName" : self.mountainName,
                    "mountainVisitCount" : self.visitCount,
                    "climbingDate"       : self.date,
                    "allRunningTime"     : self.totalTime,
                    "totalClimbingTime"  : self.runningTime,
                    "totalDistance"      : self.distance,
                    "totalCalrories"     : self.calrories,
                    "maxSpeed"           : self.maxSpeed,
                    "averageSpeed"       : self.averageSpeed,
                    "startHeight"        : self.startHeight,
                    "maxHeight"          : self.maxHeight,
                    "section"            : self.section?.map { $0.asDictionary },
                    "points"             : self.points?.map { $0.asDictionary }
            ]
        }
    }
}


extension Model.Record {
    struct SectionHiking: Codable, Equatable {
        let id         : Int //sectionId
        let runningTime: Int
        let distance   : Double
        let calrories  : Double
        let restIndex  : Int
        
        enum CodingKeys: String,CodingKey {
            case id = "sectionId"
            case runningTime, distance, calrories, restIndex
        }
        
        init(id: Int, runningTime: Int, distance: Double, calrories: Double, restIndex: Int) {
            self.id = id
            self.runningTime = runningTime
            self.distance    = distance
            self.calrories   = calrories
            self.restIndex   = restIndex
        }
        
        var asDictionary: [String: Any] {
            return ["sectionId"     : self.id,
                    "runningTime"   : self.runningTime,
                    "distance"      : self.distance,
                    "calrories"     : self.calrories,
                    "restIndex"     : self.restIndex
            ]
        }
    }
    
    struct HikingPoint: Codable, Equatable {
        let parentSectionID: Int //parentSectionId
        let latitude       : Double
        let longitude      : Double
        let altitude       : Double
        let speed          : Double
        let timeStamp      : Date
        let distance       : Double
        
        enum CodingKeys: String,CodingKey {
            case parentSectionID = "parentSectionId"
            case latitude, longitude, altitude, speed, timeStamp, distance
        }
        
        init(id: Int, latitude: Double, longitude: Double, altitude: Double, speed: Double, timeStamp: Date, distance: Double) {
            self.parentSectionID = id
            self.latitude = latitude
            self.longitude = longitude
            self.altitude = altitude
            self.speed = speed
            self.timeStamp = timeStamp
            self.distance = distance
        }
        
        var asDictionary: [String: Any] {
            return ["parentSectionId" : self.parentSectionID,
                    "latitude"        : self.latitude,
                    "longitude"       : self.longitude,
                    "altitude"        : self.altitude,
                    "speed"           : self.speed,
                    "timeStamp"       : self.timeStamp,
                    "distance"        : self.distance
            ]
        }
    }
}
