//
//  AppComponent.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/01.
//

import RIBs
import NMapsMap

class AppComponent: Component<EmptyDependency>, RootDependency {
    var service: StoreServiceProtocol

    init() {
        self.service = FireStoreManager()
        NMFAuthManager.shared().clientId = "e2xua62w4t"
        super.init(dependency: EmptyComponent())
    }
}

