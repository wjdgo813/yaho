//
//  HikingViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/09.
//

import RIBs
import RxSwift
import RxCocoa

import UIKit
import NMapsMap

protocol HikingPresentableListener: class {
    func viewDidLoad()
    func onPause()
}

final class HikingViewController: UIViewController, HikingPresentable, HikingViewControllable {
    
    enum InfoViewState {
        case extend
        case narrow
    }
    
    @IBOutlet private weak var mapView      : NMFMapView!
    @IBOutlet private weak var pauseButton  : RoundButton!
    @IBOutlet private weak var finishButton : RoundButton!
    @IBOutlet private weak var timeLabel    : UILabel!
    @IBOutlet private weak var restLabel    : UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var altitudeLabel: UILabel!
    @IBOutlet private weak var infoView     : UIView!
    @IBOutlet private weak var adView       : UIView!
    @IBOutlet private weak var recordStackview: UIStackView!
    @IBOutlet private weak var infoBottomConst: NSLayoutConstraint!
    
    private let pathOverlay: NMFPath = {
        let path = NMFPath()
        path.width = 1
        path.outlineWidth = 0
        path.color = UIColor.black
        return path
    }()
    
    private let infoViewState = BehaviorRelay<InfoViewState>(value: .extend)
    private let disposeBag    = DisposeBag()
    weak var listener: HikingPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.listener?.viewDidLoad()
        self.setMapView()
        self.setupUI()
        self.setBind()
    }
    
    func setTime(with time: String) {
        self.timeLabel.text = time
    }
    
    func setDestination(with latitude: Double, longitude: Double) {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: latitude, lng: longitude)
        marker.mapView = self.mapView
        marker.iconImage = NMFOverlayImage(name: "goal")
    }
    
    func setHiking() {
        UIView.animate(withDuration: 0.5) {
            self.recordStackview.isHidden = false
            self.restLabel.isHidden       = true
        }
        
        let location = self.mapView.locationOverlay
        location.subIcon = nil
    }
    
    func setResting(with number: Int, location: CLLocation) {
        let markerView = RestMarkerView.getSubView(value: RestMarkerView.self)!
        markerView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        markerView.numberLabel.text = "\(number)"
        
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        marker.mapView = self.mapView
        marker.width  = 25
        marker.height = 25
        marker.iconImage = NMFOverlayImage(image: markerView.asImage())
        
        let location = self.mapView.locationOverlay
        location.subIcon = NMFOverlayImage(name: "Group_36")
        location.subAnchor = CGPoint(x: 0.5, y: 1)
        
        UIView.animate(withDuration: 0.5) {
            self.recordStackview.isHidden = true
            self.restLabel.isHidden       = false
        }
    }
    
    func setRoute(with location: CLLocation) {
        let path = self.pathOverlay.path
        path.insertPoint(NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude), at: 0)
        self.pathOverlay.path = path
    }
    
    func setDistance(with distance: Double) {
        self.distanceLabel.text = "\(distance)km"
    }
    
    func setAltitude(with altitude: Double) {
        self.altitudeLabel.text = "\(altitude)m"
    }
    
    private func setMapView() {
        self.mapView.locationOverlay.circleColor = .Green._500
        self.mapView.positionMode = .direction
        self.mapView.setLayerGroup(NMF_LAYER_GROUP_MOUNTAIN, isEnabled: true)
        self.pathOverlay.path = NMGLineString(points: [NMGLatLng(lat: 37.57152, lng: 126.97714),
                                                       NMGLatLng(lat: 37.56607, lng: 126.98268),
                                                       NMGLatLng(lat: 37.56445, lng: 126.97707),
                                                       NMGLatLng(lat: 37.55855, lng: 126.97822)])
        self.pathOverlay.mapView = self.mapView
    }
    
    private func setupUI() {
        self.infoView.cornerRadius([.topLeft, .topRight], radius: 30)
    }
    
    private func setBind() {
        self.pauseButton.rx.tap
            .subscribe(onNext: {
                self.listener?.onPause()
            }).disposed(by: self.disposeBag)
        
        self.infoViewState
            .subscribe(onNext: { [weak self] status in
                guard let self = self else { return }
                switch status {
                case .extend:
                    self.extendInfoView()
                case .narrow:
                    self.narrowInfoView()
                }
            }).disposed(by: self.disposeBag)
    }
    
    @IBAction func mapViewTapGesture(_ sender: Any) {
        if self.infoViewState.value == .extend {
            self.infoViewState.accept(.narrow)
        } else {
            self.infoViewState.accept(.extend)
        }
    }
    
    @IBAction func infoViewPanGesture(_ gesture: UIPanGestureRecognizer) {
        let maxHeight: CGFloat = 241
        let minHeight:CGFloat  = 34
        let point  = gesture.location(in: self.view)
        let height = self.view.frame.height
        
        if gesture.state == .changed {
            if point.y >= 0 && height - point.y <= maxHeight + self.adView.frame.height {
                let differ = (height - minHeight) - point.y
                if differ + minHeight > minHeight {
                    self.infoBottomConst.constant = -(maxHeight - (differ + minHeight))
                }
            }
        } else if gesture.state == .ended {
            if (height - point.y) >= ((maxHeight + self.adView.frame.height) / 2) {
                self.infoViewState.accept(.extend)
            } else {
                self.infoViewState.accept(.narrow)
            }
        }
    }
}

extension HikingViewController {
    private func extendInfoView() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn) {
            self.infoBottomConst.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    private func narrowInfoView() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn) {
            self.infoBottomConst.constant = -241 + 34
            self.view.layoutIfNeeded()
        }
    }
}
