//
//  RecordListPeriodCell.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/09/05.
//

import UIKit

final class RecordListPeriodCell: UITableViewCell, CellFactory {
    static let identifier = "RecordListPeriodCell"

    @IBOutlet private weak var periodLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindData(value: String) {
        self.periodLabel.text = value
    }
}

extension RecordListPeriodCell: CellRegister {
    static let nibName = "RecordListPeriodCell"
}
