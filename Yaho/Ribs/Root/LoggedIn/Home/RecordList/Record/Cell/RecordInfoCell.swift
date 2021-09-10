//
//  RecordInfoCell.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/27.
//

import UIKit

final class RecordInfoCell: UITableViewCell, CellFactory {
    static let identifier = "RecordInfoCell"

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var mountainLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindData(value: Model.Record) {
        self.dateLabel.text = value.date.getIsoToDate()?.string(WithFormat: "yyyy.MM.dd (E)") ?? ""
        self.mountainLabel.text = value.mountainName
        self.countLabel.text = "\(value.visitCount)"
        self.addressLabel.text = value.address
    }
}

extension RecordInfoCell: CellRegister {
    static let nibName          = "RecordInfoCell"
}
