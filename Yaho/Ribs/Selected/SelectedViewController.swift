//
//  SelectedViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/25.
//

import RIBs
import RxSwift
import NMapsMap
import UIKit

protocol SelectedPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didNavigateBack()
    func didAppear()
    func didTapCurrentLocation()
    func goHiking()
}

final class SelectedViewController: UIViewController, SelectedPresentable, SelectedViewControllable {

    @IBOutlet private weak var currentButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var hikingButton: UIButton!
    @IBOutlet private weak var mapView: NMFMapView!
    
    private var name = ""
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    private let disposeBag = DisposeBag()
    weak var listener: SelectedPresentableListener?
    
    deinit {
        debugPrint("\(#file)_\(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listener?.didAppear()
        self.setMapView()
        self.setupUI()
        self.setBind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent {
            self.listener?.didNavigateBack()
        }
    }
}

extension SelectedViewController {
    private func setupUI() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.titleLabel.text = "\(self.name) 정복을\n시작합니다!"
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: self.latitude, lng: self.longitude)
        marker.mapView = self.mapView
        marker.iconImage = NMFOverlayImage(name: "goal")
    }
    
    private func setBind() {
        self.currentButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.listener?.didTapCurrentLocation()
            }).disposed(by: self.disposeBag)
        
        self.hikingButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.listener?.goHiking()
            }).disposed(by: self.disposeBag)
    }
    
    private func setMapView() {
        self.mapView.positionMode = .direction
        self.mapView.setLayerGroup(NMF_LAYER_GROUP_MOUNTAIN, isEnabled: true)
        let location = self.mapView.locationOverlay
        location.subIcon = NMFOverlayImage(name: "goPrev")
        location.subAnchor = CGPoint(x: 0.5, y: 1)
    }
    
    func setTitle(with title: String) {
        self.name = title
    }
    
    func setDestination(with lat: Double, lng: Double) {
        self.latitude = lat
        self.longitude = lng
    }
    
    func setCameraPosition(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D) {
        let update = NMFCameraUpdate(fit: NMGLatLngBounds(southWest: NMGLatLng(from: southWest), northEast: NMGLatLng(from:northEast)), padding: 80.0)
        update.animation = .fly
        self.mapView.moveCamera(update)
    }
    
    func setCameraPosition(with location: CLLocationCoordinate2D) {
        let update = NMFCameraUpdate(position: NMFCameraPosition(NMGLatLng(from: location), zoom: 15.0))
        update.animation = .fly
        self.mapView.moveCamera(update)
    }
}
