//
//  TripRouter.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/07.
//

import RIBs

protocol TripInteractable: Interactable, CountListener, HikingListener, RecordListener {
    var router: TripRouting? { get set }
    var listener: TripListener? { get set }
}

protocol TripViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
    func replaceModal(viewController: ViewControllable?)
    func present(viewController: ViewControllable?)
    func dismiss(viewController: ViewControllable?, completion: (()->())?)
    func popToRootViewController(completion: (() -> Void)?)
}

final class TripRouter: Router<TripInteractable>, TripRouting {
    private let countBuild  : CountBuildable
    private let hikingBuild : HikingBuildable
    private let recordBuild : RecordBuildable
    
    private var currentChild: ViewableRouting?
    private let viewController: TripViewControllable
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: TripInteractable,
         viewController: TripViewControllable,
         count         : CountBuildable,
         hiking        : HikingBuildable,
         record        : RecordBuildable) {
        self.viewController = viewController
        self.countBuild     = count
        self.hikingBuild    = hiking
        self.recordBuild    = record
        
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
    
    func hikingToFinish() {
        self.detachCurrentChild { [weak self] in
            guard let self = self else { return }
            let record = self.recordBuild.build(withListener: self.interactor)
            self.currentChild = record
            self.attachChild(record)
            self.viewController.present(viewController: record.viewControllable)
        }
    }
    
    func closeRecord() {
        self.detachCurrentChild()
    }
    
    private func detachCurrentChild(completion: (()->())? = nil) {
        if let currentChild = currentChild {
            detachChild(currentChild)
//            self.currentChild = nil
            viewController.dismiss(viewController: currentChild.viewControllable, completion: completion)
        }
    }
    
}
