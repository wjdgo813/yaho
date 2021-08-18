//
//  HikingBuilder.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/09.
//

import RIBs

protocol HikingDependency: Dependency {
    var selectedStream: MountainStream { get }
}

final class HikingComponent: Component<HikingDependency> {
    fileprivate var selectedStream: MountainStream {
        self.dependency.selectedStream
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
        let interactor = HikingInteractor(presenter: viewController, selected: component.selectedStream)
        interactor.listener = listener
        return HikingRouter(interactor: interactor, viewController: viewController)
    }
}
