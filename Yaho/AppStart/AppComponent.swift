//
//  AppComponent.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/01.
//

import RIBs


class AppComponent: Component<EmptyDependency>, RootDependency {

    init() {
        super.init(dependency: EmptyComponent())
    }
}

