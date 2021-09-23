//
//  CountViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/05.
//

import RIBs
import RxSwift
import UIKit
import GoogleMobileAds

protocol CountPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didLoad()
    func startTrip()
}

final class CountViewController: UIViewController, CountPresentable, CountViewControllable, Bannerable {

    weak var listener: CountPresentableListener?
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet private weak var mountainLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private var countImages: [UIImageView]!
    private let disposeBag = DisposeBag()
    
    deinit {
        debugPrint("\(#file)_\(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listener?.didLoad()
        self.initBanner(root: self)
        self.startCount()
    }
    
    func setMountainName(_ name: String) {
        self.mountainLabel.text = name
    }
    
    func setMountainVisitCount(_ count: Int) {
        self.countLabel.text = "\(count)회"
    }
    
    private func startCount() {
        Observable<Int>
            .interval(1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] time in
                guard let self = self else { return }
                switch time{
                case 0:
                    self.show1Second()
                case 1:
                    self.show2Second()
                case 2:
                    self.show3Second()
                case 3:
                    self.startTrip()
                default:
                    break
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func startTrip() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.listener?.startTrip()
        }
    }
    
    private func show1Second() {
        let first = self.countImages.first { $0.tag == 0 }
        first?.transform = CGAffineTransform.init(scaleX: 0,y: 0)
            .concatenating(CGAffineTransform.init(rotationAngle: .pi/2))
        UIView.animate(withDuration: 0.3) {
            first?.alpha = 1.0
            first?.transform = .identity
        }
    }
    
    private func show2Second() {
        let first = self.countImages.first { $0.tag == 0 }
        let second = self.countImages.first { $0.tag == 1 }
        second?.transform = CGAffineTransform.init(scaleX: 0,y: 0)
            .concatenating(CGAffineTransform.init(rotationAngle: .pi/2))
        UIView.animate(withDuration: 0.3) {
            first?.alpha = 0.0
            second?.alpha = 1.0
            second?.transform = .identity
        }
    }
    
    private func show3Second() {
        let second = self.countImages.first { $0.tag == 1 }
        let third = self.countImages.first { $0.tag == 2 }
        third?.transform = CGAffineTransform.init(scaleX: 0,y: 0)
            .concatenating(CGAffineTransform.init(rotationAngle: .pi/2))
        UIView.animate(withDuration: 0.3) {
            second?.alpha = 0.0
            third?.alpha = 1.0
            third?.transform = .identity
        }
    }
}
