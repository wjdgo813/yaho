//
//  HomeViewController.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/13.
//

import RIBs
import RxSwift
import RxCocoa

import UIKit
import Lottie

protocol HomePresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func fetchTotalClimbing()
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var totalCountLabel: UILabel!
    @IBOutlet private weak var totalHeightLabel: UILabel!
    @IBOutlet private weak var animationView: UIView!
    private var currentIndex: CGFloat = 0
    private let cellData: [HomeCellType] = [HomeCellType.goHiking(title: "오늘의 등산"),
                                            HomeCellType.record(title: "나의 등산 기록"),
                                            HomeCellType.removeAd(title: "거슬리는 광고", isRemove: false)]
    
    private let animation: AnimationView = {
        let animation = AnimationView(animation: Animation.named("data"))
        animation.loopMode = .autoReverse
        animation.play()
        return animation
    }()
    
    weak var listener: HomePresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.setupUI()
        self.setCollectionView()
    }
    
    private func setupUI() {
        self.listener?.fetchTotalClimbing()
        self.animationView.addSubview(animation)
        self.animation.frame = self.animationView.bounds
    }
    
    private func setCollectionView() {
        self.collectionView.decelerationRate = .fast
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: HomeCell.className, bundle: nil),
                                     forCellWithReuseIdentifier: HomeCell.className)
        
    }
    
    private func setBind() {
        
    }
    
    private func bindCell(cell: HomeCell, type: HomeCellType) {
        switch type {
        case .goHiking(_):
            cell.rx.tapHiking
                .subscribe(onNext: {
                
            }).disposed(by: cell.reusableBag)
        case .record(_):
            cell.rx.tapOption
                .subscribe(onNext: {
                
            }).disposed(by: cell.reusableBag)
            
        case .removeAd(_ ,_):
            cell.rx.tapOption
                .subscribe(onNext: {
                
            }).disposed(by: cell.reusableBag)
        }
    }
    
    public func composeTotalData(data: TotalClimbing) {
        self.totalCountLabel.text = "\(data.allTime)회"
        self.totalHeightLabel.text = "\(data.allHeight)km"
    }
}

extension HomeViewController {
    struct Layout {
        static let cellSize: CGSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 90)
        static let sectionInset: CGFloat = 20
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = self.cellData[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.className, for: indexPath) as! HomeCell
        cell.compose(type: type)
        self.bindCell(cell: cell, type: type)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return HomeViewController.Layout.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let cv = scrollView as? UICollectionView else { return }
        
        let layout = cv.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = HomeViewController.Layout.cellSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let idx = round((offset.x + cv.contentInset.left) / cellWidth)
        
        if idx > self.currentIndex {
            self.currentIndex += 1
        } else if idx < self.currentIndex {
            if self.currentIndex != 0 {
                self.currentIndex -= 1
            }
        }
        
        offset = CGPoint(x: (self.currentIndex * cellWidth) - cv.contentInset.left, y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = offset
    }
}
