//
//  HomeButton.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/15.
//

import UIKit

final class GoHikingButton: UIView {
    @IBOutlet public weak var hikingButton: RoundButton!
    static func getSubView<T>(value: T.Type) -> T? {
        return (Bundle.main.loadNibNamed("HomeButton", owner: nil, options: nil)
            as? [UIView])?.first{($0.restorationIdentifier == "GoHikingButton")}
            as? T
    }
}

final class OptionButton: UIView {
    @IBOutlet public weak var optionButton: RoundButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    static func getSubView<T>(value: T.Type) -> T? {
        return (Bundle.main.loadNibNamed("HomeButton", owner: nil, options: nil)
            as? [UIView])?.first{($0.restorationIdentifier == "OptionButton")}
            as? T
    }
    
    public func compose(title: String, imageName: String, backgroundColor: UIColor) {
        self.titleLabel.text = title
        self.imageView.image = UIImage(named: imageName)
        self.optionButton.backgroundColor = backgroundColor
    }
}
