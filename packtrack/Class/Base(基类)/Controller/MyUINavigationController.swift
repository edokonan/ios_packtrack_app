//
//  MyUINavigationController.swift
//  packtrack
//
//  Created by ksymac on 2017/12/28.
//  Copyright © 2017年 ZHUKUI. All rights reserved.
//

import UIKit


//设置弹出对话框
class MyUINavigationController: UINavigationController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = GlobalHeadColor
        self.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().barStyle = UIBarStyle.default
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        view.backgroundColor = GlobalBackgroundColor
    }
}
