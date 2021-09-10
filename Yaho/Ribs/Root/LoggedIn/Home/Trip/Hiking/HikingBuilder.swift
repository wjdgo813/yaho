//
//  HikingBuilder.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/09.
//

import RIBs

protocol HikingDependency: Dependency {
    var uid    : String { get }
    var selectedStream: MountainStream { get }
    var storeService  : StoreServiceProtocol { get }
    var countStream   : VisitCountStream { get }
    var mutableRecordStream: MutableRecordStream { get }
}

final class HikingComponent: Component<HikingDependency> {
    fileprivate var selectedStream: MountainStream {
        self.dependency.selectedStream
    }
    
    fileprivate var uid: String {
        self.dependency.uid
    }
    
    fileprivate var service: StoreServiceProtocol {
        self.dependency.storeService
    }
    
    fileprivate var countStream: VisitCountStream {
        self.dependency.countStream
    }
    
    var mutableRecordStream: MutableRecordStream {
        self.dependency.mutableRecordStream
    }
}

// MARK: - Builder

protocol HikingBuildable: Buildable {
    func build(withListener listener: HikingListener) -> HikingRouting
}

final class HikingBuilder: Builder<HikingDependency>, HikingBuildable {

    override init(dependency: HikingDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: HikingListener) -> HikingRouting {
        let component = HikingComponent(dependency: dependency)
        let viewController: HikingViewController = UIStoryboard.init(storyboard: .trip).instantiateViewController()
        viewController.modalTransitionStyle = .crossDissolve
        let interactor = HikingInteractor(presenter: viewController,
                                          uid: component.uid,
                                          mutableRecord: component.mutableRecordStream,
                                          selected: component.selectedStream,
                                          countStream: component.countStream,
                                          service: component.service)
        interactor.listener = listener
        return HikingRouter(interactor: interactor, viewController: viewController)
    }
}
