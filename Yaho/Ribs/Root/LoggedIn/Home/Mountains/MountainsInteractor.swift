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
//    func mountainsToSelected(with mountain: Model.Mountain)
//    func closeSelected()
}

protocol MountainsPresentable: Presentable {
    var listener: MountainsPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func set(mountains: [Model.Mountain])
}

protocol MountainsListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func mountainsToSelected(with mountain: Model.Mountain)
    func closeMountains()
}

final class MountainsInteractor: PresentableInteractor<MountainsPresentable>, MountainsInteractable, MountainsPresentableListener {

    weak var router: MountainsRouting?
    weak var listener: MountainsListener?

    private let mutableSelectedStream: MutableMountainStream
    private let mountainsStream: MountainsStream
    private let viewDidLoad = PublishRelay<Void>()
    private let currentLocation = PublishRelay<CLLocation>()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .fitness
        manager.distanceFilter = kCLDistanceFilterNone
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
    
    init(presenter: MountainsPresentable, mountainsStream: MountainsStream, mutableMountainStream: MutableMountainStream) {
        self.mutableSelectedStream = mutableMountainStream
        self.mountainsStream = mountainsStream
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
    
    func didLoad() {
        self.viewDidLoad.accept(())
    }
    
    func didNavigateBack() {
        self.listener?.closeMountains()
    }
    
    func didSelectMountain(with mountain: Model.Mountain) {
        self.mutableSelectedStream.updateMountain(with: mountain)
        self.listener?.mountainsToSelected(with: mountain)
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
        
        self.viewDidLoad
            .flatMap { [weak self] _ -> Observable<[Model.Mountain]?> in
                return self?.mountainsStream.mountains ?? .empty()
            }
            .unwrap()
            .debug("[MountainsInteractor] mountainsStream")
            .flatMap { [weak self] mountains -> Observable<([Model.Mountain], CLLocation)> in
                guard let self = self else { return .empty() }
                return self.currentLocation.take(1).asObservable().map { (mountains, $0) }
            }
            .map { (mountains, location) -> [Model.Mountain] in
                let sorted = mountains.sorted { mountain1, mountain2 in
                    let loc1 = CLLocation(latitude: mountain1.latitude, longitude: mountain1.longitude)
                    let loc2 = CLLocation(latitude: mountain2.latitude, longitude: mountain2.longitude)
                    return location.distance(from: loc1) < location.distance(from: loc2)
                }

                return sorted.enumerated().filter{ $0.0 < 4 }.map { $0.1 }
            }
            .subscribe(onNext: { [weak self] mountains in
                self?.presenter.set(mountains: mountains)
            }).disposeOnDeactivate(interactor: self)
    }
}
