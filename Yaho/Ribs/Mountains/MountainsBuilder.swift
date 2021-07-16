//
//  MountainsBuilder.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/17.
//

import RIBs

protocol MountainsDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MountainsComponent: Component<MountainsDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MountainsBuildable: Buildable {
    func build(withListener listener: MountainsListener) -> MountainsRouting
}

final class MountainsBuilder: Builder<MountainsDependency>, MountainsBuildable {

    override init(dependency: MountainsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MountainsListener) -> MountainsRouting {
        let component = MountainsComponent(dependency: dependency)
        let viewController = MountainsViewController()
        let interactor = MountainsInteractor(presenter: viewController)
        interactor.listener = listener
        return MountainsRouter(interactor: interactor, viewController: viewController)
    }
}
