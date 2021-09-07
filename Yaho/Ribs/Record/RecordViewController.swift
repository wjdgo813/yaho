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
    func didClose()
}

final class RecordViewController: UIViewController, RecordPresentable, RecordViewControllable {

    @IBOutlet weak var tableview: UITableView!
    weak var listener: RecordPresentableListener?
    private let records = BehaviorRelay<[RecordModel]?>(value: nil)
    private let disposeBag = DisposeBag()
    
    deinit {
        debugPrint("\(#file)_\(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.listener?.viewDidLoad()
        self.setTableView()
        self.setBind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent {
            self.listener?.didClose()
        }
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
            .debug("[RecordViewController] records")
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
                    cell.rx.tapClose
                        .subscribe(onNext: { [weak self] in
                            self?.listener?.didClose()
                        }).disposed(by: cell.reusableBag)
                    return cell
                    
                case .mapView(let points):
                    let cell = tableView.getCell(value: RecordMapCell.self, indexPath: indexPath, data: points)
                    return cell
                    
                case .info(let record):
                    let cell = tableView.getCell(value: RecordInfoCell.self, indexPath: indexPath, data: record)
                    return cell
                    
                case .section(let section, let points):
                    let cell = tableView.getCell(value: RecordSectionCell.self, indexPath: indexPath, data: (section,points))
                    return cell
                    
                case .detailTime(let record):
                    let cell = tableView.getCell(value: RecordTimeCell.self, indexPath: indexPath, data: record)
                    return cell
                    
                case .detailDistance(let title, let value):
                    let cell = tableView.getCell(value: RecordCell.self, indexPath: indexPath, data: (title,value))
                    return cell
                case .detailCalrory(let title, let value):
                    let cell = tableView.getCell(value: RecordCell.self, indexPath: indexPath, data: (title,value))
                    return cell
                case .detailPace(let title, let firstTitle, let firstValue, let secondTitle, let secondValue):
                    let cell = tableView.getCell(value: RecordValueCell.self, indexPath: indexPath, data: (title, firstTitle, firstValue, secondTitle, secondValue))
                    return cell
                case .detailAltitude(let title, let firstTitle, let firstValue, let secondTitle, let secondValue):
                    let cell = tableView.getCell(value: RecordValueCell.self, indexPath: indexPath, data: (title, firstTitle, firstValue, secondTitle, secondValue))
                    return cell
                }
        }
    }
}
