//
//  RecordListPickDateViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/09/06.
//

import UIKit
import MonthYearPicker
import RxSwift
import RxCocoa

final class RecordListPickDateViewController: UIViewController {
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var pickerContainerView: UIView!
    private let disposeBag = DisposeBag()
    
    var completion: ((Date?) -> ())!
    private var selectedDate: Date = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setBind()
    }
    
    private func setupUI() {
        self.view.layoutIfNeeded()
        
        let picker = MonthYearPickerView(frame: self.pickerContainerView.frame)
        picker.maximumDate = Calendar.current.date(byAdding: .year, value: 12, to: Date())
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        self.pickerContainerView.addSubview(picker)
        picker.fillSuperview()
    }
    
    private func setBind() {
        self.confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: {
                    self?.completion(self?.selectedDate)
                })
            }).disposed(by: self.disposeBag)
    }
    
    @IBAction func tappedGesture(_ sender: Any) {
        self.dismiss(animated: true) {
            self.completion(nil)
        }
    }
    
    @objc func dateChanged(_ picker: MonthYearPickerView) {
        print("date changed: \(picker.date)")
        self.selectedDate = picker.date
    }
}

extension RecordListPickDateViewController: VCFactoriable {
    public static var storyboardIdentifier = "Record"
    public static var vcIdentifier = "RecordListPickDateViewController"
    public func bindData(value: Void) {
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle   = .crossDissolve
    }
}

extension RecordListPickDateViewController: Completable {}
