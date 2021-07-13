//
//  LoggedInInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/06.
//

import RIBs
import RxSwift

protocol LoggedInRouting: Routing {
    func cleanupViews()
    func routeToHome()
}

protocol LoggedInListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class LoggedInInteractor: Interactor, LoggedInInteractable {

    weak var router: LoggedInRouting?
    weak var listener: LoggedInListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init() {}

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        self.router?.routeToHome()
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
}
