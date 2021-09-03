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
    
    func bindData(value: (section: [Model.Record.SectionHiking], points: [Model.Record.HikingPoint])) {
        let sorted = value.points.sorted { lPoint, rPoint in
            lPoint.timeStamp < rPoint.timeStamp
        }
        
        let totalrunningTime = value.section.reduce(0) { $0 + $1.runningTime}
        
        let startTime = sorted.first?.timeStamp
        let lastTime = sorted.last?.timeStamp
        let totalTime = lastTime?.timeIntervalSince(startTime ?? Date()) ?? 0.0
        
        self.totalTimeLabel.text = Int(totalTime).toTimeString()
        self.totalDetailTimeLabel.text = "\(startTime?.string(WithFormat: "a hh:mm") ?? "") ~ \(lastTime?.string(WithFormat: "a hh:mm") ?? "")"
        self.runningTimeLabel.text = totalrunningTime.toTimeString()
        self.restingTimeLabel.text = (Int(totalTime) - totalrunningTime).toTimeString()
    }
}

extension RecordTimeCell: CellRegister {
    static let nibName = "RecordTimeCell"
}


