//
//  MountainsViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/17.
//

import RIBs
import RxSwift
import UIKit

protocol MountainsPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MountainsViewController: UIViewController, MountainsPresentable, MountainsViewControllable {

    weak var listener: MountainsPresentableListener?
}