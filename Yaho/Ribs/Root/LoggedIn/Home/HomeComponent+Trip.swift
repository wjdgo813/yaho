//
//  HomeComponent+Trip.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/07.
//

import RIBs

// TODO: Update RootDependency protocol to inherit this protocol.
protocol HomeDependencyTrip: Dependency {
    
    // TODO: Declare dependencies needed from the parent scope of LoggedIn to provide dependencies
    // for the child scope.
}

extension HomeComponent: TripDependency {
    var tripViewController: TripViewControllable {
        self.homeViewController
    }
}
