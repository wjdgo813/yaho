//
//  HomeDataSource.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/15.
//

import RxDataSources

enum HomeCellType: IdentifiableType {
    var identity: String { "" }
    case goHiking(title: String)
    case record(title: String)
    case removeAd(title: String, isRemove: Bool)
}

func getIdentity() -> String {
    return self.getIdentifier() ?? ""
}
