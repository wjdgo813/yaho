//
//  RecordDetailView.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/27.
//

import UIKit

final class RecordDetailView: UIView {

    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var runningTimeLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var calroryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.infoView.cornerRadius([.topRight, .bottomRight], radius: 30)
    }
    
    func compose(number: Int, title: String, time: String, runningTime: String, distance: String, calrory: String) {
        self.numberLabel.text = "\(number)"
        self.titleLabel.text = title
        self.timeLabel.text = time
        self.runningTimeLabel.text = runningTime
        self.distanceLabel.text = distance
        self.calroryLabel.text = calrory
    }
    
    func setHiddenInfo(_ isHidden: Bool) {
        self.infoView.isHidden = isHidden
    }

    static func getSubView<T>(value: T.Type) -> T? {
        return (Bundle.main.loadNibNamed("RecordDetailView", owner: nil, options: nil)
            as? [UIView])?.first{($0.restorationIdentifier == "RecordDetailView")}
            as? T
    }
}
