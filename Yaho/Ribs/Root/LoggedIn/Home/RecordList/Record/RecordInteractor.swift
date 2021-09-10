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
    func setRecord(with record: [RecordModel]?)
}

protocol RecordListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func recordDidClose()
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
    
    func didClose() {
        self.listener?.recordDidClose()
    }
}

extension RecordInteractor {
    private func setBind() {
        self.recordStream.record
            .unwrap()
            .subscribe(onNext: { [weak self] record in
                guard let self = self else { return }
                let model = self.convert(record: record)
                self.presenter.setRecord(with: model)
            }).disposeOnDeactivate(interactor: self)
    }
    
    private func convert(record: Model.Record) -> [RecordModel]? {
        guard let section = record.section, let points = record.points else { return nil }
        let distance      = section.reduce(0) { $0 + $1.distance }
        let calrories     = section.reduce(0) { $0 + $1.calrories }
        let averageSpeed  = (points.reduce(0) { $0 + $1.speed }) / Double(points.count)
        let firstHeight   = points.first?.altitude ?? 0.0
        let maxSpeed      = points.map { $0.speed }.max() ?? 0.0
        let maxHeight     = points.map { $0.altitude }.max() ?? 0.0
        
        var cellType: [RecordCellType] = []
        if self.listener! is RecordListInteractor == false {
            cellType.append(.modalBar)
        }
        
        cellType.append(.mapView(points: points))
        cellType.append(.info(record: record))
        cellType.append(.section(section: section, points: points))
        cellType.append(.detailTime(record: record))
        cellType.append(.detailDistance(title: "거리", value:"\(distance.toKiloMeter())km"))
        cellType.append(.detailCalrory(title: "칼로리", value:"\(calrories)kcal"))
        cellType.append(.detailPace(title: "속도",
                                    firstTitle: "평균 속도",
                                    firstValue: "\(averageSpeed.secondsToSeconds())m/s",
                                    secondTitle: "최고 속도",
                                    secondValue: "\(maxSpeed.secondsToSeconds())m/s"))
        cellType.append(.detailAltitude(title: "고도",
                                        firstTitle: "시작 고도",
                                        firstValue: "\(firstHeight)m",
                                        secondTitle: "최고 고도",
                                        secondValue: "\(maxHeight)m"))
        
        return [RecordModel(items: cellType)]
    }
}
