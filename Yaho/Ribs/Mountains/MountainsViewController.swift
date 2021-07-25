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
    
    @IBOutlet private weak var mountainContainer1: UIStackView!
    @IBOutlet private weak var mountainContainer2: UIStackView!
    weak var listener: MountainsPresentableListener?
    let aroundMountains = PublishRelay<[Model.Mountain]?>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBind()
        self.setInput()
    }
    
    private func setupUI() {
        
    }
    
    private func setBind() {
        self.listener?.aroundMountains.accept(())
        
        self.aroundMountains
            .debug("[MountainsViewController] aroundMountains")
            .unwrap()
            .subscribe(onNext: { [weak self] mountains in
                self?.drawMountains(mountains)
            }).disposed(by: self.disposeBag)
    }
    
    private func setInput() {
        self.listener?.aroundMountains.accept(())
    }
}

extension MountainsViewController {
    private func drawMountains(_ mountains: [Model.Mountain]) {
        mountains.enumerated().forEach { (index,mountain) in
            let view = MountainView.getSubView(value: MountainView.self)!
            view.compose(name: mountain.name, height: mountain.height, level: mountain.level)
            
            if index < 2 {
                mountainContainer1.addArrangedSubview(view)
            } else {
                mountainContainer2.addArrangedSubview(view)
            }
        }
    }
}
