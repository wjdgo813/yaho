//
//  RecordListViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/09/04.
//

import RIBs
import RxSwift
import RxCocoa
import RxDataSources

import UIKit

protocol RecordListPresentableListener: class {
    func didClose()
    func viewDidLoad()
    func changedDate(with date: Date)
    func selectedRecord(with record: Model.Record)
}

final class RecordListViewController: UIViewController, RecordListPresentable, RecordListViewControllable {

    @IBOutlet weak var tableView: UITableView!
    weak var listener: RecordListPresentableListener?
    private let records = BehaviorRelay<[RecordListModel]?>(value: nil)
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
        self.tableView.separatorStyle = .none
        self.tableView.register(RecordListTitleCell.self)
        self.tableView.register(RecordListPeriodCell.self)
        self.tableView.register(RecordListValueCell.self)
    }
    
    private func setBind() {
        self.records
            .debug("[RecordListViewController] records")
            .unwrap()
            .bind(to: self.tableView.rx.items(dataSource: DataSource(configureCell: self.configureCell())))
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.modelSelected(RecordListCellType.self)
            .map { model -> Model.Record? in
                guard case let .record(record) = model else { return nil }
                return record
            }
            .unwrap()
            .subscribe(onNext : { [weak self] record in
                self?.listener?.selectedRecord(with: record)
            }).disposed(by: self.disposeBag)
    }
    
    func setRecord(with record: [RecordListModel]?) {
        self.records.accept(record)
    }
    
    func replaceModal(viewController: ViewControllable?) {
        if let vc = viewController {
            self.navigationController?.pushViewController(vc.uiviewController, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: set RxDataSource
extension RecordListViewController {
    typealias DataSource = RxTableViewSectionedReloadDataSource<RecordListModel>
    typealias ConfigureCell = DataSource.ConfigureCell
    
    private func configureCell() -> ConfigureCell {
        return { [weak self] dataSource, tableView, indexPath, _ in
            guard let self = self else { return UITableViewCell() }
            switch dataSource[indexPath] {
            case .title(let date):
                let cell = tableView.getCell(value: RecordListTitleCell.self, indexPath: indexPath, data: date)
                cell.rx.tapPeriod
                    .flatMap { [weak self] _ -> Observable<Date?> in
                        guard let self = self else { return .empty() }
                        return RecordListPickDateViewController.createInstance(()).getStream(WithPresenter: self,
                                                                                      presentationStyle: .overFullScreen,
                                                                                      transitionStyle: .crossDissolve)
                    }
                    .unwrap()
                    .subscribe(onNext: { [weak self] selectedDate in
                        self?.listener?.changedDate(with: selectedDate)
                    }).disposed(by: cell.reusableBag)
                return cell
                
            case .date(let date):
                let cell = tableView.getCell(value: RecordListPeriodCell.self, indexPath: indexPath, data: date)
                return cell
                
            case .record(let record):
                let cell = tableView.getCell(value: RecordListValueCell.self, indexPath: indexPath, data: record)
                return cell
            }
        }
    }
}
