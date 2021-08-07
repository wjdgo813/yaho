//
//  TripViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/07.
//

import RIBs
import RxSwift
import UIKit

protocol TripPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class TripViewController: UIViewController, TripPresentable, TripViewControllable {

    weak var listener: TripPresentableListener?
}
