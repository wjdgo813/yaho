//
//  RecordDataSource.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/26.
//

import RxDataSources

enum RecordCellType {
    case naviBar
    case modalBar
    case mapView
    case section
    case detailTime
    case detailDistance
    case detailCalrory
    case detailPace
    case detailAltitude
}

struct RecordModel {
    var items: [RecordCellType]
}

extension RecordModel: SectionModelType {
    var identity: String { "RecordModel" }
    init(original: RecordModel, items: [RecordCellType]) {
        self = original
        self.items = items
    }
}
