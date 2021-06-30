//
//  RootViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/06/27.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {
    public weak var listener: RootPresentableListener?
    private weak var targetViewController: ViewControllable?
    private var animationInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    func replaceModal(viewController: ViewControllable?) {
        self.targetViewController = viewController
        
        guard !animationInProgress else {
            return
        }
        
        if presentedViewController != nil {
            self.animationInProgress = true
            self.dismiss(animated: true) { [weak self] in
                if let _ = self?.targetViewController {
                    self?.presentTargetViewController()
                } else {
                    self?.animationInProgress = false
                }
            }
        } else {
            self.presentTargetViewController()
        }
    }
    
    private func presentTargetViewController() {
        if let target = self.targetViewController {
            self.animationInProgress = true
            self.present(target.uiviewController, animated: true) { [weak self] in
                self?.animationInProgress = false
            }
        }
    }
}
