//
//  TripInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/07.
//

import RIBs
import RxSwift

protocol TripRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TripPresentable: Presentable {
    var listener: TripPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol TripListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class TripInteractor: PresentableInteractor<TripPresentable>, TripInteractable, TripPresentableListener {

    weak var router: TripRouting?
    weak var listener: TripListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: TripPresentable) {
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
