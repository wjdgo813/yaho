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
    
    public var reusableBag = DisposeBag()
    @IBOutlet private weak var baseView: StrokeView!
    @IBOutlet private weak var buttonContainerView: UIView!
    @IBOutlet private weak var titleLabel  : UILabel!
    fileprivate var hikingButton: GoHikingButton = GoHikingButton.getSubView(value: GoHikingButton.self)!
    fileprivate var optionView: OptionButton     = OptionButton.getSubView(value: OptionButton.self)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reusableBag = DisposeBag()
    }
    
    func compose(type: HomeCellType) {
        self.buttonContainerView.removeAllSubviews()
        
        switch type {
        case .goHiking(let title):
            self.baseView.backgroundColor = .Green._500
            self.titleLabel.text = title
            self.buttonContainerView.addSubview(self.hikingButton)
            self.hikingButton.fillSuperview()
            
        case .record(let title):
            self.baseView.backgroundColor = .Olive._500
            self.titleLabel.text = title
            self.buttonContainerView.addSubview(self.optionView)
            self.optionView.compose(title: "보러가기",
                                    imageName: "right",
                                    backgroundColor: .Olive._600)
            self.optionView.fillSuperview()
            
        case .removeAd(let title, let isRemove):
            self.baseView.backgroundColor = .Violet._500
            self.titleLabel.text = title
            self.buttonContainerView.addSubview(self.optionView)
//            self.optionView.compose(title: isRemove ? "제거완료" : "제거하기" ,
//                                    imageName: isRemove ? "check" : "right",
//                                    backgroundColor: .Violet._600)
            self.optionView.compose(title: "준비중",
                                    dimmed: true,
                                    imageName: nil,
                                    backgroundColor: .Violet._600)
            self.optionView.fillSuperview()
        }
    }
}

extension Reactive where Base: HomeCell {
    var tapHiking: ControlEvent<Void> {
        return ControlEvent(events: base.hikingButton.hikingButton.rx.tap)
    }
    
    var tapOption: ControlEvent<Void> {
        return ControlEvent(events: base.optionView.optionButton.rx.tap)
    }
}
