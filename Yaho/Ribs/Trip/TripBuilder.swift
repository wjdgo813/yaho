//
//  TripBuilder.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/07.
//

import RIBs

protocol TripDependency: Dependency {
    // TODO: Make sure to convert the variable into lower-camelcase.
    var tripViewController: TripViewControllable { get }
    // TODO: Declare the set of dependencies required by this RIB, but won't be
    // created by this RIB.
    var uid    : String { get }
    var selectedStream: MountainStream { get }
}

final class TripComponent: Component<TripDependency> {

    // TODO: Make sure to convert the variable into lower-camelcase.
    var tripViewController: TripViewControllable {
        return dependency.tripViewController
    }
    
    var uid: String {
        self.dependency.uid
    }
    
    var selectedStream: MountainStream {
        self.dependency.selectedStream
    }
    
    var readyService: ReadyServiceProtocol {
        return ReadyServiceManager()
    }
    
    var storeService: StoreServiceProtocol {
        return StoreServiceManager()
    }
    
    var mutableRecordStream: MutableRecordStream {
        return shared { RecordStreamImpl() }
    }
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
        let interactor = TripInteractor()
        interactor.listener = listener

        let countBuilder     = CountBuilder(dependency: component)
        let hikingBuilder    = HikingBuilder(dependency: component)
        
        return TripRouter(interactor    : interactor,
                          viewController: component.tripViewController,
                          count     	: countBuilder,
                          hiking        : hikingBuilder)
    }
}
