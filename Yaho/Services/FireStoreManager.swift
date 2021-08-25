//
//  FireStoreInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/07.
//

import FirebaseFirestore
import FirebaseAuth.FIRUser
import RxSwift

final class AuthServiceManager: AuthServiceProtocol {
    let db: Firestore = Firestore.firestore()
    
    func signin(user: User) {
        let collection = self.db
            .collection("users").document(user.uid)
            .collection("total").document(user.uid)
        
        collection.getDocument { (snapShot, error) in
            if let _ = error {
                return
            }
            
            if snapShot?.exists ?? false {
                // 기존 유저
            } else {
                // 신규 유저
                collection.setData(Model.TotalClimbing().asDictionary)
            }
        }
    }
}

final class MainServiceManager: MainServiceProtocol {
    
    let db = Firestore.firestore()
    
    func fetchTotal(uid: String,  completion: @escaping ((Result<Model.TotalClimbing,Error>)->())) {
        let collection = self.db
            .collection("users").document(uid)
            .collection("total").document(uid)
        
        collection.getDocument { (document, error) in
            if let document = document,
               let dataDescription = document.data(),
               document.exists {
                
                let totalClimb: Model.TotalClimbing = Model.TotalClimbing.asJSON(with: dataDescription)!
                completion(.success(totalClimb))
                print("[FireStoreManager] fetchTotal \(totalClimb)")
            }
            
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchMountains(completion: @escaping ((Result<[Model.Mountain],Error>)->())) {
        self.db
            .collection("mountains").getDocuments { (document, error) in
                if let document = document {
                    
                    let mountains = document.documents.map {
                        Model.Mountain.asJSON(with: $0.data())!
                    }

                    completion(.success(mountains))
                }
                
                if let error = error {
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
            }
    }
    
    private func asJSON<T: Decodable>(with data: Any) -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            return nil
        }
    }
}

final class ReadyServiceManager: ReadyServiceProtocol {
    let db = Firestore.firestore()
    
    func fetchVisit(uid: String, mountainID: String, completion: @escaping ((Int)->())) {
        self.db
            .collection("users").document(uid)
            .collection("visitList").document(mountainID)
            .getDocument { (document, error) in
                if let document = document,
                   document.exists,
                   let dataDescription = document.data(){
                    print("data output: \(dataDescription)")
                    if let visitCount = dataDescription["visitCount"] as? Int {
                        completion(visitCount)
                        return
                    }
                }
                
                completion(0)
            }
    }
}

final class StoreServiceManager: StoreServiceProtocol {
    let db = Firestore.firestore()
    
    func saveRecord(with uid: String, record: Model.Record, completion: @escaping ((Result<Void,Error>)->())) {
        let users = db.collection("users").document(uid)
        
        users.collection("climbingData")
            .document(String(Date().hashValue))
            .setData(record.asDictionary) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
    }
    
    func saveTotalRecord(with uid: String, record: Model.Record, completion: @escaping ((Result<Void,Error>)->())) {
        let collection = self.db
            .collection("users").document(uid)
            .collection("total").document(uid)
        
        collection.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }
            
            if let document = document,
               let dataDescription = document.data(),
               document.exists {
                
                let totalClimb: Model.TotalClimbing = Model.TotalClimbing.asJSON(with: dataDescription)!
                let saveTotal = Model.TotalClimbing(allDistance: totalClimb.allDistance + record.distance,
                                                    allHeight: totalClimb.allHeight + record.maxHeight,
                                                    allTime: totalClimb.allTime + record.totalTime,
                                                    totalCount: totalClimb.totalCount + 1)
                
                collection.setData(saveTotal.asDictionary)
                completion(.success(()))
            }
        }
    }
    
    func saveIncreaseVisit(mountain: Model.Mountain, uid: String, completion: @escaping ((Result<Void,Error>)->())) {
        let collection = self.db.collection("users").document(uid)
            .collection("visitList").document(String(mountain.id))
        
        collection.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }
            
            if let document = document,
               let dataDescription = document.data(),
               document.exists {
                
                if let visitCount = dataDescription["visitCount"] as? Int {
                    let visit = ["visitCount": visitCount + 1,
                                 "mountainId":mountain.id]
                    collection.setData(visit) { error in
                        if let error = error {
                            completion(.failure(error))
                            print(error.localizedDescription)
                        } else {
                            completion(.success(()))
                        }
                    }
                }
            } else {
                let visit = ["visitCount": 1,
                             "mountainId":mountain.id]
                collection.setData(visit) { error in
                    if let error = error {
                        completion(.failure(error))
                        print(error.localizedDescription)
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }
}
