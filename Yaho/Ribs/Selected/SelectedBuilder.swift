//
//  SelectedBuilder.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/25.
//

import RIBs

protocol SelectedDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var uid    : String { get }
    var selectedStream: MountainStream { get }
}

final class SelectedComponent: Component<SelectedDependency> {
    fileprivate var selectedStream: MountainStream {
        self.dependency.selectedStream
    }
    
    override init(dependency: SelectedDependency) {
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol SelectedBuildable: Buildable {
    func build(withListener listener: SelectedListener) -> SelectedRouting
}

final class SelectedBuilder: Builder<SelectedDependency>, SelectedBuildable {

    override init(dependency: SelectedDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SelectedListener) -> SelectedRouting {
        let component = SelectedComponent(dependency: dependency)
        let viewController: SelectedViewController = UIStoryboard.init(storyboard: .home).instantiateViewController()
        let interactor = SelectedInteractor(presenter: viewController,
                                            selectedStream: component.selectedStream)
        interactor.listener = listener
        return SelectedRouter(interactor: interactor, viewController: viewController)
    }
}
