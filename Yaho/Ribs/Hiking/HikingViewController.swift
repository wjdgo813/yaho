//
//  HikingViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/09.
//

import RIBs
import RxSwift
import UIKit
import NMapsMap

protocol HikingPresentableListener: class {
    func viewDidLoad()
    func onPause()
}

final class HikingViewController: UIViewController, HikingPresentable, HikingViewControllable {
    
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
    private let disposeBag = DisposeBag()
    weak var listener: HikingPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listener?.viewDidLoad()
        self.setMapView()
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
    }
    
    func setResting(with number: Int, location: CLLocation) {
        let markerView = RestMarkerView.getSubView(value: RestMarkerView.self)!
        markerView.numberLabel.text = "\(number)"
        
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        marker.mapView = self.mapView
        marker.iconImage = NMFOverlayImage(image: markerView.asImage())
        
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
    
    private func setMapView() {
        self.mapView.positionMode = .direction
        self.mapView.setLayerGroup(NMF_LAYER_GROUP_MOUNTAIN, isEnabled: true)
        self.pathOverlay.path = NMGLineString(points: [NMGLatLng(lat: 37.57152, lng: 126.97714),
                                                       NMGLatLng(lat: 37.56607, lng: 126.98268),
                                                       NMGLatLng(lat: 37.56445, lng: 126.97707),
                                                       NMGLatLng(lat: 37.55855, lng: 126.97822)])
        self.pathOverlay.mapView = self.mapView
    }
    
    private func setBind() {
        self.pauseButton.rx.tap
            .subscribe(onNext: {
                self.listener?.onPause()
            }).disposed(by: self.disposeBag)
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
                self.extendInfoView()
            } else {
                self.narrowInfoView()
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
