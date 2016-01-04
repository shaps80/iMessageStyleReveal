//
//  UITableView+Extension.swift
//  RevealableCell
//
//  Created by Shaps Mohsenin on 03/01/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import ObjectiveC

struct AssociationKey {
  static var queues: UInt8 = 1
  static var registrations: UInt8 = 2
}

extension UITableView {
  
  private var registrations: NSMutableDictionary {
    return objc_getAssociatedObject(self, &AssociationKey.registrations) as? NSMutableDictionary ?? {
      let associatedProperty = NSMutableDictionary()
      objc_setAssociatedObject(self, &AssociationKey.registrations, associatedProperty, .OBJC_ASSOCIATION_RETAIN)
      return associatedProperty
    }()
  }
  
  private var reuseQueues: RevealableViewsReuseQueues {
    return objc_getAssociatedObject(self, &AssociationKey.queues) as? RevealableViewsReuseQueues ?? {
      let associatedProperty = RevealableViewsReuseQueues()
      objc_setAssociatedObject(self, &AssociationKey.queues, associatedProperty, .OBJC_ASSOCIATION_RETAIN)
      return associatedProperty
    }()
  }
  
  public func registerNib(nib: UINib, forRevealableViewReuseIdentifier identifier: String) {
    let regs = registrations
    
    guard regs[identifier] == nil else {
      print("A revealableView with the identifier '\(identifier)' already exists -- '\(regs[identifier])'")
      return
    }
    
    regs[identifier] = nib
  }
  
  public func registerClass(revealableViewClass viewClass: AnyClass, forRevealableViewReuseIdentifier identifier: String) {
    let regs = registrations
    
    guard regs[identifier] == nil else {
      print("A revealableView with the identifier '\(identifier)' already exists -- '\(regs[identifier])'")
      return
    }
    
    guard viewClass is RevealableView.Type else {
      print("The viewClass '\(viewClass)' is not a subclass of RevealableView!")
      return
    }
    
    regs[identifier] = viewClass
  }

  public func dequeueReusableRevealableViewWithIdentifier(identifier: String) -> RevealableView? {
    let queue = reuseQueues.queueForIdentifier(identifier)
    
    if let view = queue.dequeueView() {
      return view
    }
    
    let regs = registrations
    
    if let nib = regs[identifier] as? UINib {
      guard let view = nib.instantiateWithOwner(nil, options: nil).first as? RevealableView else {
        print("The view returned from NIB: '\(nib)' is not a subclass of RevealableView!")
        return nil
      }
      
      view.reuseIdentifier = identifier
      view.tableView = self
      return view
    }
    
    if let viewClass = regs[identifier] as? NSObject.Type {
      guard let view = viewClass.init() as? RevealableView  else {
        print("The view instantiated from Class: '\(viewClass)' is not a subclass of RevealableView!")
        return nil
      }
      
      
      view.tableView = self
      return view
    }
    
    return nil
  }
  
  internal func prepareRevealableViewForReuse(view: RevealableView) {
    view.removeFromSuperview()
    let queue = reuseQueues.queueForIdentifier(view.reuseIdentifier)
    queue.enqueue(view)
  }
  
}

private final class RevealableViewsReuseQueues: NSObject {
  
  private var queues: [String: RevealableViewsReuseQueue]
  
  private func queueForIdentifier(identifier: String) -> RevealableViewsReuseQueue {
    var queue = queues[identifier]
    
    if queue == nil {
      queue = RevealableViewsReuseQueue(identifier: identifier)
      queues[identifier] = queue
    }
    
    return queue!
  }
  
  override init() {
    queues = [String: RevealableViewsReuseQueue]()
  }
  
}

private final class RevealableViewsReuseQueue: NSObject {
  
  private var identifier: String
  private var views = [RevealableView]()
  
  private init(identifier: String) {
    self.identifier = identifier
  }
  
  private func enqueue(view: RevealableView) {
    views.append(view)
  }
  
  private func dequeueView() -> RevealableView? {
    guard views.count > 0 else {
      return nil
    }
    
    let view = views.first
    views.removeFirst()
    
    return view
  }
  
}
