//
//  HikingRouter.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/09.
//

import RIBs

protocol HikingInteractable: Interactable {
    var router: HikingRouting? { get set }
    var listener: HikingListener? { get set }
}

protocol HikingViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class HikingRouter: ViewableRouter<HikingInteractable, HikingViewControllable>, HikingRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: HikingInteractable, viewController: HikingViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
