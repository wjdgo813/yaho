//
//  RecordViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/26.
//

import RIBs
import RxSwift
import RxDataSources
import UIKit
import RxCocoa

protocol RecordPresentableListener: class {
    func viewDidLoad()
}

final class RecordViewController: UIViewController, RecordPresentable, RecordViewControllable {

    @IBOutlet weak var tableview: UITableView!
    weak var listener: RecordPresentableListener?
    private let records = BehaviorRelay<[RecordModel]?>(value: nil)
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listener?.viewDidLoad()
        self.setTableView()
        self.setBind()
    }
    
    private func setTableView() {
        self.tableview.separatorStyle = .none
        self.tableview.register(RecordNaviBarCell.self)
        self.tableview.register(RecordMapCell.self)
        self.tableview.register(RecordInfoCell.self)
        self.tableview.register(RecordSectionCell.self)
        self.tableview.register(RecordTimeCell.self)
        self.tableview.register(RecordCell.self)
        self.tableview.register(RecordValueCell.self)
    }
    
    private func setBind() {
        self.records
            .unwrap()
            .bind(to: self.tableview.rx.items(dataSource: DataSource(configureCell: self.configureCell())))
            .disposed(by: self.disposeBag)
    }
    
    func setRecord(with record: [RecordModel]?) {
        self.records.accept(record)
    }
}

// MARK: set RxDataSource
extension RecordViewController {
    typealias DataSource = RxTableViewSectionedReloadDataSource<RecordModel>
    typealias ConfigureCell = DataSource.ConfigureCell
    
    private func configureCell() -> ConfigureCell {
        return { [weak self] dataSource, tableView, indexPath, _ in
            guard let self = self else { return  UITableViewCell() }
                switch dataSource[indexPath] {
                case .naviBar,.modalBar:
                    let cell = tableView.getCell(value: RecordNaviBarCell.self, indexPath: indexPath, data: ())
                    return cell
                    
                case .mapView(points: let points):
                    let cell = tableView.getCell(value: RecordMapCell.self, indexPath: indexPath, data: points)
                    return cell
                    
                case .info(let record):
                    let cell = tableView.getCell(value: RecordInfoCell.self, indexPath: indexPath, data: record)
                    return cell
                    
                case .section(let section, let points):
                    let cell = tableView.getCell(value: RecordSectionCell.self, indexPath: indexPath, data: (section,points))
                    return cell
                    
                case .detailTime:
                    let cell = tableView.getCell(value: RecordTimeCell.self, indexPath: indexPath, data: ())
                    return cell
                    
                case .detailDistance:
                    let cell = tableView.getCell(value: RecordCell.self, indexPath: indexPath, data: ())
                    return cell
                case .detailCalrory:
                    let cell = tableView.getCell(value: RecordCell.self, indexPath: indexPath, data: ())
                    return cell
                case .detailPace:
                    let cell = tableView.getCell(value: RecordValueCell.self, indexPath: indexPath, data: ())
                    return cell
                case .detailAltitude:
                    let cell = tableView.getCell(value: RecordValueCell.self, indexPath: indexPath, data: ())
                    return cell
                }
        }
    }
}