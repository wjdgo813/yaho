//
//  LoggedInBuilder.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/06.
//

import RIBs
import FirebaseAuth.FIRUser

protocol LoggedInDependency: Dependency {
    // TODO: Make sure to convert the variable into lower-camelcase.
    var loggedInViewController: LoggedInViewControllable { get }
    var service: StoreServiceProtocol { get }
}

final class LoggedInComponent: Component<LoggedInDependency> {
    
    let session: User
    
    var service: StoreServiceProtocol {
        return dependency.service
    }
    
    fileprivate var loggedInViewController: LoggedInViewControllable {
        return dependency.loggedInViewController
    }
    
    init(dependency: LoggedInDependency, session: User) {
        self.session = session
        super.init(dependency: dependency)
    }
    
}

// MARK: - Builder
protocol LoggedInBuildable: Buildable {
    func build(withListener listener: LoggedInListener, userSession: User) -> LoggedInRouting
}

final class LoggedInBuilder: Builder<LoggedInDependency>, LoggedInBuildable {

    override init(dependency: LoggedInDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LoggedInListener, userSession: User) -> LoggedInRouting {
        let component = LoggedInComponent(dependency: dependency,
                                          session: userSession)
        let viewController: LoggedInViewController = UIStoryboard.init(storyboard: .home).instantiateViewController()
        let interactor = LoggedInInteractor(presenter: viewController)
        let homeBuilder = HomeBuilder(dependency: component)
        viewController.modalPresentationStyle = .fullScreen
        interactor.listener = listener
        return LoggedInRouter(interactor: interactor,
                              viewController: viewController,
                              homeBuilder: homeBuilder)
    }
}
