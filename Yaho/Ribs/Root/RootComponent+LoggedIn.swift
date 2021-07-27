//
//  RootComponent+LoggedIn.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/06.
//

import RIBs

protocol RootDependencyLoggedIn: Dependency {

    // TODO: Declare dependencies needed from the parent scope of Root to provide dependencies
    // for the LoggedIn scope.
}

extension RootComponent: LoggedInDependency {
    
    var loggedInViewController: LoggedInViewControllable {
        return rootViewController
    }
}
