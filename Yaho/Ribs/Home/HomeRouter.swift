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
    
    private var mountainsChild  : MountainsRouting?
    private var selectedChild   : SelectedRouting?
    private var tripChild       : TripRouting?
    
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
        
        self.children.forEach { routing in
            self.detachChild(routing)
            switch routing {
            case is MountainsBuildable:
                self.mountainsChild = nil
            case is SelectedBuildable:
                self.selectedChild = nil
            case is TripBuildable:
                self.tripChild = nil
            default:
                break
            }
        }
    }
}

// MARK: Mountains
extension HomeRouter {
    func homeToMountains() {
        let mountains = self.mountainsBuilder.build(withListener: self.interactor)
        self.mountainsChild = mountains
        self.attachChild(mountains)
        self.viewController.replaceModal(viewController: self.mountainsChild?.viewControllable)
    }
    
    func closeMountains() {
        guard let child = self.mountainsChild else { return }

        self.detachChild(child)
        self.viewController.replaceModal(viewController: nil)
        self.mountainsChild = nil
    }
}

// MARK: Selected
extension HomeRouter {
    func mountainsToSelected(with mountain: Model.Mountain) {
        let selected = self.selectedBuilder.build(withListener: self.interactor)
        self.selectedChild = selected
        self.attachChild(selected)
        self.viewController.replaceModal(viewController: self.selectedChild?.viewControllable)
    }
    
    func closeSelected() {
        guard let child = self.selectedChild else { return }
        self.detachChild(child)
        self.viewController.replaceModal(viewController: nil)
        self.selectedChild = nil
    }
}

// MARK: Trip
extension HomeRouter {
    func selectedToTrip(with mountain: Model.Mountain) {
        self.cleanupViews { [weak self] in
            guard let self = self else { return }
            let trip = self.tripBuilder.build(withListener: self.interactor)
            self.tripChild = trip
            self.attachChild(trip)
        }
    }
}
