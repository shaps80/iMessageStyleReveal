//
//  TimestampView.swift
//  RevealableCell
//
//  Created by Shaps Mohsenin on 03/01/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import RevealableCell

class TimestampView: RevealableView {
    
    @IBOutlet var titleLabel: UILabel!
    
    var date: NSDate = NSDate() {
        didSet {
            titleLabel.text = dateFormatter.stringFromDate(self.date)
        }
    }
    
    private var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
}
