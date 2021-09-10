//
//  HikingInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/09.
//
import CoreLocation
import HealthKit

import RIBs
import RxSwift
import RxCocoa

protocol HikingRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol HikingPresentable: Presentable {
    var listener: HikingPresentableListener? { get set }
    func startHiking(location: CLLocation)
    func setTime(with time: String)
    func setDestination(with latitude: Double, longitude: Double)
    func setHiking()
    func setResting(with number: Int, location: CLLocation)
    func setRoute(with location: CLLocation)
    func setDistance(with distance: Double)
    func setAltitude(with altitude: Double)
    func setCameraPosition(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D)
}

protocol HikingListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func finishTrip()
}

final class HikingInteractor: PresentableInteractor<HikingPresentable>, HikingInteractable, HikingPresentableListener {
    
    weak var router     : HikingRouting?
    weak var listener   : HikingListener?
    private let uid: String
    private let selectedStream: MountainStream
    private let countStream   : VisitCountStream
    private let mutableRecord : MutableRecordStream
    private let service       : StoreServiceProtocol
    
    private let healthKitStore = HKHealthStore()
    private var mountain    : Model.Mountain?
    private var visitCount  : Int = 0
    
    private let didLoad       = PublishRelay<Void>()
    private let status        = BehaviorRelay<Hiking>(value: .hiking)
    private let totalDistance = BehaviorRelay<Double>(value: 0.0)
    private let restingTime   = BehaviorRelay<Int>(value: 0)
    private let totalTime     = BehaviorRelay<Int>(value: 0)
    private let locations     = BehaviorRelay<[CLLocation]>(value: [])
    
    private let locationSection = BehaviorRelay<[Model.Record.HikingPoint]>(value: [])
    private let hikingSection   = BehaviorRelay<[Model.Record.SectionHiking]>(value: [])
    private let saveRecord      = PublishRelay<Model.Record>()
    private var restSections    = [Int]()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .fitness
        manager.distanceFilter = kCLDistanceFilterNone
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
    
    enum Hiking {
        case hiking
        case resting
    }
    
    init(presenter: HikingPresentable,
         uid: String,
         mutableRecord: MutableRecordStream,
         selected: MountainStream,
         countStream: VisitCountStream,
         service: StoreServiceProtocol) {
        self.uid            = uid
        self.mutableRecord  = mutableRecord
        self.selectedStream = selected
        self.countStream    = countStream
        self.service        = service
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.setLocationManager()
        self.didLoad
            .subscribe(onNext: { [weak self] in
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
    
    func onPause() {
        if self.status.value == .hiking {
            self.status.accept(.resting)
        } else {
            self.status.accept(.hiking)
        }
    }
    
    func onFinish() {
        
        self.saveHikingSection { [weak self] in
            guard let self = self else { return }
            let totalTime = self.totalTime.value
            let runningTime = self.hikingSection.value.reduce(0) { $0 + $1.runningTime }
            let distance    = self.hikingSection.value.reduce(0) { $0 + $1.distance }
            let calrories   = self.hikingSection.value.reduce(0) { $0 + $1.calrories }
            let maxSpeed    = self.locationSection.value.max(by: { $0.speed > $1.speed })?.speed ?? 0.0
            let totalSpeed  = self.locationSection.value.reduce(0) { $0 + $1.speed }
            let startHeight  = self.locationSection.value.first?.altitude
            let maxHeight    = self.locationSection.value.max(by: { $0.altitude > $1.altitude })?.altitude ?? 0.0
            let divide       = self.locationSection.value.count
            let averageSpeed = Int(totalSpeed) / (divide > 0 ? divide : 1)
            
            let record = Model.Record(id: String(Date().hashValue),
                                      mountainID: String(self.mountain?.id ?? 0),
                                      mountainName: self.mountain?.name ?? "",
                                      address: self.mountain?.address ?? "",
                                      visitCount: self.visitCount + 1,
                                      date: Date().toUTCString(),
                                      totalTime: totalTime,
                                      runningTime: runningTime,
                                      distance: distance,
                                      calrories: calrories,
                                      maxSpeed: maxSpeed,
                                      averageSpeed: Double(averageSpeed),
                                      startHeight: startHeight ?? 0.0,
                                      maxHeight: maxHeight,
                                      section: self.hikingSection.value,
                                      points: self.locationSection.value)
            
            self.saveRecord.accept(record)
        }
    }
}

extension HikingInteractor {
    private func setLocationManager() {
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    private func setBind() {
        self.selectedStream.mountain
            .unwrap()
            .subscribe(onNext: { [weak self] mountain in
                self?.mountain = mountain
                self?.presenter.setDestination(with: mountain.latitude,
                                               longitude: mountain.longitude)
            }).disposeOnDeactivate(interactor: self)
        
        self.countStream.count
            .unwrap()
            .subscribe(onNext: { [weak self] count in
                self?.visitCount = count
            }).disposeOnDeactivate(interactor: self)
        
        Observable<Int>.interval(1, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))    
            .withLatestFrom(self.totalTime)
            .map { time -> Int in
                return time + 1
            }
            .observeOn(MainScheduler.instance)
            .bind(to: self.totalTime)
            .disposeOnDeactivate(interactor: self)
        
        self.status
            .filter { $0 == .resting }
            .flatMap { _ in
                Observable<Int>.interval(1, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
                    .takeUntil(self.status.filter { $0 == .hiking })
            }.withLatestFrom(self.restingTime)
            .map { time -> Int in
                return time + 1
            }
            .observeOn(MainScheduler.instance)
            .bind(to: self.restingTime)
            .disposeOnDeactivate(interactor: self)
        
        self.restingTime
            .filter { $0 > 0 }
            .map { $0.toTimeString() }
            .subscribe(onNext: { [weak self] time in
                self?.presenter.setTime(with: time)
            }).disposeOnDeactivate(interactor: self)
        
        self.totalTime
            .withLatestFrom(self.status) { ($0,$1) }
            .filter { $0.1 == .hiking }
            .map { $0.0 }
            .filter { $0 > 0 }
            .map { $0.toTimeString() }
            .subscribe(onNext: { [weak self] time in
                self?.presenter.setTime(with: time)
            }).disposeOnDeactivate(interactor: self)
        
        let updateLocation = self.locationManager.rx.updateLocations
            .filter { $0.horizontalAccuracy < 40 }
            .withLatestFrom(self.status) { ($0,$1) }
            .filter { $0.1 == .hiking }
            .map { $0.0 }
            .debug("[HikingInteractor] updateLocations")
            .share()
        
        updateLocation.filterValid().take(1)
            .withLatestFrom(self.selectedStream.mountain.unwrap()) { ($0, $1) }
            .subscribe(onNext: { [weak self] location, mountain in
                guard let self = self else { return }
                self.presenter.setCameraPosition(southWest: location.coordinate,
                                                 northEast: CLLocationCoordinate2D(latitude: mountain.latitude,
                                                                                   longitude: mountain.longitude))
            }).disposeOnDeactivate(interactor: self)
        
        updateLocation
            .withLatestFrom(self.locations) { ($0,$1) }
            .delay(0.3, scheduler: MainScheduler.instance)
            .map { (newLocation, oldLocations) -> [CLLocation] in
                var locations = oldLocations
                locations.append(newLocation)
                return locations
            }
            .bind(to: self.locations)
            .disposeOnDeactivate(interactor: self)
        
        let distance = updateLocation
            .withLatestFrom(self.locations) { ($0,$1) }
            .map { (newLocation, oldLocations) -> Double in
                guard let last = oldLocations.last else { return 0.0 }
                return last.distance(from: newLocation)
            }
            .map { $0 }
        
        distance
            .withLatestFrom(self.totalDistance) { ($0,$1) }
            .map { (distance, total) in
                return total + distance
            }
            .bind(to: self.totalDistance)
            .disposeOnDeactivate(interactor: self)
        
        updateLocation.take(1)
            .subscribe(onNext: { [weak self] location in
                self?.presenter.startHiking(location: location)
            }).disposeOnDeactivate(interactor: self)
        
        updateLocation
            .subscribe(onNext: { [weak self] location in
                self?.presenter.setAltitude(with: location.altitude)
                self?.presenter.setRoute(with: location)
            }).disposeOnDeactivate(interactor: self)
        
        self.status
            .skip(1)
            .withLatestFrom(updateLocation) { ($0,$1) }
            .subscribe(onNext: { [weak self] status, location in
                guard let self = self else { return }
                switch status {
                case .hiking:
                    self.saveRestTime()
                    self.presenter.setHiking()
                case .resting:
                    self.saveHikingSection()
                    self.presenter.setResting(with: self.restSections.count + 2,
                                              location: location)
                }
            }).disposeOnDeactivate(interactor: self)
        
        self.totalDistance
            .subscribe(onNext: { [weak self] distance in
                self?.presenter.setDistance(with: distance.toKiloMeter())
            }).disposeOnDeactivate(interactor: self)
        
        self.saveRecord
            .flatMapLatest { [weak self] record -> Observable<Model.Record> in
                guard let self = self else { return .empty() }
                return self.service.rxSaveRecord(with: self.uid, record: record)
                    .catchErrorJustReturn(())
                    .map { _ in record }
            }
            .flatMapLatest { [weak self] record -> Observable<Model.Record> in
                guard let self = self else { return .empty() }
                return self.service.rxSaveTotalRecord(with: self.uid, record: record)
                    .catchErrorJustReturn(())
                    .map { _ in record }
            }.flatMapLatest { [weak self] record -> Observable<Model.Record> in
                guard let self = self, let mountain = self.mountain else { return .empty() }
                return self.service.rxSaveIncreaseVisit(mountain: mountain, uid: self.uid)
                    .catchErrorJustReturn(())
                    .map { _ in record }
            }
            .subscribe(onNext: { [weak self] record in
                self?.listener?.finishTrip()
                self?.mutableRecord.updateRecord(with: record)
            }).disposeOnDeactivate(interactor: self)
    }
}

// MARK: Operation
extension HikingInteractor {
    private func saveHikingSection(completion: (() -> Void)? = nil) {
        var hiking      = self.hikingSection.value
        let runningTime = self.totalTime.value - (hiking.reduce(0) { $0 + $1.runningTime }) - self.restSections.reduce(0) { $0 + $1 }
        let distance    = self.totalDistance.value - hiking.reduce(0) { $0 + $1.distance }
        
        let points = self.locations.value.map { Model.Record.HikingPoint(id: hiking.count,
                                                                         latitude: $0.coordinate.latitude,
                                                                         longitude: $0.coordinate.longitude,
                                                                         altitude: $0.altitude,
                                                                         speed: $0.speed,
                                                                         timeStamp: $0.timestamp.toUTCString(),
                                                                         distance: 0.0) }
        var section = self.locationSection.value
        section.append(contentsOf: points)
        
        self.locationSection.accept(section)
        self.locations.accept([])
        
        self.loadCalory(since: points.first?.timeStamp.getIsoToDate() ?? Date(), to: Date()) { calrory, error in
            let section = Model.Record.SectionHiking(id: hiking.count,
                                                     runningTime: runningTime,
                                                     distance: distance,
                                                     calrories: calrory ?? 0.0,
                                                     restIndex: self.restSections.count)
            hiking.append(section)
            self.hikingSection.accept(hiking)
            if let completion = completion { completion() }
        }
    }
    
    private func saveRestTime() {
        self.restSections.append(self.restingTime.value)
        self.restingTime.accept(0)
    }
    
    
    typealias AppHealthKitValueCompletion = ((Double?, Error?)->Void)
    func loadCalory(since start: Date = Date(), to end: Date = Date(), completion: @escaping AppHealthKitValueCompletion) {
        guard let type = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            guard let result = result else {
                completion(nil, error)
                return
            }
            
            if let quantity = result.sumQuantity() {
                resultCount = quantity.doubleValue(for: HKUnit.kilocalorie())
            }
            DispatchQueue.main.async {
                completion(resultCount, nil)
            }
        }
        
        self.healthKitStore.execute(query)
    }
}
