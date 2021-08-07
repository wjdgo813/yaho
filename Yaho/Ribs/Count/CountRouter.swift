//
//  CountRouter.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/05.
//

import RIBs

protocol CountInteractable: Interactable {
    var router: CountRouting? { get set }
    var listener: CountListener? { get set }
}

protocol CountViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CountRouter: ViewableRouter<CountInteractable, CountViewControllable>, CountRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CountInteractable, viewController: CountViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
