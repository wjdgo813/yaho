//
//  UIViewController+.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/05.
//

import UIKit

extension UINavigationController {
    public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    public func popViewController(animated: Bool, completion: (() -> Void)? = nil) -> UIViewController? {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        let viewController = self.popViewController(animated: animated)
        CATransaction.commit()
        return viewController
    }
    
    public func popToRootViewController(animated: Bool, completion: (() -> Void)? = nil) -> [UIViewController]? {
        CATransaction.begin()
//        CATransaction.setCompletionBlock(completion)
        let viewControllers = self.popToRootViewController(animated: animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            completion?()
        }
        CATransaction.commit()
        return viewControllers
    }
    
    public func setViewControllers(_ viewControllers: [UIViewController], animated: Bool, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.setViewControllers(viewControllers, animated: animated)
        CATransaction.commit()
    }
}
