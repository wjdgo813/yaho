//
//  Object+.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/07/01.
//

import Foundation

extension NSObject {    
    public static var className: String {
        return String(describing: self)
    }
    
    public var className: String {
        return String(describing: type(of: self).className)
    }
}
