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
}

final class MountainsRouter: ViewableRouter<MountainsInteractable, MountainsViewControllable>, MountainsRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MountainsInteractable, viewController: MountainsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
