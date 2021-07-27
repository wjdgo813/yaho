//
//  MountainsBuilder.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/17.
//

import RIBs

protocol MountainsDependency: Dependency {
    var uid    : String { get }
    var mountains: [Model.Mountain] { get }
}

final class MountainsComponent: Component<MountainsDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    var uid: String {
        self.dependency.uid
    }
    
    override init(dependency: MountainsDependency) {
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol MountainsBuildable: Buildable {
    func build(withListener listener: MountainsListener) -> MountainsRouting
}

final class MountainsBuilder: Builder<MountainsDependency>, MountainsBuildable {

    override init(dependency: MountainsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MountainsListener) -> MountainsRouting {
        let component = MountainsComponent(dependency: dependency)
        let viewController: MountainsViewController = UIStoryboard.init(storyboard: .home).instantiateViewController()
        let interactor = MountainsInteractor(presenter: viewController, mountains: self.dependency.mountains)
        interactor.listener = listener
        
        let selectedBuilder = SelectedBuilder(dependency: component)
        return MountainsRouter(interactor: interactor, viewController: viewController, selected: selectedBuilder)
    }
}
