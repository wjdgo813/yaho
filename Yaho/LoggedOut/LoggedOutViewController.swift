//
//  LoggedOutViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/06/27.
//

import RIBs
import RxSwift
import UIKit

protocol LoggedOutPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable {

    weak var listener: LoggedOutPresentableListener?
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var authSend: RoundButton!
    @IBOutlet private weak var authTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setBind()
    }
}

extension LoggedOutViewController {
    private func setupUI() {
        
    }
    
    private func setBind() {
        
    }
}
