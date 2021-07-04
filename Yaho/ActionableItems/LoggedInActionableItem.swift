//
//  LoggedInActionableItem.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/04.
//

import RxSwift

protocol LoggedInActionableItem: class {
    func launchGame(with id: String?) -> Observable<(LoggedInActionableItem, ())>
}
