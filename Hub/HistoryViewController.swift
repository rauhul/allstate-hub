//
//  FirstViewController.swift
//  Hub
//
//  Created by Rauhul Varma on 10/9/15.
//  Copyright © 2015 Rauhul Varma. All rights reserved.
//

import UIKit
import Parse


struct History {
    var description: String
    var date:  String
    var id: String
}

class HistoryViewController: MasterViewController {
    
    var tableViewDataSource = [History]()
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        ObjectList.registerNib(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        
        ObjectList.rowHeight = UITableViewAutomaticDimension
        ObjectList.estimatedRowHeight = 250.0
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        ObjectList.addSubview(refreshControl)

        refreshData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell", forIndexPath: indexPath) as! HistoryCell
        cell.historyDescription.selectable = true
        cell.historyDescription.text = tableViewDataSource[indexPath.indexAtPosition(1)].description
        cell.historyDescription.selectable = false
        cell.date.text = tableViewDataSource[indexPath.indexAtPosition(1)].date

        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource.count
    }
    
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let query = PFQuery(className: "History")
            query.whereKey("objectId", equalTo: tableViewDataSource[indexPath.indexAtPosition(1)].id)
            query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
                do {
                    try object?.delete()
                } catch {
                    print("Error")
                }
            }
            tableViewDataSource.removeAtIndex(indexPath.indexAtPosition(1))
            ObjectList.reloadData()
        }
    }
    
    
    func refreshData() {
        let query = PFQuery(className: "History")
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if objects?.count > 0 {
                self.tableViewDataSource = [History]()
                let formatter = NSDateFormatter()
                formatter.dateFormat = "E, MMM d hh:mma"
                for object in objects! {
                    let time = formatter.stringFromDate(object.valueForKey("createdAt") as! NSDate)
                    let history = History(description: object.valueForKey("Text") as! String,
                        date: time,
                        id: object.valueForKey("objectId") as! String
                    )
                    self.tableViewDataSource.append(history)
                }
                self.ObjectList.reloadData()
            }
        }
        refreshControl.endRefreshing()
    }
}

