//
//  RecordInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/26.
//

import RIBs
import RxSwift
import RxCocoa

protocol RecordRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RecordPresentable: Presentable {
    var listener: RecordPresentableListener? { get set }
    func setRecord(with record: Model.Record)
}

protocol RecordListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RecordInteractor: PresentableInteractor<RecordPresentable>, RecordInteractable, RecordPresentableListener {

    weak var router: RecordRouting?
    weak var listener: RecordListener?
    private let recordStream: RecordStream
    private let didLoad = PublishRelay<Void>()
    
    init(presenter: RecordPresentable, recordStream: RecordStream) {
        self.recordStream = recordStream
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.didLoad.subscribe(onNext: { [weak self] in
            self?.setBind()
        }).disposeOnDeactivate(interactor: self)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func viewDidLoad() {
        self.didLoad.accept(())
    }
}

extension RecordInteractor {
    private func setBind() {
        self.recordStream.record
            .unwrap()
            .subscribe(onNext: { [weak self] record in
                self?.presenter.setRecord(with: record)
            }).disposeOnDeactivate(interactor: self)
    }
}
