//
//  HikingInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/09.
//
import CoreLocation

import RIBs
import RxSwift
import RxCocoa

protocol HikingRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol HikingPresentable: Presentable {
    var listener: HikingPresentableListener? { get set }
    func setTime(with time: String)
    func setDestination(with latitude: Double, longitude: Double)
    func setHiking()
    func setResting(with number: Int, location: CLLocation)
    func setRoute(with location: CLLocation)
    func setDistance(with distance: Double)
    func setAltitude(with altitude: Double)
}

protocol HikingListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class HikingInteractor: PresentableInteractor<HikingPresentable>, HikingInteractable, HikingPresentableListener {
    
    weak var router     : HikingRouting?
    weak var listener   : HikingListener?
    private let selectedStream: MountainStream
    
    private var restSections = [(Int, Date)]()
    private let didLoad       = PublishRelay<Void>()
    private let status        = BehaviorRelay<Hiking>(value: .hiking)
    private let totalDistance = BehaviorRelay<Double>(value: 0.0)
    private let restingTime   = BehaviorRelay<Int>(value: 0)
    private let totalTime     = BehaviorRelay<Int>(value: 0)
    private let locations     = BehaviorRelay<[CLLocation]>(value: [])
    
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
    
    init(presenter: HikingPresentable, selected: MountainStream) {
        self.selectedStream = selected
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
}

extension HikingInteractor {
    private func setLocationManager() {
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    private func setBind() {
        self.didLoad
            .withLatestFrom(self.selectedStream.mountain)
            .unwrap()
            .subscribe(onNext: { [weak self] mountain in
                self?.presenter.setDestination(with: mountain.latitude,
                                               longitude: mountain.longitude)
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
            .withLatestFrom(self.status)
            .filter { $0 == .hiking }
            .withLatestFrom(self.totalTime)
            .filter { $0 > 0 }
            .map { $0.toTimeString() }
            .subscribe(onNext: { [weak self] time in
                self?.presenter.setTime(with: time)
            }).disposeOnDeactivate(interactor: self)
        
        let updateLocation = self.locationManager.rx.updateLocations
            .filter { $0.horizontalAccuracy < 40 }
            .debug("[HikingInteractor] updateLocations")
            
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
            .withLatestFrom(self.status) { ($0,$1) }
            .filter { $0.1 == .hiking }
            .map { $0.0 }
        
        distance
            .withLatestFrom(self.totalDistance) { ($0,$1) }
            .map { (distance, total) in
                return total + distance
            }
            .bind(to: self.totalDistance)
            .disposeOnDeactivate(interactor: self)
        
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
                    self.presenter.setResting(with: self.restSections.count + 1,
                                              location: location)
                }
            }).disposeOnDeactivate(interactor: self)
        
        self.totalDistance
            .subscribe(onNext: { [weak self] distance in
                self?.presenter.setDistance(with: distance.toKiloMeter())
            }).disposeOnDeactivate(interactor: self)
    }
}

// MARK: Operation
extension HikingInteractor {
    private func saveRestTime() {
        self.restSections.append((self.restingTime.value, Date()))
        self.restingTime.accept(0)
    }
}
