//
//  NoDataView.swift
//  packtrack
//
//  Created by ksymac on 2017/04/01.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit


class NoDataView:UIView{

    @IBOutlet weak var txtLabel: UILabel!
    class func instanceFromNib() -> NoDataView {
        
        
        if let x = Bundle.main.loadNibNamed( "NoDataView",
                                             owner: nil,
                                             options: nil) {
            let nibView = x[0] as! NoDataView
            return nibView
        }
        return NoDataView.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        txtLabel.center = self.center
    }
}
