//
//  RecordStream.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/25.
//

import RxSwift
import RxCocoa

protocol RecordStream: AnyObject {
    var record: Observable<Model.Record?> { get }
}

protocol MutableRecordStream: RecordStream {
    func updateRecord(with mountain: Model.Record)
}

class RecordStreamImpl: MutableRecordStream {
    var record: Observable<Model.Record?> {
        self.variable.asObservable()
    }
    
    func updateRecord(with mountain: Model.Record) {
        self.variable.onNext(mountain)
    }
    
    private let variable = BehaviorSubject<Model.Record?>(value: nil)
}
