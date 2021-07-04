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
    func login()
}

final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable {

    weak var listener: LoggedOutPresentableListener?
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var authSend: RoundButton!
    @IBOutlet private weak var authTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initial()
        self.setupUI()
        self.setBind()
    }
}

extension LoggedOutViewController {
    private func initial() {
        Auth.auth().languageCode = "kr";
    }
    
    private func setupUI() {
        
    }
    
    private func setBind() {
//
        self.authSend.rx.tap
            .flatMap { [weak self] _ -> Observable<String> in
                self?.authProvider(with: "+82 010-2543-6349") ?? .empty()
            }
            .debug("self.authSend.rx.tap")
            .subscribe(onNext: { [weak self] id in
                UserDefaults.standard.set(id, forKey: "authVerificationID")
                self?.authTextField.becomeFirstResponder()
            })
            .disposed(by: self.disposeBag)
        
        self.loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: verificationID ?? "",
                    verificationCode: self?.authTextField.text ?? "")
                
                self?.listener?.login()
            }).disposed(by: self.disposeBag)
    }
}

// MARK: Observable
extension LoggedOutViewController {
    private func authProvider(with phoneNumber: String) -> Observable<String> {
        return Observable.create { observer in
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber,
                                                           uiDelegate: nil) { (id, error) in
                
                observer.onNext(id ?? "")
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
