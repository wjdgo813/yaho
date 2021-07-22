//
//  LoggedOutInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/06/27.
//

import RIBs
import RxSwift
import RxCocoa

import Firebase
import FirebaseAuth

protocol LoggedOutRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol LoggedOutPresentable: Presentable {
    var listener: LoggedOutPresentableListener? { get set }
    func showPhoneNumberError()
    func verifiedPhoneNumber()
    func showAuthError()
}

protocol LoggedOutListener: class {
    func didLogin(with user: User)
}

final class LoggedOutInteractor: PresentableInteractor<LoggedOutPresentable>, LoggedOutInteractable, LoggedOutPresentableListener {    

    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?
    private let service: StoreServiceProtocol
    private var verificationID: String = ""
    
    // in constructor.
    init(presenter: LoggedOutPresentable, service: StoreServiceProtocol) {
        self.service = service
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func auth(phoneNumber: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber,
                                                       uiDelegate: nil) { [weak self] (id, error) in
            if let _ = error {
                self?.presenter.showPhoneNumberError()
            }
            
            if let id = id {
                UserDefaults.standard.set(id, forKey: "authVerificationID")
                self?.verificationID = id
                self?.presenter.verifiedPhoneNumber()
            }
        }
    }
    
    func signin(authText: String) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationID,
                                                                 verificationCode: authText)

        Auth.auth().signIn(with: credential) { [weak self] (result, error) in
            if let _ = error {
                self?.presenter.showAuthError()
            }

            if let result = result {
                self?.service.signin(user: result.user)
                self?.listener?.didLogin(with: result.user)
            }
        }
    }
}
