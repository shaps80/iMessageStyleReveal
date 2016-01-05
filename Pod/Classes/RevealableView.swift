//
//  RevealableView.swift
//  RevealableCell
//
//  Created by Shaps Mohsenin on 03/01/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

public enum RevealStyle {
  case Slide
  case Over
}

public enum RevealSwipeDirection {
  case Left
  case Right
}

public class RevealableView: UIControl {
  
  @IBInspectable public var width: CGFloat = 0 {
    didSet {
      prepareWidthConstraint()
    }
  }
  
  internal var tableView: UITableView?
  public internal(set) var reuseIdentifier: String!
  public internal(set) var style: RevealStyle = .Slide
  public internal(set) var direction: RevealSwipeDirection = .Left
  
  private var widthConstraint: NSLayoutConstraint?
  
  /**
   Ensure to call super.didMoveToSuperview in your subclasses!
   */
  public override func didMoveToSuperview() {
    if self.superview != nil {
      prepareWidthConstraint()
    }
    
    self.translatesAutoresizingMaskIntoConstraints = false
  }
  
  internal func prepareForReuse() {
    tableView?.prepareRevealableViewForReuse(self)
  }
  
  private func prepareWidthConstraint() {
    if width > 0 {
      let constraint = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: width)
      NSLayoutConstraint.activateConstraints([constraint])
      widthConstraint = constraint
    } else {
      if let constraint = widthConstraint {
        NSLayoutConstraint.deactivateConstraints([constraint])
      }
    }
    
    setNeedsUpdateConstraints()
  }
  
}
