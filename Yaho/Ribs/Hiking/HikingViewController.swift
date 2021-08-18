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
    func resume()
}

final class HikingViewController: UIViewController, HikingPresentable, HikingViewControllable {

    enum Hiking {
        case hiking
        case resting
    }
    
    @IBOutlet private weak var mapView: NMFMapView!
    @IBOutlet private weak var pauseButton  : RoundButton!
    @IBOutlet private weak var finishButton : RoundButton!
    @IBOutlet private weak var timeLabel    : UILabel!
    @IBOutlet private weak var restLabel    : UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var altitudeLabel: UILabel!
    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var adView: UIView!
    @IBOutlet private weak var infoBottomConst: NSLayoutConstraint!
    
    private let status = BehaviorSubject<Hiking>(value: .hiking)
    private let disposeBag = DisposeBag()
    weak var listener: HikingPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listener?.viewDidLoad()
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
    
    private func setBind() {
        self.pauseButton.rx.tap
            .withLatestFrom(self.status)
            .filter { $0 == .hiking }
            .map { _ in Hiking.resting }
            .bind(to: self.status)
            .disposed(by: self.disposeBag)
        
        self.pauseButton.rx.tap
            .withLatestFrom(self.status)
            .filter { $0 == .resting }
            .map { _ in Hiking.hiking }
            .bind(to: self.status)
            .disposed(by: self.disposeBag)

        self.status
            .subscribe(onNext: { [weak self] status in
                switch status {
                case .hiking:
                    self?.listener?.resume()
                case .resting:
                    self?.listener?.onPause()
                }
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
