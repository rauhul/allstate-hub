//
//  NewSensorViewController.swift
//  Hub
//
//  Created by Rauhul Varma on 10/9/15.
//  Copyright © 2015 Rauhul Varma. All rights reserved.
//

import UIKit
import Parse

class NewRuleViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var ruleTitle: UITextField!
    @IBOutlet weak var ruleDescription: UITextView!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addPressed(sender: AnyObject) {
        if (ruleDescription.text != "" && ruleTitle.text != "" && !initial) {
            navigationController?.popViewControllerAnimated(true)
            let newRule = PFObject(className: "Rules")

            newRule.setValue(ruleTitle.text, forKey: "Title")
            newRule.setValue(ruleDescription.text, forKey: "Description")
            newRule.setValue(true, forKey: "is_enabled")
        
            do {
                try newRule.save()
            } catch {
                print("Error")
            }
            
        } else {
            let alert = UIAlertController(title: "Incomplete Rule", message: "Please include a title and description for your rule", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
            alert.addAction(okAction)
            presentViewController(alert, animated: true) { () -> Void in }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ruleTitle.delegate = self
        ruleDescription.delegate = self
        
        ruleDescription.layer.masksToBounds = true
        ruleDescription.layer.cornerRadius = 8

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    var initial = true
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if initial {
            initial = false
            textView.text = ""
        }
        return true
    }
}