//
//  RecordListRouter.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/09/04.
//

import RIBs

protocol RecordListInteractable: Interactable, RecordListener {
    var router: RecordListRouting? { get set }
    var listener: RecordListListener? { get set }
}

protocol RecordListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func replaceModal(viewController: ViewControllable?)
}

final class RecordListRouter: ViewableRouter<RecordListInteractable, RecordListViewControllable>, RecordListRouting {

    private let recordBuilder: RecordBuildable
    private var currentChild: ViewableRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: RecordListInteractable,
         viewController: RecordListViewControllable,
         recordBuilder: RecordBuildable) {
        self.recordBuilder = recordBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    func selectedRecord() {
        self.detachCurrentChild { [weak self] in
            guard let self = self else { return }
            let record = self.recordBuilder.build(withListener: self.interactor)
            self.currentChild = record
            self.attachChild(record)
            self.viewController.replaceModal(viewController: record.viewControllable)
        }
    }
    
    func didCloseRecord() {
        self.detachCurrentChild()
    }
    
    private func detachCurrentChild(completion: (()->Void)? = nil) {
        if let currentChild = currentChild {
            detachChild(currentChild)
            self.currentChild = nil
            viewController.replaceModal(viewController: nil)
        }
        
        if let completion = completion { completion() }
    }
}
