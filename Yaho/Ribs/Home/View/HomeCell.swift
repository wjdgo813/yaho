//
//  HomeCell.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/15.
//

import UIKit
import RxSwift
import RxCocoa

class HomeCell: UICollectionViewCell {

    @IBOutlet private weak var buttonContainerView: UIView!
    @IBOutlet private weak var titleLabel  : UILabel!
    private var hikingButton: GoHikingButton = GoHikingButton.getSubView(value: GoHikingButton.self)!
    private var optionView: OptionButton = OptionButton.getSubView(value: OptionButton.self)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func compose(title: String, type: HomeCellType) {
        self.buttonContainerView.removeAllSubviews()
        
        switch type {
        case .goHiking(let title):
            self.titleLabel.text = title
            self.buttonContainerView.addSubview(self.hikingButton)
            self.hikingButton?.fillSuperview()
            
        case .record(let title):
            self.titleLabel.text = title
            self.buttonContainerView.addSubview(self.optionView)
            self.optionView?.fillSuperview()
            
        case .removeAd(let title, let isRemove):
            self.titleLabel.text = title
            self.buttonContainerView.addSubview(self.optionView)
            self.optionView?.fillSuperview()
        }
    }
    
    
}
