//
//  RecordListRouter.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/09/04.
//

import RIBs

protocol RecordListInteractable: Interactable {
    var router: RecordListRouting? { get set }
    var listener: RecordListListener? { get set }
}

protocol RecordListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RecordListRouter: ViewableRouter<RecordListInteractable, RecordListViewControllable>, RecordListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RecordListInteractable, viewController: RecordListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
