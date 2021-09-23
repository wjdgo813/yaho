//
//  Object+.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/01.
//

import Foundation
import UIKit
import CoreLocation
extension NSObject {    
    public static var className: String {
        return String(describing: self)
    }
    
    public var className: String {
        return String(describing: type(of: self).className)
    }
}

extension UIView {
    public func removeAllSubviews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    public func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
}

extension String {
    public func getDate(dateFormat: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self)
    }
    
    public func getIsoToDate() -> Date? {
        return getDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
    }
}

extension Double {

    func toKiloMeter() -> Double {
        return floor(((self/1000)*10))/10
    }
    
    func secondsToSeconds () -> String {
        return String(format: "%.2f", self)
    }
}

extension Int {
    func toMinutes() -> String {
        return "\(self/60)"
    }
    
    func toSeconds() -> String {
        let seconds: Int = self % 60
        let minutes: Int = (self / 60) % 60
        return String(format: "%2d:%02d", minutes, seconds)
     }
    
    func toTime() -> (hours: Int, minutes: Int, seconds: Int) {
        let hours  : Int = self / 3600
        let minutes: Int = (self / 60) % 60
        let seconds: Int = self % 60
        
        return (hours, minutes, seconds)
     }
    
    func toTimeString() -> String {
        let time = self.toTime()
        if time.hours > 0 {
            return "\(time.hours)시간 \(time.minutes)분 \(time.seconds)초"
        } else {
            return "\(time.minutes)분 \(time.seconds)초"
        }
    }
}

extension Date {
    public func toUTCString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.string(from:self)
    }
    
    public func string(WithFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat    = format
        dateFormatter.timeZone      = TimeZone.current
        dateFormatter.calendar      = Calendar(identifier: Calendar.Identifier.gregorian)
        return dateFormatter.string(from: self)
    }
}

extension UIStackView {
    
    public func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

extension CLLocationCoordinate2D {
    func isValid() -> Bool {
        if self.latitude == 0.0 && self.longitude == 0.0 {
            return false
        }
        
        return true
    }
}
