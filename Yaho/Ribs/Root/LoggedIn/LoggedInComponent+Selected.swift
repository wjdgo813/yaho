//
//  LoggedInComponent+Selected.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/29.
//

import RIBs

/// The dependencies needed from the parent scope of Root to provide for the LoggedOut scope.
// TODO: Update RootDependency protocol to inherit this protocol.
protocol LoggedInDependencySelected: Dependency {
    
}

extension LoggedInComponent: SelectedDependency {
}

