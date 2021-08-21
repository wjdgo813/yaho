//
//  HikingFinshViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/22.
//

import UIKit
import RxSwift
import RxCocoa

final class HikingFinshViewController: UIViewController {

    @IBOutlet private weak var keepGoingButton: UIButton!
    @IBOutlet private weak var finishButton   : RoundButton!
    private let disposeBag = DisposeBag()
    var completion: ((Bool) -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Observable.merge(self.finishButton.rx.tap.map { true },
                         self.keepGoingButton.rx.tap.map { false })
            .subscribe(onNext: { [weak self] isEndTrip in
                self?.dismiss(animated: true, completion: {
                    self?.completion(isEndTrip)
                })
            }).disposed(by: self.disposeBag)
    }
}

extension HikingFinshViewController: VCFactoriable {
    public static var storyboardIdentifier = "Trip"
    public static var vcIdentifier = "HikingFinshViewController"
    public func bindData(value: Void) {
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle   = .coverVertical
        self.modalTransitionStyle   = .crossDissolve
    }
}

extension HikingFinshViewController: Completable {}
