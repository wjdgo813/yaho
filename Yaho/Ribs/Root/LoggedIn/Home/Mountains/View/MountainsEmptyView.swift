//
//  MountainsEmptyView.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/23.
//

import UIKit

class MountainsEmptyView: UIView {
    static func getSubView<T>(value: T.Type) -> T? {
        return (Bundle.main.loadNibNamed("MountainsEmptyView", owner: nil, options: nil)
            as? [UIView])?.first{($0.restorationIdentifier == "MountainsEmptyView")}
            as? T
    }
}
