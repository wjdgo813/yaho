//
//  VisitCountStream.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/27.
//

import RxSwift
import RxCocoa

// MARK: Model.Mountain
protocol VisitCountStream: AnyObject {
    var count: Observable<Int?> { get }
}

protocol MutableVisitCountStream: VisitCountStream {
    func updateCount(with count: Int)
}

class VisitCountStreamImpl: MutableVisitCountStream {
    var count: Observable<Int?> {
        self.variable.distinctUntilChanged().asObservable()
    }
    
    func updateCount(with count: Int) {
        self.variable.onNext(count)
    }
    
    private let variable = BehaviorSubject<Int?>(value: nil)
}
