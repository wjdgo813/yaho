//
//  Bannerable.swift
//  Yaho
//
//  Created by USER on 2023/03/09.
//

import UIKit
import GoogleMobileAds

let bannerID = "ca-app-pub-3769988488950055/3209093715"
protocol Bannerable where Self: UIViewController {
    var bannerView: GADBannerView! { get set }
    func initBanner(root: UIViewController)
}

extension Bannerable {
    func initBanner(root: UIViewController) {
        bannerView.adUnitID = bannerID
        bannerView.rootViewController = root
        bannerView.load(GADRequest())
    }
}
