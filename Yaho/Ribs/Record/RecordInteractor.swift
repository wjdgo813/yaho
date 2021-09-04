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
                guard let self = self else { return }
                self.presenter.setRecord(with: self.convert(record: record))
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
        
        
        let cellType: [RecordCellType] = [
            .modalBar,
            .mapView(points: points),
            .info(record: record),
            .section(section: section, points: points),
            .detailTime(record: record),
            .detailDistance(title: "거리", value:"\(distance.toKiloMeter())km"),
            .detailCalrory(title: "칼로리", value:"\(calrories)kcal"),
            .detailPace(title: "속도",
                        firstTitle: "평균 속도",
                        firstValue: "\(averageSpeed.secondsToSeconds())m/s",
                        secondTitle: "최고 속도",
                        secondValue: "\(maxSpeed.secondsToSeconds())m/s"),
            .detailAltitude(title: "고도",
                            firstTitle: "시작 고도",
                            firstValue: "\(firstHeight)m",
                            secondTitle: "최고 고도",
                            secondValue: "\(maxHeight)m")
        ]
        
        return [RecordModel(items: cellType)]
    }
}
