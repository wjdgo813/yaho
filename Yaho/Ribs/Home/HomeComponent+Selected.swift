//
//  HomeComponent+Selected.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/05.
//

import RIBs

/// The dependencies needed from the parent scope of Root to provide for the LoggedOut scope.
// TODO: Update RootDependency protocol to inherit this protocol.
protocol HomeDependencySelected: Dependency {
    
    // TODO: Declare dependencies needed from the parent scope of LoggedIn to provide dependencies
    // for the child scope.
}

extension HomeComponent: SelectedDependency {
    var selectedStream: MountainStream {
        self.mutableSelectedStream
    }
}

