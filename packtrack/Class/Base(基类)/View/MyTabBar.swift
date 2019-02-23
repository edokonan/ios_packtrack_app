//
//  MyTabBar.swift
//  packtrack
//
//  Created by ksymac on 2017/10/21.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit

class MyTabBar: UITabBar {

    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var tmp = newValue
            if let superview = self.superview, tmp.maxY != superview.frame.height {
                tmp.origin.y = superview.frame.height - tmp.height
            }
            super.frame = tmp
        }
    }
//    override
    
    
    
}
