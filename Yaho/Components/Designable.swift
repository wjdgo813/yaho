//
//  Designable.swift
//  Yaho
//
//  Created by gabriel.jeong on 2021/06/27.
//

import UIKit

@IBDesignable
public class RoundButton: UIButton {
    @IBInspectable public var cornerRadius : CGFloat = 0 {
        didSet{ layer.cornerRadius = self.cornerRadius }
    }
    
    @IBInspectable public var borderWidth : CGFloat = 0 {
        didSet{ layer.borderWidth = self.borderWidth }
    }
    
    @IBInspectable public var borderColor : UIColor = .clear {
        didSet{ layer.borderColor = self.borderColor.cgColor }
    }
}
