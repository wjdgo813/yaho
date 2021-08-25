//
//  RecordBuilder.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/26.
//

import RIBs

protocol RecordDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var recordStream: RecordStream { get }
}

final class RecordComponent: Component<RecordDependency> {

    fileprivate var recordStream: RecordStream {
        self.dependency.recordStream
    }
}

// MARK: - Builder

protocol RecordBuildable: Buildable {
    func build(withListener listener: RecordListener) -> RecordRouting
}

final class RecordBuilder: Builder<RecordDependency>, RecordBuildable {

    override init(dependency: RecordDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RecordListener) -> RecordRouting {
        let component = RecordComponent(dependency: dependency)
        let viewController:RecordViewController = UIStoryboard.init(storyboard: .record).instantiateViewController()
        let interactor = RecordInteractor(presenter: viewController)
        interactor.listener = listener
        
        return RecordRouter(interactor: interactor, viewController: viewController)
    }
}
