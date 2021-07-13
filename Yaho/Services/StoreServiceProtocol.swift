//
//  StoreServiceProtocol.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/13.
//

import Foundation
import FirebaseAuth.FIRUser

protocol StoreServiceProtocol {
    func signin(user: User)
}
