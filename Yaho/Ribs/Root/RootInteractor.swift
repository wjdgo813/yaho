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
    func routeToLoggedIn(user: User, mountains: [Model.Mountain])
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
    private let service: StoreServiceProtocol
    
    private let loggedIn  = PublishRelay<User>()
    private let mountains = BehaviorRelay<[Model.Mountain]?>(value: nil)
    private let loggedInActionableItemSubject = ReplaySubject<LoggedInActionableItem>.create(bufferSize: 1)
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: RootPresentable, service: StoreServiceProtocol) {
        self.service = service
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.setBind()
        self.authUser()
        self.fetchMountains()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func setBind() {
        Observable.combineLatest(self.loggedIn, self.mountains.unwrap()) { ($0,$1) }
            .debug("[RootInteractor] routeToLoggedIn")
            .subscribe(onNext: {  [weak self] (user, mountains) in
                self?.router?.routeToLoggedIn(user: user, mountains: mountains)
            }).disposeOnDeactivate(interactor: self)
    }
    
    func didLogin(with user: User) {
        self.loggedIn.accept(user)
    }
    
    private func fetchMountains() {
        self.service.rxMountains()
            .debug("[RootInteractor] fetchMountains")
            .bind(to: self.mountains)
            .disposeOnDeactivate(interactor: self)
    }
    
    private func authUser() {
        if let user = Auth.auth().currentUser {
            self.loggedIn.accept(user)
        } else {
            self.router?.routeToLoggedOut()
        }
    }
}
