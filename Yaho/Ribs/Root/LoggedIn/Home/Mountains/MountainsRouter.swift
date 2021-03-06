//
//  MountainsRouter.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/17.
//

import RIBs

protocol MountainsInteractable: Interactable {
    var router: MountainsRouting? { get set }
    var listener: MountainsListener? { get set }
}

protocol MountainsViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func replaceModal(viewController: ViewControllable?)
    func dismiss(viewController: ViewControllable)
}

final class MountainsRouter: ViewableRouter<MountainsInteractable, MountainsViewControllable>, MountainsRouting {
    private let selected: SelectedBuildable
    private var selectedChild: SelectedRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: MountainsInteractable, viewController: MountainsViewControllable, selected: SelectedBuildable) {
        self.selected = selected
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
