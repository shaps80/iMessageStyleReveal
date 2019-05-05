//
//  RevealableView.swift
//  RevealableCell
//
//  Created by Shaps Mohsenin on 03/01/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

open class RevealableView: UIView {
    
//    @IBInspectable open var width: CGFloat = 0 {
//        didSet { prepareWidthConstraint() }
//    }
//
//    fileprivate var widthConstraint: NSLayoutConstraint?

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open func prepareForReuse() { }
    
//    fileprivate func prepareWidthConstraint() {
//        if width > 0 {
//            let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
//            NSLayoutConstraint.activate([constraint])
//            widthConstraint = constraint
//        } else {
//            if let constraint = widthConstraint {
//                NSLayoutConstraint.deactivate([constraint])
//            }
//        }
//
//        setNeedsUpdateConstraints()
//    }

}
