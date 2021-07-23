//
//  RootRouter.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/06/27.
//

import RIBs
import FirebaseAuth

protocol RootInteractable: Interactable, LoggedOutListener, LoggedInListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func replaceModal(viewController: ViewControllable?)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    private let loggedOutBuilder: LoggedOutBuildable
    private let loggedInBuilder: LoggedInBuildable
    
    private var loggedOut: ViewableRouting?
    private var loggedIn: LoggedInRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         loggedOutBuilder: LoggedOutBuildable,
         loggedInBuilder: LoggedInBuildable) {
        self.loggedOutBuilder = loggedOutBuilder
        self.loggedInBuilder  = loggedInBuilder
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    func routeToLoggedOut() {
        
        if let child = loggedIn {
            detachChild(child)
        }

        if self.loggedOut == nil {
            self.loggedOut = self.loggedOutBuilder.build(withListener: self.interactor)
        }

        guard let loggedOut = self.loggedOut else { fatalError("failed to allocate rib") }

        self.attachChild(loggedOut)
        self.viewController.replaceModal(viewController: loggedOut.viewControllable)
    }
    
    func routeToLoggedIn(user: User, mountains: [Mountain]) {
        if let child = self.loggedOut {
            self.detachChild(child)
            viewController.replaceModal(viewController: nil)
            self.loggedOut = nil
        }
        
        self.loggedIn = self.loggedInBuilder.build(withListener: self.interactor, userSession: user, mountains: mountains)
        guard let loggedIn = self.loggedIn else { fatalError("failed to allocate rib") }
        self.attachChild(loggedIn)
        self.viewController.replaceModal(viewController: loggedIn.viewControllable)
    }
}
