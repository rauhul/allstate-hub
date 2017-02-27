//
//  MasterViewController.swift
//  Hub
//
//  Created by Rauhul Varma on 10/9/15.
//  Copyright © 2015 Rauhul Varma. All rights reserved.
//

import UIKit

let toHistorySeque = "toHistorySeque"
let toSensorsSeque = "toSensorsSeque"
let toRulesSeque = "toRulesSeque"


class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ObjectList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ObjectList.delegate = self
        ObjectList.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
}