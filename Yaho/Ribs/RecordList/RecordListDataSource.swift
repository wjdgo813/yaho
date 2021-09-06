//
//  RecordListDataSource.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/09/05.
//

import RxDataSources

enum RecordListCellType {
    case title(date: String)
    case date(date: String)
    case record(record: Model.Record)
}

struct RecordListModel {
    var items: [RecordListCellType]
}

extension RecordListModel: SectionModelType {
    var identity: String { "RecordListModel" }
    init(original: RecordListModel, items: [RecordListCellType]) {
        self = original
        self.items = items
    }
}
