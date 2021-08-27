//
//  RecordCell.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/27.
//

import UIKit

final class RecordCell: UITableViewCell , CellFactory {
    static let identifier = "RecordCell"

    @IBOutlet private weak var desciptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindData(value: Void) {
        
    }
}

extension RecordCell: CellRegister {
    static let nibName = "RecordCell"
}
