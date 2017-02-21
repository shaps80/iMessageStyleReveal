//
//  TableViewCell.swift
//  RevealableCell
//
//  Created by Shaps Mohsenin on 04/01/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import RevealableCell

@IBDesignable final class RoundedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cornerRadius = 5
    }
}

final class TableViewCell: RevealableTableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    
}
