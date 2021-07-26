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
    func didNavigateBack()
    func didSelectMountain(with mountain: Model.Mountain)
}

final class MountainsViewController: UIViewController, MountainsPresentable, MountainsViewControllable {
    
    @IBOutlet private weak var mountainContainer1: UIStackView!
    @IBOutlet private weak var mountainContainer2: UIStackView!
    weak var listener: MountainsPresentableListener?
    let aroundMountains = PublishRelay<[Model.Mountain]?>()
    private let disposeBag = DisposeBag()
    
    deinit {
        debugPrint("\(#file)_\(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBind()
        self.setInput()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent {
            self.listener?.didNavigateBack()
        }
    }
    
    func replaceModal(viewController: ViewControllable?) {
        if let vc = viewController {
            self.navigationController?.pushViewController(vc.uiviewController, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func dismiss(viewController: ViewControllable) {
        viewController.uiviewController.navigationController?.popViewController(animated: true)
    }
}

extension MountainsViewController {
    private func setupUI() {
        
    }
    
    private func setBind() {
        self.setInput()
        
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
    
    private func drawMountains(_ mountains: [Model.Mountain]) {
        var mountainsView = [MountainView]()
        mountains.enumerated().forEach { (index,mountain) in
            let view = MountainView.getSubView(value: MountainView.self)!
            view.compose(model: mountain)
            
            if index < 2 {
                mountainContainer1.addArrangedSubview(view)
            } else {
                mountainContainer2.addArrangedSubview(view)
            }
            
            mountainsView.append(view)
        }
        
        self.bindMountainView(with: mountainsView)
    }
    
    private func bindMountainView(with views: [MountainView]) {
        let taps = views.map { $0.rx.tapGo.asObservable() }
        Observable<Model.Mountain>.merge(taps)
            .subscribe(onNext: { [weak self] mountain in
                self?.listener?.didSelectMountain(with: mountain)
            }).disposed(by: self.disposeBag)
    }
}
