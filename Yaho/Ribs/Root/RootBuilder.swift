//
//  RootBuilder.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/06/27.
//

import RIBs
import FirebaseAuth.FIRUser

protocol RootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var service: MainServiceProtocol { get }
}

final class RootComponent: Component<RootDependency> {
    let rootViewController: RootViewController
    let authService: AuthServiceProtocol
    
    fileprivate var service: MainServiceProtocol {
        self.dependency.service
    }
    
    var mutableMountainsStream: MutableMountainsStream {
        return shared { MountainsStreamImpl() }
    }
    
    init(dependency: RootDependency,
         rootViewController: RootViewController,
         authService: AuthServiceProtocol) {
        self.rootViewController = rootViewController
        self.authService = authService
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
                                           rootViewController: viewController,
                                           authService: AuthServiceManager())
        let interactor     = RootInteractor(presenter: viewController,
                                            service: self.dependency.service,
                                            mutableMountainsStream: component.mutableMountainsStream)
        
        let loggedOutBuilder = LoggedOutBuilder(dependency: component)
        let loggedInBuilder  = LoggedInBuilder(dependency: component)
        let router           = RootRouter(interactor: interactor,
                                          viewController: viewController,
                                          loggedOutBuilder: loggedOutBuilder,
                                          loggedInBuilder: loggedInBuilder)
        
        return router
    }
}
