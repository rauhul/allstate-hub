//
//  FirstViewController.swift
//  Hub
//
//  Created by Rauhul Varma on 10/9/15.
//  Copyright © 2015 Rauhul Varma. All rights reserved.
//

import UIKit
import Parse


struct Rule {
    var description: String
    var enabled:     Bool
    var title:       String
    var ruleId:      String
}

class RuleViewController: MasterViewController {
    
    var tableViewDataSource = [Rule]()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ObjectList.registerNib(UINib(nibName: "RuleCell", bundle: nil), forCellReuseIdentifier: "RuleCell")

        ObjectList.rowHeight = UITableViewAutomaticDimension
        ObjectList.estimatedRowHeight = 250.0
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        ObjectList.addSubview(refreshControl)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RuleCell", forIndexPath: indexPath) as! RuleCell
        cell.ruleDescription.selectable = true
        cell.ruleDescription.text = tableViewDataSource[indexPath.indexAtPosition(1)].description
        cell.ruleDescription.selectable = false
        cell.enableSwitch.setOn(tableViewDataSource[indexPath.indexAtPosition(1)].enabled, animated: false)
        cell.title.text = tableViewDataSource[indexPath.indexAtPosition(1)].title
        cell.ruleId = tableViewDataSource[indexPath.indexAtPosition(1)].ruleId

        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource.count
    }
    
    
    func refreshData() {
        let query = PFQuery(className: "Rules")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if objects?.count > 0 {
                self.tableViewDataSource = [Rule]()
                for object in objects! {
                    let rule = Rule(description: object.valueForKey("Description") as! String,
                        enabled: object.valueForKey("is_enabled") as! Bool,
                        title: object.valueForKey("Title") as! String,
                        ruleId: object.valueForKey("objectId") as! String
                    )
                    self.tableViewDataSource.append(rule)
                }
                self.ObjectList.reloadData()
            }
        }
        refreshControl.endRefreshing()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to remove this rule?", preferredStyle: UIAlertControllerStyle.Alert)
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                let query = PFQuery(className: "Rules")
                query.whereKey("objectId", equalTo: self.tableViewDataSource[indexPath.indexAtPosition(1)].ruleId)
                query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
                    do {
                        try object?.delete()
                    } catch {
                        print("Error")
                    }
                }
                
                self.tableViewDataSource.removeAtIndex(indexPath.indexAtPosition(1))
                self.ObjectList.reloadData()
            }
            let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
            alert.addAction(yesAction)
            alert.addAction(noAction)
            presentViewController(alert, animated: true) { () -> Void in }
        }
    }

    
}

