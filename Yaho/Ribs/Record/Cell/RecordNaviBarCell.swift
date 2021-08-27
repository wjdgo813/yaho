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
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
