//
//  MountainsViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/17.
//

import RIBs
import RxSwift
import UIKit
import RxCocoa

protocol MountainsPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
//    func getAroundMountains() -> [Mountain]?
    var aroundMountains: PublishRelay<Void> { get }
}

final class MountainsViewController: UIViewController, MountainsPresentable, MountainsViewControllable {

    weak var listener: MountainsPresentableListener?
    let aroundMountains = PublishRelay<[Mountain]?>()
    private let disposeBag = DisposeBag()
//    private var aroundMountains: [Mountain]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBind()
        self.setInput()
    }
    
    private func setupUI() {
        
    }
    
    private func setBind() {
        self.aroundMountains
            .debug("[MountainsViewController] aroundMountains")
            .subscribe(onNext: { [weak self] mountains in
                
            }).disposed(by: self.disposeBag)
    }
    
    private func setInput() {
        self.listener?.aroundMountains.accept(())
    }
}
