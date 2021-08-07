//
//  TripComponent+Count.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/07.
//

import RIBs

/// The dependencies needed from the parent scope of Root to provide for the LoggedOut scope.
// TODO: Update RootDependency protocol to inherit this protocol.
protocol TripDependencyCount: Dependency {
    
    // TODO: Declare dependencies needed from the parent scope of LoggedIn to provide dependencies
    // for the child scope.
}

extension TripComponent: CountDependency {
}


