//
//  RecordListTitleCell.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/09/05.
//

import UIKit
import RxSwift
import RxCocoa

final class RecordListTitleCell: UITableViewCell, CellFactory {
    static let identifier = "RecordListTitleCell"
    
    @IBOutlet private weak var periodLabel: UILabel!
    @IBOutlet fileprivate weak var periodButton: UIButton!
    public var reusableBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reusableBag = DisposeBag()
    }
    
    func bindData(value: String) {
        self.periodLabel.text = value
    }
}

extension RecordListTitleCell: CellRegister {
    static let nibName = "RecordListTitleCell"
}

extension Reactive where Base: RecordListTitleCell {
    var tapPeriod: ControlEvent<Void> {
        return ControlEvent(events: base.periodButton.rx.tap)
    }
}
