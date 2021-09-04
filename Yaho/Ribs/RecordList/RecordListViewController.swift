//
//  RecordListViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/09/04.
//

import RIBs
import RxSwift
import UIKit

protocol RecordListPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RecordListViewController: UIViewController, RecordListPresentable, RecordListViewControllable {

    weak var listener: RecordListPresentableListener?
}
