//
//  HomeInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/13.
//

import RIBs
import RxSwift
import FirebaseAuth.FIRUser

protocol HomeRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func homeToMountains()
    func homeToRecordList()
    func mountainsToSelected(with mountain: Model.Mountain)
    func selectedToTrip(with mountain: Model.Mountain)
    
    func closeMountains()
    func closeSelected()
    func closeTrip()
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func composeTotalData(data: Model.TotalClimbing)
}

protocol HomeListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener {

    weak var router: HomeRouting?
    weak var listener: HomeListener?
    private let service: MainServiceProtocol
    private let user   : User

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: HomePresentable, service: MainServiceProtocol, user: User) {
        self.service = service
        self.user    = user
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func fetchTotalClimbing() {
        self.service.fetchTotal(uid: self.user.uid) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let total):
                self.presenter.composeTotalData(data: total)
                break
            case .failure(let error):
                break
            }
        }
    }
    
    func goHiking() {
        self.router?.homeToMountains()
    }
    
    func goRecordList() {
        self.router?.homeToRecordList()
    }
    
    func closeMountains() {
        self.router?.closeMountains()
    }
    
    func mountainsToSelected(with mountain: Model.Mountain) {
        self.router?.mountainsToSelected(with: mountain)
    }
    
    func didCloseSelected() {
        self.router?.closeSelected()
    }
    
    func makeTrip(mountain: Model.Mountain) {
        self.router?.selectedToTrip(with: mountain)
    }
    
    func closeTrip() {
        self.router?.closeTrip()
    }
}
