//
//  RootInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/06/27.
//

import RIBs
import RxSwift
import RxCocoa
import FirebaseAuth.FIRUser

protocol RootRouting: ViewableRouting {
    func routeToLoggedIn(user: User)
    func routeToLoggedOut()
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
    private let service: MainServiceProtocol
    private let mutableMountainsStream: MutableMountainsStream
    
    private let loggedIn  = PublishRelay<User>()
    private let loggedInActionableItemSubject = ReplaySubject<LoggedInActionableItem>.create(bufferSize: 1)
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: RootPresentable, service: MainServiceProtocol, mutableMountainsStream: MutableMountainsStream) {
        self.mutableMountainsStream = mutableMountainsStream
        self.service = service
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchMountains()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didLogin(with user: User) {
        self.loggedIn.accept(user)
    }
    
    private func fetchMountains() {
        
        self.service.rxMountains()
            .debug("[RootInteractor] fetchMountains")
            .subscribe(onNext: { [weak self] mountains in
                self?.mutableMountainsStream.updateMountains(with: mountains)
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    
}
