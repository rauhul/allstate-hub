//
//  NewSensorViewController.swift
//  Hub
//
//  Created by Rauhul Varma on 10/9/15.
//  Copyright © 2015 Rauhul Varma. All rights reserved.
//

import UIKit
import Parse

struct GenericSensor {
    var vanityName: String
    var type: String
    var imageName: String
}

class NewSensorViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var pickerViewDataSource = [GenericSensor]()
    @IBOutlet weak var ObjectPicker: UIPickerView!
    @IBOutlet weak var sensorImage: UIImageView!
    
    @IBOutlet weak var sensorName: UITextField!
    @IBOutlet weak var sensorStatus: UILabel!
    
    @IBOutlet weak var sensorValue: UILabel!
    @IBOutlet weak var sensorSerial: UILabel!
    @IBOutlet weak var sensorType: UILabel!
    
    @IBOutlet weak var searchAddButton: UIButton!
    
    @IBAction func searchAddPressed(sender: AnyObject) {
        if (searchAddButton.titleLabel?.text == "Search") {
            if (pickerViewDataSource.count > 0) {
                searchAddButton.setTitle("Add", forState: .Normal)
                sensorStatus.text = "Connected"
                sensorStatus.layer.borderColor = UIColor.greenColor().CGColor
                
                let alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789"
                var s = ""
                for _ in 0..<15 {
                    s.append(Character(alphabet[Int(arc4random()%62)]))
                }
                sensorSerial.text = s
                sensorType.text = pickerViewDataSource[ObjectPicker.selectedRowInComponent(0)].type
                switch pickerViewDataSource[ObjectPicker.selectedRowInComponent(0)].type {
                case "Fire":
                    sensorValue.text = "Normal"
                case "Water":
                    sensorValue.text = "Normal"
                case "Garage":
                    sensorValue.text = "Closed"
                case "Window":
                    sensorValue.text = "Closed"
                case "Smoke":
                    sensorValue.text = "Normal"
                default:
                    print("WHOOPS")
                }
            }
        } else {
            
            navigationController?.popViewControllerAnimated(true)
            let newSensor = PFObject(className: "Sensors")
            let name = sensorName.text == "" ? sensorName.placeholder : sensorName.text
            
            newSensor.setValue(name, forKey: "naturalLanguageName")
            newSensor.setValue(pickerViewDataSource[ObjectPicker.selectedRowInComponent(0)].type, forKey: "name")
            newSensor.setValue(false, forKey: "open")
            newSensor.setValue(1, forKey: "status")

            do {
                try newSensor.save()
            } catch {
                print("Error")
            }
            
            //push to parse
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ObjectPicker.delegate = self
        ObjectPicker.dataSource = self
        sensorName.delegate = self
        
        sensorStatus.layer.masksToBounds = true
        sensorStatus.layer.cornerRadius = 8
        sensorStatus.layer.borderWidth = 1.5
        
        resetLabels()
        
        refreshData()
        
    }
    
    func refreshData() {
        let query = PFQuery(className: "SensorTypes")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if objects?.count > 0 {
                self.pickerViewDataSource = [GenericSensor]()
                
                for object in objects! {
                    let newSensor = GenericSensor(vanityName: object.valueForKey("vanityType") as! String,
                        type: object.valueForKey("Type") as! String,
                        imageName: object.valueForKey("imageName") as! String
                    )
                    self.pickerViewDataSource.append(newSensor)
                }
                self.ObjectPicker.reloadAllComponents()
                if (self.pickerViewDataSource.count > 2) {
                    let row: Int = self.pickerViewDataSource.count/2
                    self.ObjectPicker.selectRow(row, inComponent: 0, animated: false)
                    self.sensorName.placeholder = self.pickerViewDataSource[row].vanityName
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewDataSource[row].vanityName
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerViewDataSource.count > row) {
            sensorName.placeholder = pickerViewDataSource[row].vanityName
            sensorImage.image = UIImage(named: pickerViewDataSource[row].imageName)
        }
        resetLabels()
        
    }
    
    func resetLabels() {
        sensorValue.text = ""
        sensorName.text = ""
        sensorSerial.text = ""
        sensorType.text = ""
        sensorStatus.text = "Unknown"
        sensorStatus.layer.borderColor = UIColor.blueColor().CGColor
        searchAddButton.setTitle("Search", forState: .Normal)
        
    }
    
    
    
}