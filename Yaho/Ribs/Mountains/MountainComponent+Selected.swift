//
//  MountainComponent+Selected.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/25.
//

import Foundation

import RIBs

/// The dependencies needed from the parent scope of Root to provide for the LoggedOut scope.
// TODO: Update RootDependency protocol to inherit this protocol.
protocol MountainsDependencySelected: Dependency {
    
    // TODO: Declare dependencies needed from the parent scope of LoggedIn to provide dependencies
    // for the child scope.
}

extension MountainsComponent: SelectedDependency {
    
}
