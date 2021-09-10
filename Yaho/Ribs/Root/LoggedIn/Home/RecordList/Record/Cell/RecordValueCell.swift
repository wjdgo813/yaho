//
//  RecordValueCell.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/27.
//

import UIKit

final class RecordValueCell: UITableViewCell, CellFactory {
    static let identifier = "RecordValueCell"

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var firstTitleLabel: UILabel!
    @IBOutlet private weak var firstValueLabel: UILabel!
    @IBOutlet private weak var secondTitleLabel: UILabel!
    @IBOutlet private weak var secondValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindData(value: (title: String,
                          firstTitle: String,
                          firstValue: String,
                          secondTitle: String,
                          secondValue: String)) {
        self.titleLabel.text = value.title
        self.firstTitleLabel.text = value.firstTitle
        self.firstValueLabel.text = value.firstValue
        self.secondTitleLabel.text = value.secondTitle
        self.secondValueLabel.text = value.secondValue
    }
}

extension RecordValueCell: CellRegister {
    static let nibName = "RecordValueCell"
}
