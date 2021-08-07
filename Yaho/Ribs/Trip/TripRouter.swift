//
//  TripRouter.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/07.
//

import RIBs

protocol TripInteractable: Interactable {
    var router: TripRouting? { get set }
    var listener: TripListener? { get set }
}

protocol TripViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TripRouter: ViewableRouter<TripInteractable, TripViewControllable>, TripRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TripInteractable, viewController: TripViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
