//
//  TripRouter.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/07.
//

import RIBs

protocol TripInteractable: Interactable, CountListener, HikingListener {
    var router: TripRouting? { get set }
    var listener: TripListener? { get set }
}

protocol TripViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
    func replaceModal(viewController: ViewControllable?)
    func present(viewController: ViewControllable?)
    func dismiss(viewController: ViewControllable?)
    func popToRootViewController(completion: (() -> Void)?)
}

final class TripRouter: Router<TripInteractable>, TripRouting {
    private let countBuild  : CountBuildable
    private let hikingBuild : HikingBuildable
    private var currentChild: ViewableRouting?
    private let viewController: TripViewControllable
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: TripInteractable,
         viewController: TripViewControllable,
         count         : CountBuildable,
         hiking        : HikingBuildable) {
        self.viewController = viewController
        self.countBuild     = count
        self.hikingBuild    = hiking
        
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
        // TODO: Since this router does not own its view, it needs to cleanup the views
        // it may have added to the view hierarchy, when its interactor is deactivated.
    }

    func TripToCount() {
        self.detachCurrentChild()
        
        let count = self.countBuild.build(withListener: self.interactor)
        self.currentChild = count
        self.attachChild(count)
        self.viewController.present(viewController: count.viewControllable)
    }
    
    func countToHiking() {
        self.detachCurrentChild()
        
        let hiking = self.hikingBuild.build(withListener: self.interactor)
        self.currentChild = hiking
        self.attachChild(hiking)
        self.viewController.present(viewController: hiking.viewControllable)
    }
    
    private func detachCurrentChild() {
        if let currentChild = currentChild {
            detachChild(currentChild)
            viewController.dismiss(viewController: currentChild.viewControllable)
        }
    }
    
}
