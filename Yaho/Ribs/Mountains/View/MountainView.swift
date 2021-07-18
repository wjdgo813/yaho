//
//  MountainView.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/18.
//

import UIKit

final class MountainView: UIView {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var heightLabel: UILabel!
    @IBOutlet private weak var goButton: UIButton!
    @IBOutlet private var levels: [UIView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    static func getSubView<T>(value: T.Type) -> T? {
        return (Bundle.main.loadNibNamed("MountainView", owner: nil, options: nil)
            as? [UIView])?.first{($0.restorationIdentifier == "MountainView")}
            as? T
    }
    
    public func compose(name: String, height: String, level: Int) {
        self.nameLabel.text = name
        self.heightLabel.text = height
    }
}

