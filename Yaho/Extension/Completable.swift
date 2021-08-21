//
//  Completable.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/22.
//

import UIKit
import RxSwift

public protocol Completable: class {
    associatedtype R
    var completion: ((R) -> Void)! { get set }
}

extension Completable where Self: UIViewController {
    public func getStream(WithPresenter presenter: UIViewController, presentationStyle: UIModalPresentationStyle, transitionStyle: UIModalTransitionStyle = .coverVertical) -> Observable<R> {
        return Observable<R>.create { [unowned self] observer -> Disposable in
            self.completion = { value in
                observer.onNext(value)
            }

            self.modalTransitionStyle = transitionStyle
            self.modalPresentationStyle = presentationStyle
     
            presenter.present(self, animated: true, completion: nil)
     
            return Disposables.create { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
