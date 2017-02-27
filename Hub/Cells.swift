//
//  File.swift
//  Hub
//
//  Created by Rauhul Varma on 10/9/15.
//  Copyright © 2015 Rauhul Varma. All rights reserved.
//

import UIKit
import Parse
class SensorCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var sensorName: UILabel!
    @IBOutlet weak var sensorValue: UILabel!
    @IBOutlet weak var sensorStatus: UILabel!
    @IBOutlet weak var updateDate: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class RuleCell: UITableViewCell {
    
    var ruleId = ""
    @IBOutlet weak var ruleDescription: UITextView!
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var title: UILabel!
    
    @IBAction func switched(sender: AnyObject) {
        let query = PFQuery(className: "Rules")
        query.whereKey("objectId", equalTo: ruleId)
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            if object != nil {
                object!.setObject(self.enableSwitch.on, forKey: "is_enabled")
                do {
                    try object!.save()
                } catch {
                    print("Error")
                }
            }
        }
    }
}


class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var historyDescription: UITextView!
}
