//
//  HomeViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/13.
//

import RIBs
import RxSwift
import RxCocoa

import UIKit
import Lottie

protocol HomePresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {

    @IBOutlet private weak var totalCountLabel: UILabel!
    @IBOutlet private weak var totalHeightLabel: UILabel!
    @IBOutlet private weak var animationView: UIView!
    private let animation: AnimationView = {
        let animation = AnimationView(animation: Animation.named("data"))
        animation.loopMode = .autoReverse
        animation.play()
        return animation
    }()
    
    weak var listener: HomePresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        self.animationView.addSubview(animation)
        self.animation.frame = self.animationView.frame
    }
}
