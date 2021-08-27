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
    
    func bindData(value: Void) {
        
    }
}

extension RecordTimeCell: CellRegister {
    static let nibName = "RecordTimeCell"
}


