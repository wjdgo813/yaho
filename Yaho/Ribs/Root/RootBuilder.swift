//
//  RootBuilder.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/06/27.
//

import RIBs

protocol RootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RootComponent: Component<RootDependency> {
    let rootViewController: RootViewController
    
    init(dependency: RootDependency,
         rootViewController: RootViewController) {
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build() -> RootRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {

    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> RootRouting {
        let viewController = RootViewController()
        let component      = RootComponent(dependency: self.dependency,
                                           rootViewController: viewController)
        let interactor     = RootInteractor(presenter: viewController)
        
        let loggedOutBuilder = LoggedOutBuilder(dependency: component)
        let loggedInBuilder  = LoggedInBuilder(dependency: component)
        let router           = RootRouter(interactor: interactor,
                                          viewController: viewController,
                                          loggedOutBuilder: loggedOutBuilder,
                                          loggedInBuilder: loggedInBuilder)
        
        return router
    }
}
