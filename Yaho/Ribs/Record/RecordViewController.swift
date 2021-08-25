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

protocol RecordPresentableListener: class {
    func viewDidLoad()
}

final class RecordViewController: UIViewController, RecordPresentable, RecordViewControllable {

    @IBOutlet weak var tableview: UITableView!
    weak var listener: RecordPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listener?.viewDidLoad()
    }
    
    func setRecord(with record: Model.Record) {
        
    }
}
