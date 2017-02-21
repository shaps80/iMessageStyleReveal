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
  
  var date: Date = Date() {
    didSet {
      titleLabel.text = dateFormatter.string(from: self.date as Date)
    }
  }
  
  private var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
  }()

}
