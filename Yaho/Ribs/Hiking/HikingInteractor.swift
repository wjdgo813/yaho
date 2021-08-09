//
//  HikingInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/09.
//

import RIBs
import RxSwift
import RxCocoa

protocol HikingRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol HikingPresentable: Presentable {
    var listener: HikingPresentableListener? { get set }
    func setTime(with time: String)
    func setDestination(with latitude: Double, longitude: Double)
}

protocol HikingListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class HikingInteractor: PresentableInteractor<HikingPresentable>, HikingInteractable, HikingPresentableListener {

    weak var router: HikingRouting?
    weak var listener: HikingListener?
    private let selectedStream: MountainStream
    
    private let hiking = PublishRelay<Bool>()
    private let time   = BehaviorRelay<Int>(value: 0)
    private var timeCount = 0

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: HikingPresentable, selected: MountainStream) {
        self.selectedStream = selected
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.setBind()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func viewDidLoad() {
        self.hiking.accept(true)
    }
}

extension HikingInteractor {
    private func setBind() {
        self.hiking
            .flatMap { isHiking in
                isHiking ? Observable<Int>.interval(1, scheduler: ConcurrentDispatchQueueScheduler(qos: .background)) : .empty()
            }
            .withLatestFrom(self.time)
            .map { time -> Int in
                return time + 1
            }
            .observeOn(MainScheduler.instance)
            .bind(to: self.time)
            .disposeOnDeactivate(interactor: self)
        
        self.time
            .filter { $0 > 0 }
            .map { $0.toTimeString() }
            .subscribe(onNext: { [weak self] time in
                self?.presenter.setTime(with: time)
            }).disposeOnDeactivate(interactor: self)
        
        self.selectedStream.mountain
            .unwrap()
            .subscribe(onNext: { [weak self] mountain in
                self?.presenter.setDestination(with: mountain.latitude,
                                               longitude: mountain.longitude)
            }).disposeOnDeactivate(interactor: self)
    }
}
