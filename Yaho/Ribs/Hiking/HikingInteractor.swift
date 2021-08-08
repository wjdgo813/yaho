//
//  HikingInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/09.
//

import RIBs
import RxSwift

protocol HikingRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol HikingPresentable: Presentable {
    var listener: HikingPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol HikingListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class HikingInteractor: PresentableInteractor<HikingPresentable>, HikingInteractable, HikingPresentableListener {

    weak var router: HikingRouting?
    weak var listener: HikingListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: HikingPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
