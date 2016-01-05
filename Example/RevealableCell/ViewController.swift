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

enum Cell: String {
  case Left = "leftAlignedCell"
  case Right = "rightAlignedCell"
}

class ViewController: UITableViewController {
  
  var messages = [Message]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    tableView.registerNib(UINib(nibName: "TimestampView", bundle: nil), forRevealableViewReuseIdentifier: "timeStamp")
    tableView.registerNib(UINib(nibName: "TimestampView", bundle: nil), forRevealableViewReuseIdentifier: "name")
    
    tableView.rowHeight = UITableViewAutomaticDimension
    
    messages.append(Message(cell: .Left, date: NSDate(timeIntervalSinceNow: 60), text: "Do you know how to put an Ad on Craig's List?", name: "Francesco"))
    messages.append(Message(cell: .Right, date: NSDate(timeIntervalSinceNow: 120), text: "Yes, its easy. Why?", name: "Shaps"))
    messages.append(Message(cell: .Left, date: NSDate(timeIntervalSinceNow: 160), text: "We need a nurse to fuck my grandma at night", name: "Francesco"))
    messages.append(Message(cell: .Right, date: NSDate(timeIntervalSinceNow: 240), text: "Oh my. Well lord knows you can find that, and more, on craigslist! Haha", name: "Shaps"))
    messages.append(Message(cell: .Left, date: NSDate(timeIntervalSinceNow: 340), text: "lol no my grandma needs fuck at night", name: "Francesco"))
    messages.append(Message(cell: .Right, date: NSDate(timeIntervalSinceNow: 400), text: "Oh, don't we all ;)", name: "Shaps"))
    messages.append(Message(cell: .Left, date: NSDate(timeIntervalSinceNow: 550), text: "help! God damn it help! Auto correct sucks!", name: "Francesco"))
    messages.append(Message(cell: .Right, date: NSDate(timeIntervalSinceNow: 600), text: "HAHAHAHA!", name: "Shaps"))
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> RevealableTableViewCell {
    let message = messages[indexPath.item]
    let cell = tableView.dequeueReusableCellWithIdentifier(message.cell.rawValue, forIndexPath: indexPath) as! TableViewCell
    configureCell(cell, indexPath: indexPath, message: message)
    return cell
  }
  
  override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 49
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let message = messages[indexPath.item]
    
    if let cell = tableView.dequeueReusableCellWithIdentifier(message.cell.rawValue) as? TableViewCell {
      configureCell(cell, indexPath: indexPath, message: message)
      return cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height
    }
    
    return 50
  }
  
  func configureCell(cell: TableViewCell, indexPath: NSIndexPath, message: Message) {
    if let timeStampView = tableView.dequeueReusableRevealableViewWithIdentifier("timeStamp") as? TimestampView {
      timeStampView.date = message.date
      timeStampView.width = 55
      cell.setRevealableView(timeStampView, style: message.cell == .Left ? .Over : .Slide)
    }
    
    cell.messageLabel.text = message.text
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Today"
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
}

final class Message {
  
  let text: String
  let date: NSDate
  let cell: Cell
  let name: String
  
  init(cell: Cell, date: NSDate, text: String, name: String) {
    self.text = text
    self.cell = cell
    self.date = date
    self.name = name
  }
  
}

