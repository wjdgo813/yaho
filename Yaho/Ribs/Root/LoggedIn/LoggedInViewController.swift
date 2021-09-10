//
//  LoggedInViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/17.
//

import UIKit
import RIBs

protocol LoggedInPresentableListener: class {
}

class LoggedInViewController: UINavigationController, LoggedInPresentable, LoggedInViewControllable  {
    
    weak var listener: LoggedInPresentableListener?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func replaceModal(viewController: ViewControllable?) {
        if let vc = viewController?.uiviewController {
            self.setViewControllers([vc], animated: false)
        }
    }
}
