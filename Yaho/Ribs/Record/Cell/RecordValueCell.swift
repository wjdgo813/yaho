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

    func bindData(value: Void) {
        
    }
}

extension RecordValueCell: CellRegister {
    static let nibName = "RecordValueCell"
}
