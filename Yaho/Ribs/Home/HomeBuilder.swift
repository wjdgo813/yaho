//
//  HomeBuilder.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/13.
//

import RIBs
import FirebaseAuth.FIRUser

protocol HomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var service: StoreServiceProtocol { get }
    var session: User { get }
    var mountains: [Mountain] { get }
}

final class HomeComponent: Component<HomeDependency> {

    var service: StoreServiceProtocol {
        self.dependency.service
    }
    
    var uid: String {
        self.dependency.session.uid
    }
    
    var mountains: [Mountain] {
        self.dependency.mountains
    }
    
    override init(dependency: HomeDependency) {
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol HomeBuildable: Buildable {
    func build(withListener listener: HomeListener) -> HomeRouting
}

final class HomeBuilder: Builder<HomeDependency>, HomeBuildable {

    override init(dependency: HomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: HomeListener) -> HomeRouting {
        let component = HomeComponent(dependency: self.dependency)
        let viewController: HomeViewController = UIStoryboard.init(storyboard: .home).instantiateViewController()
        let interactor = HomeInteractor(presenter: viewController,
                                        service: self.dependency.service,
                                        user: self.dependency.session)
        let mountainsBuilder = MountainsBuilder(dependency: component)
        
        interactor.listener = listener
        viewController.modalPresentationStyle = .fullScreen
        return HomeRouter(interactor: interactor, viewController: viewController, mountain: mountainsBuilder)
    }
}
