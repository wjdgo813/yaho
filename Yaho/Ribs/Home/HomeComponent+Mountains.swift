//
//  HomeComponent+Mountains.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/23.
//

import Foundation

import RIBs

/// The dependencies needed from the parent scope of Root to provide for the LoggedOut scope.
// TODO: Update RootDependency protocol to inherit this protocol.
protocol HomeDependencyMountains: Dependency {
    
    // TODO: Declare dependencies needed from the parent scope of LoggedIn to provide dependencies
    // for the child scope.
}

extension HomeComponent: MountainsDependency {
    // TODO: Implement properties to provide for AccountSelection scope.
    
}
