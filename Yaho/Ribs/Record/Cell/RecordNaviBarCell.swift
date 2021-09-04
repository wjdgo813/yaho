//
//  RecordNaviBarCell.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/26.
//

import UIKit
import RxSwift
import RxCocoa

final class RecordNaviBarCell: UITableViewCell, CellFactory {
    static let identifier = "RecordNaviBarCell"
    
    @IBOutlet fileprivate weak var closeButton: UIButton!
    public var reusableBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reusableBag = DisposeBag()
    }
    
    func bindData(value: Void) {
        
    }
}

extension RecordNaviBarCell: CellRegister {
    static let nibName = "RecordNaviBarCell"
}

extension Reactive where Base: RecordNaviBarCell {
    var tapClose: ControlEvent<Void> {
        return ControlEvent(events: base.closeButton.rx.tap)
    }
}
