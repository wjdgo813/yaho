//
//  RecordMapCell.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/26.
//

import UIKit
import RxSwift
import RxCocoa
import NMapsMap

final class RecordMapCell: UITableViewCell, CellFactory {
    static let identifier = "RecordMapCell"
    
    @IBOutlet fileprivate weak var expandButton: UIButton!
    @IBOutlet private weak var mapView: NMFMapView!
    
    private let pathOverlay: NMFPath = {
        let path = NMFPath()
        path.width = 1
        path.outlineWidth = 0
        path.color = UIColor.black
        return path
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindData(value: [Model.Record.HikingPoint]) {
        
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
        
        let southWest = CLLocationCoordinate2D(latitude: pointSet.first?.latitude ?? 0.0, longitude: pointSet.first?.longitude ?? 0.0)
        let northEast = CLLocationCoordinate2D(latitude: sorted.last?.latitude ?? 0.0, longitude: sorted.last?.longitude ?? 0.0)
        
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
        marker.width  = 25
        marker.height = 25
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

extension RecordMapCell: CellRegister {
    static let nibName          = "RecordMapCell"
}

extension Reactive where Base: RecordMapCell {
    var tapExpand: ControlEvent<Void> {
        return ControlEvent(events: base.expandButton.rx.tap)
    }
}


