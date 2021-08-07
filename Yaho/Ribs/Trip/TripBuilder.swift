//
//  TripBuilder.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/07.
//

import RIBs

protocol TripDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TripComponent: Component<TripDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TripBuildable: Buildable {
    func build(withListener listener: TripListener) -> TripRouting
}

final class TripBuilder: Builder<TripDependency>, TripBuildable {

    override init(dependency: TripDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TripListener) -> TripRouting {
        let component = TripComponent(dependency: dependency)
        let viewController = TripViewController()
        let interactor = TripInteractor(presenter: viewController)
        interactor.listener = listener
        return TripRouter(interactor: interactor, viewController: viewController)
    }
}
