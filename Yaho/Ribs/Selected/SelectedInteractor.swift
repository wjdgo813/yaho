//
//  SelectedInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/25.
//
import CoreLocation

import RIBs
import RxSwift


protocol SelectedRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SelectedPresentable: Presentable {
    var listener: SelectedPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func setTitle(with title: String)
    func setDestination(with lat: Double, lng: Double)
    func setCameraPosition(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D)
    func setCameraPosition(with location: CLLocationCoordinate2D)
}

protocol SelectedListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func didCloseSelected()
    
}

final class SelectedInteractor: PresentableInteractor<SelectedPresentable>, SelectedInteractable, SelectedPresentableListener {
    private let mountain: Model.Mountain
    weak var router: SelectedRouting?
    weak var listener: SelectedListener?
    
    private let tapCurrent = PublishSubject<Void>()
    private let current = BehaviorSubject<CLLocation>(value: CLLocation(latitude: 0.0, longitude: 0.0))
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .fitness
        manager.distanceFilter = kCLDistanceFilterNone
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: SelectedPresentable, selected: Model.Mountain) {
        self.mountain = selected
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.setLocationManager()
        self.setBind()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didAppear() {
        self.presenter.setTitle(with: self.mountain.name)
        self.presenter.setDestination(with: self.mountain.latitude, lng: self.mountain.longitude)
    }
    
    func didNavigateBack() {
        self.listener?.didCloseSelected()
    }
    
    func didTapCurrentLocation() {
        self.tapCurrent.onNext(())
    }
}

extension SelectedInteractor {
    private func setLocationManager() {
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    private func setBind() {
        self.locationManager.rx.updateLocations
            .bind(to: self.current)
            .disposeOnDeactivate(interactor: self)
        
        self.current.filterValid().take(1)
            .subscribe(onNext: { [weak self] location in
                guard let self = self else { return }
                self.presenter.setCameraPosition(southWest: location.coordinate,
                                                 northEast: CLLocationCoordinate2D(latitude: self.mountain.latitude,
                                                                                   longitude: self.mountain.longitude))
            }).disposeOnDeactivate(interactor: self)
        
        self.tapCurrent
            .withLatestFrom(self.current)
            .filterValid()
            .subscribe(onNext: { [weak self] location in
                self?.presenter.setCameraPosition(with: location.coordinate)
            }).disposeOnDeactivate(interactor: self)
    }
}