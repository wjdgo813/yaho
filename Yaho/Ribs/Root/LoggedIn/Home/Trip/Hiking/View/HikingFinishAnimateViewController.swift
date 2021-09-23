//
//  HikingFinishAnimateViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/25.
//

import UIKit
import Lottie
import GoogleMobileAds

final class HikingFinishAnimateViewController: UIViewController, Bannerable {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var animateContainerView: UIView!
    private let animation: AnimationView = {
        let animation = AnimationView(animation: Animation.named("data"))
        animation.loopMode = .autoReverse
        animation.play()
        return animation
    }()
    
    var completion: ((()) -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initBanner(root: self)
        self.setupUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.completion(())
        }
    }
    
    private func setupUI() {
        self.animateContainerView.addSubview(animation)
        self.animation.frame = self.animateContainerView.bounds
    }
}

extension HikingFinishAnimateViewController: VCFactoriable {
    public static var storyboardIdentifier = "Trip"
    public static var vcIdentifier = "HikingFinishAnimateViewController"
    public func bindData(value: Void) {
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle   = .crossDissolve
    }
}

extension HikingFinishAnimateViewController: Completable {
}
