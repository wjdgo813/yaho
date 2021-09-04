//
//  HomeRouter.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/13.
//

import RIBs

protocol HomeInteractable: Interactable, MountainsListener, SelectedListener, TripListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {
    func replaceModal(viewController: ViewControllable?)
    func present(viewController: ViewControllable?)
    func dismiss(viewController: ViewControllable?, completion: (()->())?)
    func popToRootViewController(completion: (() -> Void)?)
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {
    
    private let mountainsBuilder: MountainsBuildable
    private let selectedBuilder : SelectedBuildable
    private let tripBuilder     : TripBuildable
    
    private var currentChild: Routing?
    private var childs: [Routing] = []
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: HomeInteractable,
         viewController: HomeViewControllable,
         mountain: MountainsBuildable,
         selected: SelectedBuildable,
         trip    : TripBuildable) {
        self.mountainsBuilder = mountain
        self.selectedBuilder  = selected
        self.tripBuilder      = trip
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func cleanupViews(completion: (() -> Void)?) {
        self.viewController.popToRootViewController(completion: completion)
        self.detachCurrentChild()
        self.children.forEach { self.detachChild($0)}
    }
    
    private func detachCurrentChild(completion: (()->())? = nil) {
        if let currentChild = currentChild {
            self.detachChild(currentChild)
            self.currentChild = nil
        }
    }
}

// MARK: Mountains
extension HomeRouter {
    func homeToMountains() {
        let mountains = self.mountainsBuilder.build(withListener: self.interactor)
        self.currentChild = mountains
        self.attachChild(mountains)
        self.viewController.replaceModal(viewController: mountains.viewControllable)
    }
    
    func closeMountains() {
        self.detachCurrentChild()
        self.viewController.replaceModal(viewController: nil)
    }
}

// MARK: Selected
extension HomeRouter {
    func mountainsToSelected(with mountain: Model.Mountain) {
        let selected = self.selectedBuilder.build(withListener: self.interactor)
        self.currentChild = selected
        self.attachChild(selected)
        self.viewController.replaceModal(viewController: selected.viewControllable)
    }
    
    func closeSelected() {
        self.detachCurrentChild()
        self.viewController.replaceModal(viewController: nil)
    }
}

// MARK: Trip
extension HomeRouter {
    func selectedToTrip(with mountain: Model.Mountain) {
        self.cleanupViews { [weak self] in
            guard let self = self else { return }
            let trip = self.tripBuilder.build(withListener: self.interactor)
            self.currentChild = trip
            self.attachChild(trip)
        }
    }
    
    func closeTrip() {
        self.detachCurrentChild()
        self.children.forEach { self.detachChild($0)}
    }
}
