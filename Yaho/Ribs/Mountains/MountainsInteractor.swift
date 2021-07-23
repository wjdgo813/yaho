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
}

protocol MountainsPresentable: Presentable {
    var listener: MountainsPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    var aroundMountains: PublishRelay<[Mountain]?> { get }
}

protocol MountainsListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MountainsInteractor: PresentableInteractor<MountainsPresentable>, MountainsInteractable, MountainsPresentableListener {

    weak var router: MountainsRouting?
    weak var listener: MountainsListener?
    let aroundMountains = PublishRelay<Void>()
    private let mountains: [Mountain]
    private let currentLocation = PublishRelay<CLLocation>()
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .fitness
        manager.distanceFilter = kCLDistanceFilterNone
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
    
    init(presenter: MountainsPresentable, mountains: [Mountain]) {
        self.mountains = mountains
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.setBind()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func setBind() {
        self.locationManager.rx.updateLocations
            .debug("[MountainsInteractor] updateLocations")
            .bind(to: self.currentLocation)
            .disposeOnDeactivate(interactor: self)
        
        self.aroundMountains.withLatestFrom(self.currentLocation)
            .debug("[MountainsInteractor] aroundMountains")
            .map{ [weak self] location -> [Mountain]? in
                guard let self = self else { return nil }
                return self.mountains.sorted { mountain1, mountain2 in
                    let loc1 = CLLocation(latitude: mountain1.latitude, longitude: mountain1.longitude)
                    let loc2 = CLLocation(latitude: mountain2.latitude, longitude: mountain2.longitude)
                    return location.distance(from: loc1) < location.distance(from: loc2)
                }.enumerated().filter{ $0.0 < 4 }.map { $0.1 }
            }
            .bind(to: self.presenter.aroundMountains)
            .disposeOnDeactivate(interactor: self)
    }
}
