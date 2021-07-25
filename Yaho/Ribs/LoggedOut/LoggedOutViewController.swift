//
//  LoggedOutViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/06/27.
//
import UIKit

import RIBs
import RxSwift
import RxCocoa
import FirebaseAuth

protocol LoggedOutPresentableListener: class {
    func auth(phoneNumber: String)
    func signin(authText: String)
}

final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable {

    weak var listener: LoggedOutPresentableListener?
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var authSend: RoundButton!
    @IBOutlet private weak var authTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var authErrorLabel: UILabel! {
        didSet {
            self.authErrorLabel.isHidden = true
        }
    }
    @IBOutlet private weak var phoneNumberErrorLabel: UILabel! {
        didSet {
            self.phoneNumberErrorLabel.isHidden = true
        }
    }
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initial()
        self.setupUI()
        self.setBind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
}

extension LoggedOutViewController {
    private func initial() {
        Auth.auth().languageCode = "kr";
    }
    
    private func setupUI() {
        
    }
    
    private func setBind() {
        
        self.authSend.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.listener?.auth(phoneNumber: "+82 010-2543-6349")
            }).disposed(by: self.disposeBag)
        
        self.loginButton.rx.tap
            .map { [weak self] in
                self?.authTextField.text ?? ""
            }
            .subscribe(onNext: { [weak self] authText in
                self?.listener?.signin(authText: authText)
            }).disposed(by: self.disposeBag)
        
        Observable.merge(self.authSend.rx.tap.asObservable(),
                         self.loginButton.rx.tap.asObservable())
            .subscribe(onNext: { [weak self] in
                self?.phoneNumberErrorLabel.isHidden = true
                self?.authErrorLabel.isHidden        = true
                self?.authTextField.resignFirstResponder()
                self?.phoneTextField.resignFirstResponder()

            }).disposed(by: self.disposeBag)
    }
    
    func showPhoneNumberError() {
        self.phoneNumberErrorLabel.isHidden = false
    }
    
    func verifiedPhoneNumber() {
        self.authTextField.becomeFirstResponder()
    }
    
    func showAuthError() {
        self.authErrorLabel.isHidden = false
    }
}
