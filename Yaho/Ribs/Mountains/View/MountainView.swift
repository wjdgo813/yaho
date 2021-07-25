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
    
    public func compose(name: String, height: Float, level: Model.Mountain.Level) {
        self.nameLabel.text = name
        self.heightLabel.text = "\(height)m"
        self.drawLevel(level)
    }
    
    private func drawLevel(_ level: Model.Mountain.Level) {
        switch level {
        case .platinum:
            self.levels.forEach { view in
                view.backgroundColor = .Green._500
            }
        case .top:
            self.levels.enumerated().filter{ $0.0 < 3 }.map { $0.1 }.forEach { view in
                view.backgroundColor = .Green._500
            }
        case .middle:
            self.levels.enumerated().filter{ $0.0 < 2 }.map { $0.1 }.forEach { view in
                view.backgroundColor = .Green._500
            }
        case .bottom:
            self.levels.enumerated().filter{ $0.0 < 1 }.map { $0.1 }.forEach { view in
                view.backgroundColor = .Green._500
            }
        }
    }
}

