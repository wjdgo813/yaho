//
//  LoggedInInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/06.
//

import RIBs
import RxSwift

protocol LoggedInRouting: ViewableRouting {
    func cleanupViews()
    func loggedInToHome()
}

protocol LoggedInPresentable: Presentable {
    var listener: LoggedInPresentableListener? { get set }
}

protocol LoggedInListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class LoggedInInteractor: PresentableInteractor<LoggedInPresentable>, LoggedInInteractable, LoggedInPresentableListener {

    weak var router: LoggedInRouting?
    weak var listener: LoggedInListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: LoggedInPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        self.router?.loggedInToHome()
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
}
