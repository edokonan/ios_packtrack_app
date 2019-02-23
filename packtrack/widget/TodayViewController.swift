//
//  TodayViewController.swift
//  widget
//
//  Created by ksymac on 2017/12/25.
//  Copyright © 2017年 ZHUKUI. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    //home
    @IBAction func tapBtn1(_ sender: Any) {
        self.extensionContext?.open(URL.init(string: "mypacktrack://home")!, completionHandler: { (b) in
            print("ok")
        })
    }
    //不在票
    @IBAction func tapBtn2(_ sender: Any) {
        self.extensionContext?.open(URL.init(string: "mypacktrack://undeliverable.notice")!, completionHandler: { (b) in
            print("ok")
        })
    }
    //scheme为app的scheme
    @IBAction func tapBtn3(_ sender: Any) {
        self.extensionContext?.open(URL.init(string: "mypacktrack://add.item")!, completionHandler: { (b) in
            print("ok")
        })
    }
    //再配達
    @IBAction func tapBtn4(_ sender: Any) {
        self.extensionContext?.open(URL.init(string: "mypacktrack://redelivery")!, completionHandler: { (b) in
            print("ok")
        })
    }
    @IBAction func tapBtn5(_ sender: Any) {
        self.extensionContext?.open(URL.init(string: "mypacktrack://")!, completionHandler: { (b) in
            print("ok")
        })
    }
    
    
    
}
