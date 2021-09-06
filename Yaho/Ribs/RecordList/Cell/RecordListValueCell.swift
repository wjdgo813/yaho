//
//  RecordListValueCell.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/09/05.
//

import UIKit

final class RecordListValueCell: UITableViewCell, CellFactory {
    static let identifier = "RecordListValueCell"

    @IBOutlet weak var calroriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mountainLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindData(value: Model.Record) {
        self.dateLabel.text = value.date.getIsoToDate()?.string(WithFormat: "MM.dd")
        self.mountainLabel.text = value.mountainName
        self.timeLabel.text = value.totalTime.toTimeString()
        self.distanceLabel.text = "\(value.distance.toKiloMeter())km"
        self.calroriesLabel.text = "\(value.calrories)kcal"
    }
}

extension RecordListValueCell: CellRegister {
    static let nibName = "RecordListValueCell"
}
