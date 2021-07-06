//
//  RootInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/06/27.
//

import RIBs
import RxSwift
import FirebaseAuth.FIRUser

protocol RootRouting: ViewableRouting {
    func routeToLoggedIn(user: User)
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RootListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {

    weak var router: RootRouting?
    weak var listener: RootListener?
    private let loggedInActionableItemSubject = ReplaySubject<LoggedInActionableItem>.create(bufferSize: 1)
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RootPresentable) {
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
    
    func didLogin(with user: User) {
        if let loggedInActionableItem = router?.routeToLoggedIn(user: user) {
            
        }
    }
}