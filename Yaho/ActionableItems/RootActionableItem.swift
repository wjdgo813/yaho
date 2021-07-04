//
//  RootActionableItem.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/04.
//

import RxSwift

protocol RootActionableItem {
    func waitForLogin() -> Observable<(LoggedInActionableItem, ())>
}
