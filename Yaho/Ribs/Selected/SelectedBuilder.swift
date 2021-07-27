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
//    var service: StoreServiceProtocol { get }
    var uid    : String { get }
}

final class SelectedComponent: Component<SelectedDependency> {
    let selected: Model.Mountain
    init(dependency: SelectedDependency, selected: Model.Mountain) {
        self.selected = selected
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol SelectedBuildable: Buildable {
    func build(withListener listener: SelectedListener, selected: Model.Mountain) -> SelectedRouting
}

final class SelectedBuilder: Builder<SelectedDependency>, SelectedBuildable {

    override init(dependency: SelectedDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SelectedListener, selected: Model.Mountain) -> SelectedRouting {
        let component = SelectedComponent(dependency: dependency, selected: selected)
        let viewController: SelectedViewController = UIStoryboard.init(storyboard: .home).instantiateViewController()
        let interactor = SelectedInteractor(presenter: viewController, selected: component.selected)
        interactor.listener = listener
        return SelectedRouter(interactor: interactor, viewController: viewController)
    }
}
