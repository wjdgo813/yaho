//
//  RecordListInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/09/04.
//

import RIBs
import RxSwift

protocol RecordListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RecordListPresentable: Presentable {
    var listener: RecordListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RecordListListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RecordListInteractor: PresentableInteractor<RecordListPresentable>, RecordListInteractable, RecordListPresentableListener {

    weak var router: RecordListRouting?
    weak var listener: RecordListListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RecordListPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
