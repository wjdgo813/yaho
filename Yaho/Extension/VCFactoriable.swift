//
//  VCFactoriable.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/08/22.
//

import UIKit

public protocol VCFactoriable: class {
    static var storyboardIdentifier : String { get }
    static var vcIdentifier: String { get }
    associatedtype Dependency
    func bindData(value: Dependency)
}

extension VCFactoriable {
    public static func createInstance(_ initial: Self.Dependency) -> Self {
        let vcinitialized = UIStoryboard(name: self.storyboardIdentifier, bundle: Bundle.main).instantiateViewController(withIdentifier: self.vcIdentifier) as! Self
        vcinitialized.bindData(value: initial)
        return vcinitialized
    }
}
