//
//  StoreServiceProtocol.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/13.
//

import Foundation
import FirebaseAuth.FIRUser

import RxSwift

protocol StoreServiceProtocol {
    func signin(user: User)
    func fetchTotal(uid: String,  completion: @escaping ((Result<Model.TotalClimbing,Error>)->()))
    func fetchMountains(completion: @escaping ((Result<[Model.Mountain],Error>)->()))
}

extension StoreServiceProtocol {
    func rxTotal(uid: String) -> Observable<Model.TotalClimbing> {
        return Observable<Model.TotalClimbing>.create { observer in
            self.fetchTotal(uid: uid) { (result) in
                switch result {
                case .success(let total):
                    observer.onNext(total)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func rxMountains() -> Observable<[Model.Mountain]> {
        return Observable<[Model.Mountain]>.create { observer in
            self.fetchMountains { (result) in
                switch result {
                case .success(let mountains):
                    observer.onNext(mountains)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
