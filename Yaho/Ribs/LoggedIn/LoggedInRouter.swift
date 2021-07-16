//
//  LoggedInRouter.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/06.
//

import RIBs

protocol LoggedInInteractable: Interactable, HomeListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInViewControllable: ViewControllable {
    func replaceModal(viewController: ViewControllable?)
}

//ViewableRouter<DrawerInteractable, DrawerViewControllable>, DrawerRouting
final class LoggedInRouter: ViewableRouter<LoggedInInteractable, LoggedInViewControllable>, LoggedInRouting {

    private let homeBuilder: HomeBuildable
    private var homeChild  : HomeRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: LoggedInInteractable,
         viewController: LoggedInViewControllable,
         homeBuilder: HomeBuildable) {
        self.homeBuilder    = homeBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    func cleanupViews() {
        if self.homeChild != nil {
            self.viewController.replaceModal(viewController: nil)
        }
    }

    // MARK: - Private
    func routeToHome() {
        let home = homeBuilder.build(withListener: self.interactor)
        self.homeChild = home
        self.attachChild(home)
        self.viewController.replaceModal(viewController: self.homeChild?.viewControllable)
    }
    
    private func detachCurrentChild() {
        if let child = self.homeChild {
            self.detachChild(child)
            self.viewController.replaceModal(viewController: nil)
        }
    }
}
