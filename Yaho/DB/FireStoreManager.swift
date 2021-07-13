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
}
