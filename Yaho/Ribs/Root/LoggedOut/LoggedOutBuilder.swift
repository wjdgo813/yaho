//
//  LoggedOutBuilder.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/06/27.
//

import RIBs

protocol LoggedOutDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var authService: AuthServiceProtocol { get }
}

final class LoggedOutComponent: Component<LoggedOutDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    fileprivate var authService: AuthServiceProtocol {
        return dependency.authService
    }
}

// MARK: - Builder

protocol LoggedOutBuildable: Buildable {
    func build(withListener listener: LoggedOutListener) -> LoggedOutRouting
}

final class LoggedOutBuilder: Builder<LoggedOutDependency>, LoggedOutBuildable {

    override init(dependency: LoggedOutDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LoggedOutListener) -> LoggedOutRouting {
        let component      = LoggedOutComponent(dependency: dependency)
        let viewController: LoggedOutViewController = UIStoryboard(storyboard: .loggedOut).instantiateViewController()
        viewController.modalPresentationStyle = .fullScreen
        let interactor = LoggedOutInteractor(presenter: viewController, service: component.authService)
        interactor.listener = listener
        return LoggedOutRouter(interactor: interactor, viewController: viewController)
    }
}
