//
//  MountainsInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/17.
//

import RIBs
import RxSwift

protocol MountainsRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MountainsPresentable: Presentable {
    var listener: MountainsPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MountainsListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MountainsInteractor: PresentableInteractor<MountainsPresentable>, MountainsInteractable, MountainsPresentableListener {

    weak var router: MountainsRouting?
    weak var listener: MountainsListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: MountainsPresentable) {
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
