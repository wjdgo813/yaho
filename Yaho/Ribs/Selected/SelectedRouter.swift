//
//  SelectedRouter.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/25.
//

import RIBs

protocol SelectedInteractable: Interactable {
    var router: SelectedRouting? { get set }
    var listener: SelectedListener? { get set }
}

protocol SelectedViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SelectedRouter: ViewableRouter<SelectedInteractable, SelectedViewControllable>, SelectedRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SelectedInteractable, viewController: SelectedViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
