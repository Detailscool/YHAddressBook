//
//  ViewController.swift
//  YHAddressBook
//
//  Created by Detailscool on 16/6/5.
//  Copyright © 2016年 Detailscool. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var phoneTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var sureButton: UIButton!

    @IBAction func sure() {
        
//        sureButton.enabled = false
        
        let sharedDefault = NSUserDefaults(suiteName: "group.cn.hehe.YHAddressBook")
        
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = formatter.stringFromDate(date)
        
        var arr = sharedDefault?.objectForKey("Dates") as? [String]
        if let _ = arr {
           arr!.append(dateStr)
        }else {
            arr = [String]()
            arr!.append(dateStr)
        }
        
        sharedDefault?.setObject(nameTextfield.text, forKey: String(format: "YHContact_%@", dateStr))
        sharedDefault?.setObject(phoneTextfield.text, forKey: String(format: "YHContactPhone_%@", dateStr))
        sharedDefault?.setObject(arr, forKey: "Dates")
        sharedDefault?.synchronize()
        
        navigationController?.popViewControllerAnimated(true)
        
    }

}

