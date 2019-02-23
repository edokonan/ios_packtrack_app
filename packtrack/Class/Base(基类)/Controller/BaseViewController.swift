//
//  BaseViewController.swift
//  packtrack
//
//  Created by ksymac on 2017/03/28.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import Foundation
import UIKit


public let GlobalBackgroundColor = UIColor.colorWithCustom(239, g: 239, b: 239)
public let GlobalHeadColor = UIColor.colorWithCustom(80, g: 180, b: 220)

class BaseViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = GlobalHeadColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().barStyle = UIBarStyle.default
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        view.backgroundColor = GlobalBackgroundColor
    }
}
