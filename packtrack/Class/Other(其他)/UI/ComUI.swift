//
//  ComUI.swift
//  packtrack
//
//  Created by ksymac on 2017/03/12.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//
import UIKit
import SwiftyJSON

class ComUI {
    class func getMenuButton() -> UIButton{
        // www.icons8.com
        let infoImage = UIImage(named: "menu-vertical-50")
        let button:UIButton = UIButton(frame: CGRect(x: 0,y: 0,width: 24, height: 24))
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(infoImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0)
        button.frame = CGRect(x: 0,y: 0,width: 24, height: 24)
        return button
    }
    class func getLeftMenuButton() -> UIButton{
        // www.icons8.com
        let infoImage = UIImage(named: "MenuBtn_48.png")
        let button:UIButton = UIButton(frame: CGRect(x: 0,y: 0,width: 24, height: 24))
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(infoImage, for: .normal)
//        button.contentVerticalAlignment = .fill
//        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0)
        button.frame = CGRect(x: 0,y: 0,width: 24, height: 24)
        return button
    }
    class func getMenuButton(_ title:String) -> UIButton{
        let button:UIButton = UIButton()
        button.setTitle(title, for: UIControlState())
        button.sizeToFit()
        return button
    }
    
    class func SwitchView(_ leftTitle:String ,rightTitle:String ) -> DGRunkeeperSwitch{
        let runkeeperSwitch = DGRunkeeperSwitch(leftTitle: leftTitle, rightTitle: rightTitle)
        //runkeeperSwitch.backgroundColor = UIColor(red: 229.0/255.0, green: 163.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        runkeeperSwitch.selectedBackgroundColor = .white
        runkeeperSwitch.titleColor = .white
        runkeeperSwitch.selectedTitleColor = UIColor.gray
        //UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        //UIColor(red: 255.0/255.0, green: 196.0/255.0, blue: 92.0/255.0, alpha: 1.0)
        runkeeperSwitch.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        runkeeperSwitch.frame = CGRect(x: 30.0, y: 40.0, width: 200.0, height: 30.0)
        return runkeeperSwitch
    }
}
