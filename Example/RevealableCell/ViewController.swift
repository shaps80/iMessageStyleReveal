//
//  ViewController.swift
//  RevealableCell
//
//  Created by Shaps Mohsenin on 01/03/2016.
//  Copyright (c) 2016 Shaps Mohsenin. All rights reserved.
//

import UIKit
import LoremIpsum
import RevealableCell

enum Position: String {
    case left = "leftAlignedCell"
    case right = "rightAlignedCell"
}

class ViewController: UITableViewController {

    var messages = [Message]()
    
    func configure(cell: TableViewCell, at indexPath: IndexPath, with message: Message) {
        
        /*
         
         This demonstrates the usage of a RevealableCell
         ---
         1. Your cell must be a subclass of RevealableTableViewCell
         2. You must register a nib or a RevealableView subclass using:
            tableView.registerNib(nib, forRevealableViewReuseIdentifier: "identifier")
            tableView.registerClass(revealableViewClass, forRevealableViewReuseIdentifier: "identifier")
         3. In cellForRowAtIndexPath you can dequeue and configure an instance using:
            if let view = tableView.dequeueReusableRevealableViewWithIdentifier("identifier") as? MyRevealableView {
                view.titleLabel.text = ""
                cell.setRevealableView(view, style: .Slide, direction: .Left)
            }
         
         This new implementation, allows reusable revealableViews of the same type as well as allowing you to have
         different styles/directions for individual cells.
         
         Run this project, to see a demo similar to the iMessage app on your iOS device.
         
         */
        
        if let timeStampView = tableView.dequeueReusableRevealableView(withIdentifier: "timestamp") as? TimestampView {
            timeStampView.date = message.date as Date
            timeStampView.width = 55
            
            if message.position == .left {
                cell.setRevealableView(timeStampView, style: .over)
            } else {
                cell.setRevealableView(timeStampView, style: .slide)
            }
        }
        
        cell.messageLabel.text = message.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "TimestampView", bundle: nil), forRevealableViewReuseIdentifier: "timestamp")
        tableView.registerNib(UINib(nibName: "TimestampView", bundle: nil), forRevealableViewReuseIdentifier: "name")

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }

        for i in 0..<100 {
            let text = LoremIpsum.sentence()!
            let position: Position = i % 2 == 0 ? .left : .right
            let date = Date(timeIntervalSinceNow: TimeInterval(i) * 60)
            let message = Message(position: position, date: date, text: text)
            messages.append(message)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let controller = UIAlertController(title: "Welcome", message: "Swipe to the left to see it in action", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> RevealableTableViewCell {
        let message = messages[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: message.position.rawValue, for: indexPath as IndexPath) as! TableViewCell
        configure(cell: cell, at: indexPath, with: message)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
}

final class Message {
    
    let text: String
    let date: Date
    let position: Position
    
    init(position: Position, date: Date, text: String) {
        self.text = text
        self.position = position
        self.date = date
    }
    
}

