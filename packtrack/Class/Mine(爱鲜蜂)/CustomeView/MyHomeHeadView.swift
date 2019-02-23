//
//  MyHeadViewViewController.swift
//  packtrack
//
//  Created by ksymac on 2017/12/02.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit
import Firebase
class MyHomeHeadView: CustomView {

    class func instance() -> MyHomeHeadView {
        return UINib(nibName: "MyHomeHeadView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! MyHomeHeadView
    }
 
    
//    //    var iconImageView: UIImageView!
//    var iconImageView: UIButton = UIButton(type: .custom)
//    var nameBtn: UIButton = UIButton()
//    var Pointlabel: UIButton = UIButton()
    var loginBtnClick:(() -> Void)?
    var cmBtnClick:(() -> Void)?
    
    @IBOutlet weak var IconBtn: UIButton!
    @IBOutlet weak var NameBtn: UIButton!
    @IBOutlet weak var MailBtn: UIButton!
    @IBOutlet weak var PointBtn: UIButton!
    @IBOutlet weak var CMBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.CommonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.CommonInit()
    }
//    internal func xibImgSet() {
//        let view = NSBundle.mainBundle().loadNibNamed("MyHomeHeadView", owner: self, options: nil).first as! UIView
//        view.frame.size = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.width/320*50)
//        self.frame.size = view.frame.size
//        self.addSubview(view)
//    }
    func setLoginedView(){
        if let user = packtrack_user {
            let nameText = String(format: "%@ ", user.name!)
            NameBtn.setTitle(nameText, for: UIControlState())
            let tempstr = String(format: "%@", user.email!)
            MailBtn.setTitle(tempstr, for: UIControlState())
            if let point = user.packtrack_point{
                let pointStr = String(format: "所持:%d ポイント", user.packtrack_point!)
                PointBtn.setTitle(pointStr, for: UIControlState())
            }else{
                PointBtn.setTitle("所持:0 ポイント", for: UIControlState())
            }
            IconBtn.setImage(UIImage(named: "v2_my_avatar"), for: UIControlState())
            loginBtnClick = nil
            
            #if FREE
                PointBtn.isHidden=false
                CMBtn.isHidden=false
            #else
                PointBtn.isHidden=true
                CMBtn.isHidden=true
            #endif
        }
    }
    func setLogoutView(btnClick:(() -> Void)?){
        NameBtn.setTitle("未登録", for: UIControlState())
        MailBtn.setTitle("クリックしてログインする", for: UIControlState())
        PointBtn.isHidden = true
        CMBtn.isHidden = true
        
        IconBtn.setImage(UIImage(named: "v2_my_avatar"), for: UIControlState())
        loginBtnClick = btnClick
    }
    func setInitUI(){
        if let user = Auth.auth().currentUser {
            NameBtn.setTitle("ユーザ情報取得中。。。", for: UIControlState())
            MailBtn.setTitle(user.email, for: UIControlState())
        }else{
            NameBtn.setTitle("未登録", for: UIControlState())
            MailBtn.setTitle("クリックしてログインする", for: UIControlState())
        }
        PointBtn.isHidden = true
        CMBtn.isHidden = true
        IconBtn.setImage(UIImage(named: "v2_my_avatar"), for: UIControlState())
        loginBtnClick = nil
    }
    
    func setUpButtonClick() {
        loginBtnClick?()
    }
    func CMButtonClick() {
        cmBtnClick?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        IconBtn.frame = CGRect(x: 20, y: 10, width: 100, height: 100)
//        NameBtn.frame = CGRect(x: iconImageView.frame.origin.x + iconImageView.frame.width - 5 ,
//                               y: 35, width: 200, height: 30)
//        MailBtn.frame = CGRect(x: iconImageView.frame.origin.x + iconImageView.frame.width - 5 ,
//                                  y: 60, width: 200, height: 30)
        setupUI()
    }
    private func setupUI(){
        self.backgroundColor = GlobalHeadColor
        
        IconBtn.setImage(UIImage(named: "v2_my_avatar"), for: UIControlState())
//        NameBtn.setTitle("未登録", for: UIControlState())
        //        phoneNum.titleLabel?.text = "Register/Login"
        NameBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        NameBtn.titleLabel?.textColor = UIColor.white
        NameBtn.titleLabel?.textAlignment = .left
        NameBtn.contentHorizontalAlignment = .left
        //        NameBtn.setImage(UIImage(named: "v2_my_settings_icon"), for: UIControlState())
        
//        MailBtn.setTitle("クリックしてログインする", for: UIControlState())
        MailBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        MailBtn.titleLabel?.textColor = UIColor.white
        MailBtn.titleLabel?.textAlignment = .left
        MailBtn.contentHorizontalAlignment = .left
        
        PointBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        PointBtn.titleLabel?.textColor = UIColor.white
        PointBtn.titleLabel?.textAlignment = .left
        PointBtn.contentHorizontalAlignment = .left
        
        CMBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        CMBtn.titleLabel?.textColor = UIColor.white
//        CMBtn.titleLabel?.textAlignment = .left
//        CMBtn.contentHorizontalAlignment = .left
        
        CMBtn.setTitle(" CM見てポイントGET！", for: UIControlState())
        CMBtn.layer.cornerRadius = 5.0
        CMBtn.backgroundColor = UIColor.brown
        CMBtn.layer.borderColor =  UIColor.white.cgColor
        CMBtn.layer.borderWidth = 1.0
//        CMBtn.backgroundColor = [UIColor colorWithRed:(200.0f/255.0f) green:0.0 blue:0.0 alpha:1.0];
//        CMBtn.layer.cornerRadius = 3.0;
//        CMBtn.layer.borderWidth = 2.0;
//        CMBtn.layer.borderColor = [[UIColor clearColor] CGColor];
        CMBtn.layer.shadowColor = UIColor.gray.cgColor as! CGColor
        CMBtn.layer.shadowOpacity = 1.0
        CMBtn.layer.shadowRadius = 1.0
        CMBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
        //        addSubview(IconBtn)
        //        addSubview(NameBtn)
        //        addSubview(MailBtn)
        IconBtn.addTarget(self, action: #selector(setUpButtonClick), for: .touchUpInside)
        NameBtn.addTarget(self, action: #selector(setUpButtonClick), for: .touchUpInside)
        MailBtn.addTarget(self, action: #selector(setUpButtonClick), for: .touchUpInside)
        PointBtn.addTarget(self, action: #selector(setUpButtonClick), for: .touchUpInside)
        CMBtn.addTarget(self, action: #selector(CMButtonClick), for: .touchUpInside)
    }
    
}
