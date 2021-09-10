//
//  RecordMapViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/09/08.
//

import UIKit
import RxSwift
import RxCocoa
import NMapsMap

final class RecordMapViewController: TransitioningViewController {
    @IBOutlet private weak var mapView    : NMFMapView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var naviBar    : UIView!
    @IBOutlet private weak var closeButton: UIButton!
    private var originPoint = CGPoint.zero
    private var hikingPoints: [Model.Record.HikingPoint] = []
    private let disposeBag  = DisposeBag()
    private let pathOverlay: NMFPath = {
        let path = NMFPath()
        path.width = 2
        path.outlineWidth = 0
        path.color = UIColor.black
        return path
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMapView(self.hikingPoints)
        self.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
    }
    
    override func onWillPresentView(){
        super.onWillPresentView()
        self.contentView.transform = CGAffineTransform(translationX: 0, y: -300).scaledBy(x: 0, y: 0)
    }
    
    override func performCustomPresentationAnimation() {
        super.performCustomPresentationAnimation()
        self.contentView.transform = .identity
    }
    
    
    override func onWillDismissView(){
        super.onWillDismissView()
    }
    
    
    override func performCustomDismissingAnimation() {
        super.performCustomDismissingAnimation()
    }
}

extension RecordMapViewController: VCFactoriable {
    public static var storyboardIdentifier = "Record"
    public static var vcIdentifier = "RecordMapViewController"
    public func bindData(value: (point: CGPoint, hikings: [Model.Record.HikingPoint])) {
        self.transitioningDelegate  = self
        self.modalPresentationStyle = .overCurrentContext
        self.animateSetting.animation.present.duration = 0.7
        self.originPoint  = value.point
        self.hikingPoints = value.hikings
    }
}

extension RecordMapViewController {
    private func setMapView(_ value: [Model.Record.HikingPoint]) {
        let mapPoints = value.map { point in
            NMGLatLng(lat: point.latitude, lng: point.longitude)
        }
        
        let sorted = value.sorted { lPoint, rPoint in
            lPoint.parentSectionID < rPoint.parentSectionID
        }

        let pointSet = Set<Model.Record.HikingPoint>(sorted)
        pointSet.enumerated().forEach { (index,point) in
            self.setResting(with: point.parentSectionID+1, location: CLLocation(latitude: point.latitude, longitude: point.longitude))
        }
        
        self.setResting(with: pointSet.count+1, location: CLLocation(latitude: value.last?.latitude ?? 0.0,
                                                                     longitude: value.last?.longitude ?? 0.0))
        
        let sortedLng = value.sorted { $0.longitude > $1.longitude }
        let sortedLat = value.sorted { $0.latitude  > $1.latitude }
        
        let southWest = CLLocationCoordinate2D(latitude: sortedLat.last?.latitude ?? 0.0,
                                               longitude: sortedLng.last?.longitude ?? 0.0)
        let northEast = CLLocationCoordinate2D(latitude: sortedLat.first?.latitude ?? 0.0,
                                               longitude: sortedLng.first?.longitude ?? 0.0)
        
        self.setCameraPosition(southWest: southWest, northEast: northEast)
        self.pathOverlay.path = NMGLineString(points: mapPoints)
        self.pathOverlay.mapView = self.mapView
    }
    
    private func setResting(with number: Int, location: CLLocation) {
        let markerView = RestMarkerView.getSubView(value: RestMarkerView.self)!
        markerView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        markerView.numberLabel.text = "\(number)"
        
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        marker.mapView = self.mapView
        marker.width  = 50
        marker.height = 50
        marker.anchor = CGPoint(x: 0.5, y: 0.5)
        marker.iconImage = NMFOverlayImage(image: markerView.asImage())
        
        let location = self.mapView.locationOverlay
        location.subIcon = NMFOverlayImage(name: "Group_36")
        location.subAnchor = CGPoint(x: 0.5, y: 1)
    }
    
    private func setCameraPosition(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D) {
        let update = NMFCameraUpdate(fit: NMGLatLngBounds(southWest: NMGLatLng(from: southWest), northEast: NMGLatLng(from:northEast)), padding: 80.0)
        update.animation = .fly
        self.mapView.moveCamera(update)
    }
}
