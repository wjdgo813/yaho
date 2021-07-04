//
//  RootRouter.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/06/27.
//

import RIBs

protocol RootInteractable: Interactable, LoggedOutListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func replaceModal(viewController: ViewControllable?)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    func routeToLoggedIn() {
        
    }
    

    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOut: ViewableRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         loggedOutBuilder: LoggedOutBuildable) {
        self.loggedOutBuilder = loggedOutBuilder
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        self.routeToLoggedOut()
    }
    
    private func routeToLoggedOut() {
        let loggedOut = self.loggedOutBuilder.build(withListener: self.interactor)
        self.loggedOut = loggedOut
        self.attachChild(loggedOut)
        self.viewController.replaceModal(viewController: loggedOut.viewControllable)
    }
}
