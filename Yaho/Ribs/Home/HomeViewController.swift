//
//  HomeViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/13.
//

import RIBs
import RxSwift
import RxCocoa
import RxDataSources

import UIKit
import Lottie

protocol HomePresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var totalCountLabel: UILabel!
    @IBOutlet private weak var totalHeightLabel: UILabel!
    @IBOutlet private weak var animationView: UIView!
    private let dataSource = RxCollectionViewSectionedReloadDataSource(configureCell: <#T##CollectionViewSectionedDataSource<_>.ConfigureCell##CollectionViewSectionedDataSource<_>.ConfigureCell##(CollectionViewSectionedDataSource<_>, UICollectionView, IndexPath, CollectionViewSectionedDataSource<_>.I) -> UICollectionViewCell#>)
    private let animation: AnimationView = {
        let animation = AnimationView(animation: Animation.named("data"))
        animation.loopMode = .autoReverse
        animation.play()
        return animation
    }()
    
    weak var listener: HomePresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setCollectionView()
    }
    
    private func setupUI() {
        self.animationView.addSubview(animation)
        self.animation.frame = self.animationView.frame
    }
    
    private func setCollectionView() {
        
    }
}


extension HomeViewController {
    typealias DataSource = CollectionViewSectionedDataSource
    typealias AnimatedDataSource = RxCollectionViewSectionedAnimatedDataSource
    
    private func collectionViewDataSourceUI() ->  {
        
    }
}
