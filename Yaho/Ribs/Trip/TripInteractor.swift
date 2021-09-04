//
//  TripInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/07.
//

import RIBs
import RxSwift

protocol TripRouting: Routing {
    func cleanupViews()
    func TripToCount()
    func countToHiking()
    func hikingToFinish()
    func closeRecord()
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TripListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func closeTrip()
}

final class TripInteractor: Interactor, TripInteractable {

    weak var router: TripRouting?
    weak var listener: TripListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init() {}

    override func didBecomeActive() {
        super.didBecomeActive()
        self.router?.TripToCount()
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    func startTrip() {
        self.router?.countToHiking()
    }
    
    func finishTrip() {
        self.router?.hikingToFinish()
    }
    
    func recordDidClose() {
        self.router?.closeRecord()
        self.listener?.closeTrip()
    }
}
