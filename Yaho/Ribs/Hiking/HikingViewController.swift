//
//  HikingViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/09.
//

import RIBs
import RxSwift
import UIKit

protocol HikingPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class HikingViewController: UIViewController, HikingPresentable, HikingViewControllable {

    weak var listener: HikingPresentableListener?
}
