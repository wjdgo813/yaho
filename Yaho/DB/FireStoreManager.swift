//
//  FireStoreInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/07.
//

import FirebaseFirestore
import FirebaseAuth.FIRUser

final class FireStoreManager {
    static let shared = FireStoreManager()
    
    func signIn(user: User) {
        let db = Firestore.firestore()
        let collection = db
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
            }
        }
    }
}
