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

class ViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    tableView.registerNib(UINib(nibName: "TimestampView", bundle: nil), forRevealableViewReuseIdentifier: "timeStamp")
    tableView.registerNib(UINib(nibName: "TimestampView", bundle: nil), forRevealableViewReuseIdentifier: "timeStamp2")
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> RevealableTableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! RevealableTableViewCell
    cell.textLabel?.backgroundColor = UIColor.clearColor()
    cell.contentView.backgroundColor = UIColor.clearColor()
    
    if let timeStampView = tableView.dequeueReusableRevealableViewWithIdentifier("timeStamp") as? TimestampView {
      timeStampView.date = LoremIpsum.date()
//      timeStampView.width = 100
      timeStampView.backgroundColor = UIColor.redColor()
      cell.setRevealableView(timeStampView, style: .Slide, direction: .Right)
    }
    
    cell.textLabel?.text = "\(LoremIpsum.name()) -- \(indexPath.item))"

    return cell
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 40
  }
  
}

