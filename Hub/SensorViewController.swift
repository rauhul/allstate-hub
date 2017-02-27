//
//  FirstViewController.swift
//  Hub
//
//  Created by Rauhul Varma on 10/9/15.
//  Copyright © 2015 Rauhul Varma. All rights reserved.
//

import UIKit
import Parse


struct Sensor {
    var name:   String
    var open:   Bool
    var status:  Int
    var naturalName: String
    var updateDate: String
    var id: String
}

class SensorViewController: MasterViewController {

    var tableViewDataSource = [Sensor]()
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        ObjectList.registerNib(UINib(nibName: "SensorCell", bundle: nil), forCellReuseIdentifier: "SensorCell")

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        ObjectList.addSubview(refreshControl)

        ObjectList.rowHeight = 80
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SensorCell", forIndexPath: indexPath) as! SensorCell
        cell.sensorName.text = tableViewDataSource[indexPath.indexAtPosition(1)].naturalName
        
        cell.sensorStatus.layer.masksToBounds = true
        cell.sensorStatus.layer.cornerRadius = 8
        cell.sensorStatus.layer.borderWidth = 1.5
        cell.updateDate.text = tableViewDataSource[indexPath.indexAtPosition(1)].updateDate
        
        switch tableViewDataSource[indexPath.indexAtPosition(1)].name {
        case "Water":
            cell.sensorValue.text = tableViewDataSource[indexPath.indexAtPosition(1)].open == true ? "Water Detected" : "Normal"
            cell.imageView?.image = UIImage(named: "waterSensor")
        case "Fire":
            cell.sensorValue.text = tableViewDataSource[indexPath.indexAtPosition(1)].open == true ? "Fire Detected" :"Normal"
            cell.imageView?.image = UIImage(named: "fireSensor")
        case "Smoke":
            cell.sensorValue.text = tableViewDataSource[indexPath.indexAtPosition(1)].open == true ? "Smoke Detected" : "Normal"
            cell.imageView?.image = UIImage(named: "smokeSensor")
        case "Garage":
            cell.sensorValue.text = tableViewDataSource[indexPath.indexAtPosition(1)].open == true ? "Open" : "Closed"
            cell.imageView?.image = UIImage(named: "garageSensor")
        case "Window":
            cell.sensorValue.text = tableViewDataSource[indexPath.indexAtPosition(1)].open == true ? "Open" : "Closed"
            cell.imageView?.image = UIImage(named: "windowSensor")
        default:
            cell.sensorValue.text = tableViewDataSource[indexPath.indexAtPosition(1)].open == true ? "Normal" : "Abnormal"
        }
        
        switch tableViewDataSource[indexPath.indexAtPosition(1)].status {
        case 1:
            cell.sensorStatus.text = "Connected"
            cell.sensorStatus.layer.borderColor = UIColor.greenColor().CGColor
        case 0:
            cell.sensorStatus.text = "Disconnected"
            cell.sensorValue.text  = ""
            cell.updateDate.text   = ""
            cell.sensorStatus.layer.borderColor = UIColor.redColor().CGColor
        default:
            cell.sensorStatus.text = "Low Battery"
            cell.sensorStatus.layer.borderColor = UIColor.yellowColor().CGColor
        }
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to remove this sensor?", preferredStyle: UIAlertControllerStyle.Alert)
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                let query = PFQuery(className: "Sensors")
                query.whereKey("objectId", equalTo: self.tableViewDataSource[indexPath.indexAtPosition(1)].id)
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

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource.count
    }

    func refreshData() {
        let query = PFQuery(className: "Sensors")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if objects?.count > 0 {
                self.tableViewDataSource = [Sensor]()
                let formatter = NSDateFormatter()
                formatter.dateFormat = "hh:mm a"

                for object in objects! {
                    let time = formatter.stringFromDate(object.valueForKey("updatedAt") as! NSDate)
                    let sensor = Sensor(name: object.valueForKey("name") as! String,
                        open: object.valueForKey("open") as! Bool,
                        status: object.valueForKey("status") as! Int,
                        naturalName: object.valueForKey("naturalLanguageName") as! String,
                        updateDate: time,
                        id: object.valueForKey("objectId") as! String
                    )
                    self.tableViewDataSource.append(sensor)
                }
                self.ObjectList.reloadData()
            }
        }
        refreshControl.endRefreshing()
    }
    
    
}

