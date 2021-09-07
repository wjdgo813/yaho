//
//  RecordMapViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/09/08.
//

import UIKit
import RxSwift
import RxCocoa
import NMapsMap

final class RecordMapViewController: TransitioningViewController {
    @IBOutlet private weak var mapView    : NMFMapView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var naviBar    : UIView!
    @IBOutlet private weak var closeButton: UIButton!
    private var originPoint = CGPoint.zero
    private let disposeBag  = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
    }
    
    override func onWillPresentView(){
        super.onWillPresentView()
        self.contentView.transform = CGAffineTransform(translationX: 0, y: -300).scaledBy(x: 0, y: 0)
    }
    
    override func performCustomPresentationAnimation() {
        super.performCustomPresentationAnimation()
        self.contentView.transform = .identity
    }
    
    
    override func onWillDismissView(){
        super.onWillDismissView()
//        self.contentView.transform = .identity
    }
    
    
    override func performCustomDismissingAnimation() {
        super.performCustomDismissingAnimation()
//        self.contentView.transform = CGAffineTransform(translationX: originPoint.x, y: originPoint.y).scaledBy(x: 0, y: 0)
    }
}

extension RecordMapViewController: VCFactoriable {
    public static var storyboardIdentifier = "Record"
    public static var vcIdentifier = "RecordMapViewController"
    public func bindData(value: CGPoint) {
        self.originPoint = value
        self.animateSetting.animation.present.duration = 1
        self.transitioningDelegate  = self
        self.modalPresentationStyle = .overCurrentContext
    }
}

