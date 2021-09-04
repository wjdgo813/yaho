//
//  RecordTimeCell.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/27.
//

import UIKit

final class RecordTimeCell: UITableViewCell, CellFactory {
    static let identifier = "RecordTimeCell"

    @IBOutlet private weak var totalTimeLabel: UILabel!
    @IBOutlet private weak var totalDetailTimeLabel: UILabel!
    @IBOutlet private weak var runningTimeLabel: UILabel!
    @IBOutlet private weak var restingTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindData(value: Model.Record) {
    
        
        let sorted = value.points?.sorted { lPoint, rPoint in
            lPoint.timeStamp < rPoint.timeStamp
        }

        let startTime = sorted?.first?.timeStamp
        let lastTime = sorted?.last?.timeStamp
        
        self.totalTimeLabel.text = value.totalTime.toTimeString()
        self.totalDetailTimeLabel.text = "\(startTime?.string(WithFormat: "a hh:mm") ?? "") ~ \(lastTime?.string(WithFormat: "a hh:mm") ?? "")"
        self.runningTimeLabel.text = value.runningTime.toTimeString()
        self.restingTimeLabel.text = (value.totalTime - value.runningTime).toTimeString()
    }
}

extension RecordTimeCell: CellRegister {
    static let nibName = "RecordTimeCell"
}


