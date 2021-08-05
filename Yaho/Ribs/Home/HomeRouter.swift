//
//  HomeRouter.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/13.
//

import RIBs

protocol HomeInteractable: Interactable, MountainsListener, SelectedListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {
    func replaceModal(viewController: ViewControllable?)
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {
    
    private let mountainsBuilder: MountainsBuildable
    private let selectedBuilder: SelectedBuildable
    
    private var mountainsChild  : MountainsRouting?
    private var selectedChild: SelectedRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: HomeInteractable,
         viewController: HomeViewControllable,
         mountain: MountainsBuildable,
         selected: SelectedBuildable) {
        self.mountainsBuilder = mountain
        self.selectedBuilder  = selected
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func cleanupViews() {
        if self.mountainsChild != nil {
            self.viewController.replaceModal(viewController: nil)
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
        self.self.selectedChild = nil
    }
}
