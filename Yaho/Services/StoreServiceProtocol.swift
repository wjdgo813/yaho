//
//  StoreServiceProtocol.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/13.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth.FIRUser

import RxSwift

protocol ServiceProtocol {
    var db: Firestore { get }
}

// MARK: [파베 전화번호 인증 및 로그인 처리]
protocol AuthServiceProtocol: ServiceProtocol {
    func signin(user: User)
}

// MARK: [산 리스트 및 등산 누적 데이터 조회]
protocol MainServiceProtocol: ServiceProtocol {
    func fetchTotal(uid: String,  completion: @escaping ((Result<Model.TotalClimbing,Error>)->()))
    func fetchMountains(completion: @escaping ((Result<[Model.Mountain],Error>)->()))
}

// MARK: [등산 시작 전]
protocol ReadyServiceProtocol: ServiceProtocol {
    func fetchVisit(uid: String, mountainID: String, completion: @escaping ((Int)->()))
}

// MARK: [등산 기록 조회]
protocol HistoryServicProtocol: ServiceProtocol {
    
}

// MARK: [등산 데이터 저장 및 조회]
protocol StoreServiceProtocol: ServiceProtocol {
    func fetchRecord(uid: String, completion: @escaping ((Result<[Model.Record],Error>)->()))
    func saveRecord(with uid: String, record: Model.Record, completion: @escaping ((Result<Void,Error>)->()))
    func saveTotalRecord(with uid: String, record: Model.Record, completion: @escaping ((Result<Void,Error>)->()))
    func saveIncreaseVisit(mountain: Model.Mountain, uid: String, completion: @escaping ((Result<Void,Error>)->()))
}
