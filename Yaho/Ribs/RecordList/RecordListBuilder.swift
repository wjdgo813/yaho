//
//  RecordListBuilder.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/09/04.
//

import RIBs

protocol RecordListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RecordListComponent: Component<RecordListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RecordListBuildable: Buildable {
    func build(withListener listener: RecordListListener) -> RecordListRouting
}

final class RecordListBuilder: Builder<RecordListDependency>, RecordListBuildable {

    override init(dependency: RecordListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RecordListListener) -> RecordListRouting {
        let component = RecordListComponent(dependency: dependency)
        let viewController = RecordListViewController()
        let interactor = RecordListInteractor(presenter: viewController)
        interactor.listener = listener
        return RecordListRouter(interactor: interactor, viewController: viewController)
    }
}
