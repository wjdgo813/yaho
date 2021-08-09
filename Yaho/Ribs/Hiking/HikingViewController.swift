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
}

final class HikingViewController: UIViewController, HikingPresentable, HikingViewControllable {

    @IBOutlet private weak var mapView: NMFMapView!
    @IBOutlet private weak var pauseButton  : RoundButton!
    @IBOutlet private weak var finishButton : RoundButton!
    @IBOutlet private weak var timeLabel    : UILabel!
    @IBOutlet private weak var restLabel    : UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var altitudeLabel: UILabel!
    @IBOutlet private weak var infoView: UIView!
    
    weak var listener: HikingPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listener?.viewDidLoad()
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
}
