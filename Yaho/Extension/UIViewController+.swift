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

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    var haveSafeArea: Bool {
        if #available(iOS 11.0, *) {
            if bottomSafeAreaInset > CGFloat(0) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    var topSafeAreaInset: CGFloat {
        let window = UIApplication.shared.keyWindow
        var topPadding: CGFloat = 0
        if #available(iOS 11.0, *) {
            topPadding = window?.safeAreaInsets.top ?? 0
        }
        
        return topPadding
    }
    
    var bottomSafeAreaInset: CGFloat {
        let window = UIApplication.shared.keyWindow
        var bottomPadding: CGFloat = 0
        
        bottomPadding = window?.safeAreaInsets.bottom ?? 0
        
        
        return bottomPadding
    }
}
