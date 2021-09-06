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
    func selectedRecord()
}

protocol RecordListPresentable: Presentable {
    var listener: RecordListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func setRecord(with record: [RecordListModel]?)
}

protocol RecordListListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RecordListInteractor: PresentableInteractor<RecordListPresentable>, RecordListInteractable, RecordListPresentableListener {
    

    weak var router: RecordListRouting?
    weak var listener: RecordListListener?
    private let service             : StoreServiceProtocol
    private let mustableRecordStream: MutableRecordStream
    private let uid: String
    
    private let records = BehaviorSubject<[Model.Record]?>(value: nil)
    private let period  = BehaviorSubject<Date>(value: Date())

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: RecordListPresentable, service: StoreServiceProtocol, mustableRecordStream: MutableRecordStream, uid: String) {
        self.service = service
        self.uid     = uid
        self.mustableRecordStream = mustableRecordStream
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
    
    func viewDidLoad() {
        self.setBind()
    }
    
    func changedDate(with date: Date) {
        self.period.onNext(date)
    }
    
    func selectedRecord(with record: Model.Record) {
        self.mustableRecordStream.updateRecord(with: record)
        self.router?.selectedRecord()
    }
    
    func recordDidClose() {
        
    }
}

extension RecordListInteractor {
    private func setBind() {
        self.service.fetchRecord(uid: uid) { [weak self] result in
            switch result {
            case .success(let records):
                self?.records.onNext(records)
                print("[RecordListInteractor] records: \(records)")
            case .failure(let error):
                break
            }
        }
        
        Observable.combineLatest(self.period, self.records.unwrap())
            .subscribe(onNext: { [weak self] period, records in
                self?.presenter.setRecord(with: self?.setRecord(with: records, period: period))
            }).disposeOnDeactivate(interactor: self)
    }
    
    private func setRecord(with records: [Model.Record], period: Date) -> [RecordListModel]? {
        let periodRecords = records.filter { record in
            record.date.getIsoToDate()?.string(WithFormat: "MM") == period.string(WithFormat: "MM") &&
                record.date.getIsoToDate()?.string(WithFormat: "yyyy") == period.string(WithFormat: "yyyy")
        }
         
        let periodStr = period.string(WithFormat: "yyyy.MM")
        var cellType: [RecordListCellType] = []
        cellType.append(.title(date: periodStr))
        cellType.append(.date(date: periodStr))
        periodRecords.forEach {
            cellType.append(.record(record: $0))
        }
        
        return [RecordListModel(items: cellType)]
    }
}
