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
    var mainService: MainServiceProtocol { get }
    var session: User { get }
    var mountainsStream: MountainsStream { get }
}

final class HomeComponent: Component<HomeDependency> {

    fileprivate var mainService: MainServiceProtocol {
        self.dependency.mainService
    }
    
    var mutableSelectedStream: MutableMountainStream {
        return shared { MountainStreamImpl() }
    }
    
    var mutableRecordStream: MutableRecordStream {
        return shared { RecordStreamImpl() }
    }
    
    var mountainsStream: MountainsStream {
        self.dependency.mountainsStream
    }
    
    var selectedStream: MountainStream {
        self.mutableSelectedStream
    }
    
    var uid: String {
        self.dependency.session.uid
    }
    
    var storeService: StoreServiceProtocol {
        StoreServiceManager()
    }
    
    let homeViewController: HomeViewController
    
    init(dependency: HomeDependency,
                  homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
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
        let viewController: HomeViewController = UIStoryboard.init(storyboard: .home).instantiateViewController()
        let component = HomeComponent(dependency: self.dependency, homeViewController: viewController)
        let interactor = HomeInteractor(presenter: viewController,
                                        service: self.dependency.mainService,
                                        user: self.dependency.session)
        let mountainsBuilder  = MountainsBuilder(dependency: component)
        let selectedBuilder   = SelectedBuilder(dependency: component)
        let tripBuidler       = TripBuilder(dependency: component)
        let recordListBuilder = RecordListBuilder(dependency: component)
        
        interactor.listener = listener
        viewController.modalPresentationStyle = .fullScreen
        
        return HomeRouter(interactor: interactor,
                          viewController: viewController,
                          mountain  : mountainsBuilder,
                          selected  : selectedBuilder,
                          trip      : tripBuidler,
                          recordList: recordListBuilder)
    }
}
