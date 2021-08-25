//
//  Rx+StoreServiceProtocol.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/25.
//

import RxSwift
import RxCocoa

extension MainServiceProtocol {
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

extension StoreServiceProtocol {
    func rxSaveRecord(with uid: String, record: Model.Record) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.saveRecord(with: uid, record: record) { result in
                switch result {
                case .success():
                    observer.onNext(())
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func rxSaveTotalRecord(with uid: String, record: Model.Record) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.saveTotalRecord(with: uid, record: record) { result in
                switch result {
                case .success():
                    observer.onNext(())
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func rxSaveIncreaseVisit(mountain: Model.Mountain, uid: String) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.saveIncreaseVisit(mountain: mountain, uid: uid) { result in
                switch result {
                case .success():
                    observer.onNext(())
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
