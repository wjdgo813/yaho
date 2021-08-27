//
//  RecordSectionCell.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/27.
//

import UIKit

final class RecordSectionCell: UITableViewCell, CellFactory {
    static let identifier = "RecordSectionCell"
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerStackview: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindData(value: (section: [Model.Record.SectionHiking], points: [Model.Record.HikingPoint])) {
        
        
//        value.section.enumerated().forEach { index, section in
//            let view = RecordDetailView.getSubView(value: RecordDetailView.self)!
//            if index == 0 {
//                view.compose(number: index+1, title: "등산 시작", time: section., runningTime: <#T##String#>, distance: <#T##String#>, calrory: <#T##String#>)
//            } else {
//                
//            }
//            
//        }
    }
}

extension RecordSectionCell: CellRegister {
    static let nibName = "RecordSectionCell"
}


