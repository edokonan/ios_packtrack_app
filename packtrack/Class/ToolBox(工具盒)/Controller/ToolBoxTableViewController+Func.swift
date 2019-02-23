//
//  MoreTableViewController.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/13.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import LBXScan

extension ToolBoxTableViewController:MYScanDelegate{
    // MARK: - 不在票スキャン
    func scanUndeliverableItemNotice(){
        if let vc:MyTabBarController = self.tabBarController  as! MyTabBarController{
            vc.scanUndeliverableItemNotice(in_style: StyleDIY.zhiFuBaoStyle())
        }
    }

//
}

