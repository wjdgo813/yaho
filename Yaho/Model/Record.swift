//
//  Record.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/22.
//

import Foundation

struct Record {
    let id: String //recordId
    let mountainID: String //mountainId
    let mountainName: String //mountainName
    let visitCount: Int //mountainVisitCount
    let date: Date //climbingDate
    let totalTime: Int //allRunningTime
    let runningTime: Int //totalClimbingTime
    let distance: Float //totalDistance
    let calrories: Float //totalCalrories
    let maxSpeed: Float //maxSpeed
    let averageSpeed: Float //averageSpeed
    let startHeight: Float //startHeight
    let maxHeight: Float //maxHeight
}

struct SectionHiking {
    let id         : Int //sectionId
    let runningTime: Int
    let distance   : Double
    let calrories  : Double
    let restIndex  : Int
}

struct RestingPoint {
    let parentSectionID: Int //parentSectionId
    let latitude       : Double
    let longitude      : Double
    let altitude       : Double
    let speed          : Double
    let timeStamp      : Int
    let distance       : Double
}
 
