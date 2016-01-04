//
//  RevealableTableViewcell.swift
//  RevealableCell
//
//  Created by Shaps Mohsenin on 03/01/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

public class RevealableTableViewCell: UITableViewCell {
  
  internal var revealView: RevealableView?
  internal var revealStyle: RevealStyle = .Slide
  internal var revealDirection: RevealSwipeDirection = .Left
  internal var revealWidth: CGFloat = 0
  
  public override var selected: Bool {
    didSet {
      revealView?.selected = selected
    }
  }
  
  public override var highlighted: Bool {
    didSet {
      revealView?.highlighted = highlighted
    }
  }
  
  /**
   Ensure you call super.prepareForReuse() when overriding this method in your subclasses!
   */
  public override func prepareForReuse() {
    super.prepareForReuse()
    
    if let view = revealView {
      view.prepareForReuse()
    }
  }
  
  public func setRevealableView(view: RevealableView, style: RevealStyle = .Slide, direction: RevealSwipeDirection = .Left) {
    if let view = revealView {
      view.removeFromSuperview()
    }
    
    revealView = view
    view.style = style
    view.direction = direction
    
    view.sizeToFit()
    addSubview(view)
    
    let topConstraint = NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
    let bottomConstraint = NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)
    
    let attribute: NSLayoutAttribute = direction == .Right ? .Left : .Right
    let horizontalConstraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .Equal, toItem: self, attribute: attribute, multiplier: 1, constant: 0)
    
    NSLayoutConstraint.activateConstraints([ topConstraint, bottomConstraint, horizontalConstraint ])
    
    if view.bounds.width == 0 {
      print("The revealableView has a width of 0. Check your AutoLayout settings or explicity set the width using the revealableView.width property")
    }
  }
  
}
