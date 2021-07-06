//
//  Rx+.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/05.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController{
    var viewDidload: ControlEvent<Void>{
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Void>{
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
        return ControlEvent(events: source)
    }
}

extension ObservableType {
    func unwrap<Result>() -> Observable<Result> where E == Result? {
        return self.filter { $0 != nil }.map { $0! }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

