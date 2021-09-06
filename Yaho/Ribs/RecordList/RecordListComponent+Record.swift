//
//  RecordListComponent+Record.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/09/06.
//

import RIBs

protocol RecordListDependencyRecord: Dependency {
    
    // TODO: Declare dependencies needed from the parent scope of LoggedIn to provide dependencies
    // for the child scope.
}

extension RecordListComponent: RecordDependency {
    var recordStream: RecordStream {
        self.mutableRecordStream
    }
}



