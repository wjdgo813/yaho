//
//  RestMarkerView.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/20.
//

import UIKit

final class RestMarkerView: UIView {
    @IBOutlet public weak var numberLabel: UILabel!
    
    static func getSubView<T>(value: T.Type) -> T? {
        return (Bundle.main.loadNibNamed("RestMarkerView", owner: nil, options: nil)
            as? [UIView])?.first{($0.restorationIdentifier == "RestMarkerView")}
            as? T
    }
}
