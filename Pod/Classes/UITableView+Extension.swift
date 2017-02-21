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
    static var panGesture: UInt8 = 3
}

extension UITableView: UIGestureRecognizerDelegate {
    
    private static var currentOffset: CGFloat = 0
    private static var translationX: CGFloat = 0
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &AssociationKey.panGesture && keyPath == "contentOffset" {
            updateTableViewCellFrames()
            return
        }
        
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
    
    private func updateTableViewCellFrames() {
        for cell in visibleCells {
            if let revealCell = cell as? RevealableTableViewCell {
                if let revealView = revealCell.revealView {
                    var rect = cell.contentView.frame
                    var x = UITableView.currentOffset
                    
                    if revealView.direction == .Left {
                        x = max(x, -revealView.bounds.width)
                        x = min(x, 0)
                    } else {
                        x = max(x, 0)
                        x = min(x, revealView.bounds.width)
                    }
                    
                    if revealView.style == .Slide {
                        rect.origin.x = x;
                        cell.contentView.frame = rect;
                    }
                    
                    revealView.transform = CGAffineTransformMakeTranslation(x, 0)
                }
            }
        }
    }
    
    func handleRevealPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Began:
            addObserver(self, forKeyPath: "contentOffset", options: .New, context: &AssociationKey.panGesture)
            break
        case .Changed:
            UITableView.translationX = gesture.translationInView(gesture.view).x
            UITableView.currentOffset += UITableView.translationX
            
            gesture.setTranslation(CGPointZero, inView: gesture.view)
            updateTableViewCellFrames()
            break
        default:
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                UITableView.currentOffset = 0
                self.updateTableViewCellFrames()
                }, completion: { (finished: Bool) -> Void in
                    UITableView.translationX = 0
            })
            
            removeObserver(self, forKeyPath: "contentOffset")
        }
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gesture = gestureRecognizer as? UIPanGestureRecognizer where gesture == revealPanGesture {
            let translation = gesture.translationInView(gesture.view);
            return (fabs(translation.x) > fabs(translation.y)) && (gesture == revealPanGesture)
        }
        
        return true
    }
    
    private var revealPanGesture: UIPanGestureRecognizer {
        return objc_getAssociatedObject(self, &AssociationKey.panGesture) as? UIPanGestureRecognizer ?? {
            let associatedProperty = UIPanGestureRecognizer(target: self, action: "handleRevealPan:")
            associatedProperty.delegate = self
            //      self.panGestureRecognizer.enabled = false
            objc_setAssociatedObject(self, &AssociationKey.panGesture, associatedProperty, .OBJC_ASSOCIATION_RETAIN)
            return associatedProperty
            }()
    }
    
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
            
            addGestureRecognizer(revealPanGesture)
            return view
        }
        
        if let viewClass = regs[identifier] as? NSObject.Type {
            guard let view = viewClass.init() as? RevealableView  else {
                print("The view instantiated from Class: '\(viewClass)' is not a subclass of RevealableView!")
                return nil
            }
            
            view.reuseIdentifier = identifier
            view.tableView = self
            
            addGestureRecognizer(revealPanGesture)
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
