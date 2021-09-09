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
        self.containerStackview.removeAllArrangedSubviews()
        
        let sorted = value.points.sorted { lPoint, rPoint in
            lPoint.parentSectionID < rPoint.parentSectionID
        }
        
        let pointSet = Set<Model.Record.HikingPoint>(sorted)
        
        value.section.enumerated().forEach { index, section in
            let view = RecordDetailView.getSubView(value: RecordDetailView.self)!
            
            let number = index + 1
            let time = pointSet.first { point in
                point.parentSectionID == index
            }.map { $0.timeStamp.getIsoToDate()?.string(WithFormat: "a hh:mm") ?? "" }
            
            let runningTime = section.runningTime.toTimeString()
            let distance    = "\(section.distance.toKiloMeter())km"
            let calrory     = "\(section.calrories)kcal"
            
            if index == 0 {
                view.compose(number: number,
                             title: "등산 시작",
                             time: time ?? "",
                             runningTime: runningTime,
                             distance: distance,
                             calrory: calrory)
            } else {
                let prevTime = pointSet.first { point in
                    point.parentSectionID == (index - 1)
                }.map { $0.timeStamp.getIsoToDate()?.string(WithFormat: "a hh:mm") ?? "" }
                
                let prev = sorted.last { point in
                    point.parentSectionID == (index - 1)
                }.map { $0.timeStamp.getIsoToDate()?.string(WithFormat: "a hh:mm") ?? "" }
                
                view.compose(number: number,
                             title: "휴식",
                             time: "\(prev ?? "") ~ \(time ?? "")",
                             runningTime: runningTime,
                             distance: distance,
                             calrory: calrory)
            }
            
            self.containerStackview.addArrangedSubview(view)
        }
        
        let lastTime = value.points.last?.timeStamp.getIsoToDate()?.string(WithFormat: "a hh:mm")
        let lastView = RecordDetailView.getSubView(value: RecordDetailView.self)!
        lastView.compose(number: value.section.count + 1,
                         title: "등산 종료",
                         time: lastTime ?? "",
                         runningTime: "",
                         distance: "",
                         calrory: "")
        lastView.setHiddenInfo(true)
        
        self.containerStackview.addArrangedSubview(lastView)
    }
}

extension RecordSectionCell: CellRegister {
    static let nibName = "RecordSectionCell"
}


