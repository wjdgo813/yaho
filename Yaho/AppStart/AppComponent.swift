//
//  AppComponent.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/01.
//

import RIBs


class AppComponent: Component<EmptyDependency>, RootDependency {
    var service: StoreServiceProtocol

    init() {
        self.service = FireStoreManager()
        super.init(dependency: EmptyComponent())
    }
}

