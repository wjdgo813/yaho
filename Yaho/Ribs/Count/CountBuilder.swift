//
//  CountBuilder.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/05.
//

import RIBs

protocol CountDependency: Dependency {
    var uid    : String { get }
    var selectedStream     : MountainStream { get }
    var readyService       : ReadyServiceProtocol { get }
    var mutableVisitCountStream: MutableVisitCountStream { get }
}

final class CountComponent: Component<CountDependency> {

    fileprivate var uid: String {
        self.dependency.uid
    }
    
    fileprivate var selectedStream: MountainStream {
        self.dependency.selectedStream
    }
    
    fileprivate var service: ReadyServiceProtocol {
        self.dependency.readyService
    }
    
    fileprivate var mutableVisitCountStream: MutableVisitCountStream {
        self.dependency.mutableVisitCountStream
    }
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CountBuildable: Buildable {
    func build(withListener listener: CountListener) -> CountRouting
}

final class CountBuilder: Builder<CountDependency>, CountBuildable {

    override init(dependency: CountDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CountListener) -> CountRouting {
        let component = CountComponent(dependency: dependency)
        let viewController: CountViewController = UIStoryboard.init(storyboard: .trip).instantiateViewController()
        let interactor = CountInteractor(presenter: viewController,
                                         uid: component.uid,
                                         service: component.service,
                                         selectedStream: component.selectedStream,
                                         mutableCountStream: component.mutableVisitCountStream)
        interactor.listener = listener
        return CountRouter(interactor: interactor, viewController: viewController)
    }
}
