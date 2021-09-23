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
    
    public func compose(title: String, dimmed: Bool = false, imageName: String?, backgroundColor: UIColor) {
        self.titleLabel.text = title
        self.optionButton.backgroundColor = backgroundColor
        
        if let name = imageName {
            self.imageView.image = UIImage(named: name)
            self.imageView.isHidden = false
        } else {
            self.imageView.isHidden = true
        }

        if dimmed {
            self.titleLabel.textColor = UIColor(red: 0.33, green: 0.37, blue: 0.41, alpha: 0.5)
        }
    }
}
