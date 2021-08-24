//
//  MountainStream.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/25.
//

import RxSwift
import RxCocoa

// MARK: Model.Mountain
protocol MountainStream: AnyObject {
    var mountain: Observable<Model.Mountain?> { get }
}

protocol MutableMountainStream: MountainStream {
    func updateMountain(with mountain: Model.Mountain)
}

class MountainStreamImpl: MutableMountainStream {
    var mountain: Observable<Model.Mountain?> {
        self.variable.distinctUntilChanged().asObservable()
    }
    
    func updateMountain(with mountain: Model.Mountain) {
        self.variable.onNext(mountain)
    }
    
    private let variable = BehaviorSubject<Model.Mountain?>(value: nil)
}

// MARK: [Model.Mountain]
protocol MountainsStream: AnyObject {
    var mountains: Observable<[Model.Mountain]?> { get }
}

protocol MutableMountainsStream: MountainsStream {
    func updateMountains(with mountains: [Model.Mountain])
}

class MountainsStreamImpl: MutableMountainsStream {
    var mountains: Observable<[Model.Mountain]?> {
        return self.variable.asObservable()
            .distinctUntilChanged()
    }
    
    func updateMountains(with mountains: [Model.Mountain]) {
        self.variable.onNext(mountains)
    }
    
    private let variable = BehaviorSubject<[Model.Mountain]?>(value: nil)
}

