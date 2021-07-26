//
//  MountainsInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/17.
//
import CoreLocation

import RIBs
import RxSwift
import RxCocoa

protocol MountainsRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func mountainsToSelected(with mountain: Model.Mountain)
    func closeSelected()
}

protocol MountainsPresentable: Presentable {
    var listener: MountainsPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    var aroundMountains: PublishRelay<[Model.Mountain]?> { get }
}

protocol MountainsListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func closeMountains()
}

final class MountainsInteractor: PresentableInteractor<MountainsPresentable>, MountainsInteractable, MountainsPresentableListener {

    weak var router: MountainsRouting?
    weak var listener: MountainsListener?
    let aroundMountains = PublishRelay<Void>()
    private let mountains: [Model.Mountain]
    private let currentLocation = PublishRelay<CLLocation>()
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .fitness
        manager.distanceFilter = kCLDistanceFilterNone
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
    
    init(presenter: MountainsPresentable, mountains: [Model.Mountain]) {
        self.mountains = mountains
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    deinit {
        debugPrint("\(#file)_\(#function)")
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
    
    func didNavigateBack() {
        self.listener?.closeMountains()
    }
    
    func didCloseSelected() {
        self.router?.closeSelected()
    }
    
    func didSelectMountain(with mountain: Model.Mountain) {
        self.router?.mountainsToSelected(with: mountain)
    }
}

extension MountainsInteractor {
    private func setLocationManager() {
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    private func setBind() {
        self.locationManager.rx.updateLocations
            .debug("[MountainsInteractor] updateLocations")
            .bind(to: self.currentLocation)
            .disposeOnDeactivate(interactor: self)
        
        Observable.combineLatest(self.aroundMountains, self.currentLocation)
            .map{ [weak self] (_, location) -> [Model.Mountain]? in
                guard let self = self else { return nil }
                let sorted = self.mountains.sorted { mountain1, mountain2 in
                    let loc1 = CLLocation(latitude: mountain1.latitude, longitude: mountain1.longitude)
                    let loc2 = CLLocation(latitude: mountain2.latitude, longitude: mountain2.longitude)
                    return location.distance(from: loc1) < location.distance(from: loc2)
                }
                
                return sorted.enumerated().filter{ $0.0 < 4 }.map { $0.1 }
            }
        .bind(to: self.presenter.aroundMountains)
        .disposeOnDeactivate(interactor: self)
    }
}
