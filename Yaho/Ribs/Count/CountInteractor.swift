//
//  CountInteractor.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/05.
//

import RIBs
import RxSwift
import RxCocoa

protocol CountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CountPresentable: Presentable {
    var listener: CountPresentableListener? { get set }
    func setMountainName(_ name: String)
    func setMountainVisitCount(_ count: Int)
}

protocol CountListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func startTrip()
}

final class CountInteractor: PresentableInteractor<CountPresentable>, CountInteractable, CountPresentableListener {
    
    private let selectedStream: MountainStream
    private let mutableCountStream: MutableVisitCountStream
    private let service       : ReadyServiceProtocol
    private let uid           : String
    private let mountain    = BehaviorRelay<Model.Mountain?>(value: nil)
    private let viewDidLoad = PublishRelay<Void>()
    
    weak var router: CountRouting?
    weak var listener: CountListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: CountPresentable,
         uid: String,
         service: ReadyServiceProtocol,
         selectedStream: MountainStream,
         mutableCountStream: MutableVisitCountStream) {
        self.service = service
        self.selectedStream = selectedStream
        self.mutableCountStream = mutableCountStream
        self.uid = uid
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.selectedStream.mountain
            .unwrap()
            .bind(to: self.mountain)
            .disposeOnDeactivate(interactor: self)
        
        self.viewDidLoad
            .withLatestFrom(self.mountain)
            .unwrap()
            .subscribe(onNext: { [weak self] mountain in
                guard let self = self else { return }
                self.presenter.setMountainName(mountain.name)
                self.service.fetchVisit(uid: self.uid,
                                        mountainID: String(mountain.id),
                                        completion: { count in
                                            self.presenter.setMountainVisitCount(count)
                                            self.mutableCountStream.updateCount(with: count)
                })
            }).disposeOnDeactivate(interactor: self)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didLoad() {
        self.viewDidLoad.accept(())
    }
    
    func startTrip() {
        self.listener?.startTrip()
    }
}
