//
//  RxCLLocationDelegateProxy.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/23.
//

import CoreLocation
import RxSwift
import RxCocoa

class RxCLLocationDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    static func registerKnownImplementations() {
        self.register { manager -> RxCLLocationDelegateProxy in
            RxCLLocationDelegateProxy(parentObject: manager, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: CLLocationManager) -> CLLocationManagerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: CLLocationManager) {
        object.delegate = delegate
    }
}

extension Reactive where Base: CLLocationManager {
    var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return RxCLLocationDelegateProxy.proxy(for: self.base)
    }
    
    var updateLocations: Observable<CLLocation> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:))).map { ($0.last! as! NSArray).lastObject as! CLLocation }
    }
}

extension ObservableType where E == (CLLocation,CLLocation) {
    func distance() -> Observable<CLLocationDistance>  {
        return map { value in
            let from = value.0
            let to   = value.1
            return from.distance(from: to)
        }
    }
}

