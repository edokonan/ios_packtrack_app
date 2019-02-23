//
//  MyHeadViewViewController.swift
//  packtrack
//
//  Created by ksymac on 2017/12/02.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit
import Firebase
class MyCompanyHeadView: UIView {

    class func instance() -> MyCompanyHeadView {
        return UINib(nibName: "MyCompanyHeadView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! MyCompanyHeadView
    }
 
    
    @IBOutlet weak var IconBtn: UIButton!
    @IBOutlet weak var NameBtn: UIButton!
    @IBOutlet weak var MailBtn: UIButton!
    @IBOutlet weak var PointBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.CommonInit()
    }

    var tracktype:TrackComType?
    func setInitUI(tracktype:TrackComType?){
        IconBtn.setImage(nil, for:  UIControlState())
        NameBtn.setTitle(" ", for: UIControlState())
        MailBtn.setTitle(" ", for: UIControlState())
        PointBtn.isHidden = true
        self.tracktype = tracktype
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupUI()
    }
    private func setupUI(){
        self.backgroundColor = GlobalHeadColor
        
        if let type = self.tracktype{
            NameBtn.setTitle(comfunc.getCompanyName(type.rawValue), for: UIControlState())
            IconBtn.setImage(comfunc.getCompanyImg(type.rawValue), for: UIControlState())
        }
        
        NameBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        NameBtn.titleLabel?.textColor = UIColor.white
        NameBtn.titleLabel?.textAlignment = .left
        NameBtn.contentHorizontalAlignment = .left
        
        MailBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        MailBtn.titleLabel?.textColor = UIColor.white
        MailBtn.titleLabel?.textAlignment = .left
        MailBtn.contentHorizontalAlignment = .left
        
        PointBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        PointBtn.titleLabel?.textColor = UIColor.white
        PointBtn.titleLabel?.textAlignment = .left
        PointBtn.contentHorizontalAlignment = .left
    }
    
}
