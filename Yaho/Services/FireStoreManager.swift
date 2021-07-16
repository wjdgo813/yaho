//
//  FireStoreInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/07.
//

import FirebaseFirestore
import FirebaseAuth.FIRUser

final class FireStoreManager: StoreServiceProtocol {
    private let db = Firestore.firestore()
    
    func signin(user: User) {
        let collection = self.db
            .collection("user").document(user.uid)
            .collection("total").document(user.uid)
        
        collection.getDocument { (snapShot, error) in
            if let error = error {
                return
            }
            
            if snapShot?.exists ?? false {
                // 기존 유저
            } else {
                // 신규 유저
                collection.setData(TotalClimbing().asDictionary)
            }
        }
    }
    
    func fetchTotal(uid: String,  completion: @escaping ((Result<TotalClimbing,Error>)->())) {
        let collection = self.db
            .collection("user").document(uid)
            .collection("total").document(uid)
            
        collection.getDocument { (document, error) in
            if let document = document,
               let dataDescription = document.data(),
               document.exists {
                 
                do {
                    let data = try JSONSerialization.data(withJSONObject: dataDescription, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    let totalClimb = try decoder.decode(TotalClimbing.self, from: data)
                    completion(.success(totalClimb))
                    print("[FireStoreManager] fetchTotal \(totalClimb)")
                } catch {
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
            }
        }
    }
}
