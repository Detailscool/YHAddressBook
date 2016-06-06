//
//  TodayViewController.swift
//  ContactWidget
//
//  Created by Detailscool on 16/6/5.
//  Copyright © 2016年 Detailscool. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDefaultsDidChange:", name: NSUserDefaultsDidChangeNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    private func userDefaultsDidChange(notification:NSNotification) {
        update()
    }
    
    private func update() {
        
        let sharedDefault = NSUserDefaults(suiteName: "group.cn.hehe.YHAddressBook")
        let arr = sharedDefault?.objectForKey("Dates") as? [String]
        
        if let _ = arr {
            
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            
            let margin :CGFloat = 20.0
            let count : CGFloat = 5.0
            let width = (UIScreen.mainScreen().bounds.width-(count+1)*margin)/count
            
            for (index,dateStr) in arr!.enumerate() {
                let button = UIButton()
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.blueColor().CGColor
                button.titleLabel?.numberOfLines = 0
                button.titleLabel?.font = UIFont.systemFontOfSize(14)
                button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                button.frame = CGRect(x: ((width + margin) * CGFloat(index%Int(count))) + margin, y: ((width + margin) * CGFloat(index/Int(count))) + margin, width: width, height: width)
                button.tag = index + 1000
                button.addTarget(self, action: "buttonClick:", forControlEvents: UIControlEvents.TouchUpInside)
                let contact = sharedDefault?.objectForKey(String(format: "YHContact_%@", dateStr)) as! String
                button.setTitle(contact, forState: UIControlState.Normal)
                view.addSubview(button)
                
                if index == arr!.count-1 {
                    preferredContentSize = CGSizeMake(UIScreen.mainScreen().bounds.height, CGRectGetMaxY(button.frame)+20)
                }
            }
        }
    }
    
    @objc private func buttonClick(button:UIButton) {
        let sharedDefault = NSUserDefaults(suiteName: "group.cn.hehe.YHAddressBook")
        let arr = sharedDefault?.objectForKey("Dates") as? [String]
        if let _ = arr {
            let index = button.tag - 1000
            let dateStr = arr![index] 
            let phone = sharedDefault?.objectForKey(String(format: "YHContactPhone_%@", dateStr)) as! String
            let url = NSURL(string: String(format: "tel:%@", phone))
            if let _ = url {
                self.extensionContext?.openURL(url!, completionHandler: nil)
            }
        }
    }
    
}
