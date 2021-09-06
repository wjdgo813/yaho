//
//  RecordListBuilder.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/09/04.
//

import RIBs

protocol RecordListDependency: Dependency {
    var uid    : String { get }
    var storeService  : StoreServiceProtocol { get }
}

final class RecordListComponent: Component<RecordListDependency> {

    fileprivate var uid: String {
        self.dependency.uid
    }
    
    fileprivate var stortService: StoreServiceProtocol {
        self.dependency.storeService
    }
}

// MARK: - Builder

protocol RecordListBuildable: Buildable {
    func build(withListener listener: RecordListListener) -> RecordListRouting
}

final class RecordListBuilder: Builder<RecordListDependency>, RecordListBuildable {

    override init(dependency: RecordListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RecordListListener) -> RecordListRouting {
        let component = RecordListComponent(dependency: dependency)
        let viewController: RecordListViewController = UIStoryboard.init(storyboard: .record).instantiateViewController()
        let interactor = RecordListInteractor(presenter: viewController,
                                              service: component.stortService,
                                              uid: component.uid)
        interactor.listener = listener
        
        return RecordListRouter(interactor: interactor, viewController: viewController)
    }
}
