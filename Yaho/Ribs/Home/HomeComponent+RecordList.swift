//
//  HomeComponent+RecordList.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/09/05.
//

import RIBs

// TODO: Update RootDependency protocol to inherit this protocol.
protocol HomeDependencyRecordList: Dependency {
    
    // TODO: Declare dependencies needed from the parent scope of LoggedIn to provide dependencies
    // for the child scope.
}

extension HomeComponent: RecordListDependency {
}
