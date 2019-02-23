//
//  ScanCropView.swift
//  packtrack
//
//  Created by ksymac on 2017/10/22.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit

class ScanCropView: UIView {
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    class func instanceFromNib() -> ScanCropView {
        if let x =  Bundle.main.loadNibNamed( "ScanCropView", owner: nil, options: nil){
            let nibView = x[0] as! ScanCropView
            return nibView
        }
        return ScanCropView.init()
    }
    
    
}
