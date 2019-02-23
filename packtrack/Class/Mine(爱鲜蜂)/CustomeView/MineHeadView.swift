//
//  MineHeadView.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit
class MineHeadView: UIImageView {
    var username :String = ""
    var strPoint :String = ""
    
    
    let setUpBtn: UIButton = UIButton(type: .custom)
    var loginBtnClick:(() -> Void)?
//    let iconView: IconView = IconView()
    let iconView: MyHomeHeadView = MyHomeHeadView.instance()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        image = UIImage(named: "v2_my_avatar_bg")
        image = UIImage.imageWithColor(GlobalHeadColor,
                               size: CGSize.init(width: 100, height: 100),
                               alpha: 1)
        setUpBtn.setTitle("login", for: UIControlState())
        setUpBtn.addTarget(self, action: #selector(MineHeadView.setUpButtonClick), for: .touchUpInside)
        addSubview(setUpBtn)
        addSubview(iconView)
        self.isUserInteractionEnabled = true
        iconView.setInitUI()
    }
    
    convenience init(frame: CGRect, loginButtonClick:@escaping (() -> Void), CmButtonClick:@escaping (() -> Void)) {
        self.init(frame: frame)
        loginBtnClick = loginButtonClick
        iconView.loginBtnClick = loginBtnClick
        iconView.cmBtnClick = CmButtonClick
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = CGRect(x: 0, y: 0, width: width, height: height)
//        iconView.backgroundColor = UIColor.green
        setUpBtn.frame = CGRect(x: 150, y: 0, width: 150, height: 50)
        setUpBtn.isHidden = true
    }
    
    func setUpButtonClick() {
        loginBtnClick?()
    }
    func setLoginedView(){
        iconView.setLoginedView()
    }
    func setLogoutView(){
        iconView.setLogoutView(btnClick: loginBtnClick)
    }
}




//class IconView: UIView {
////    var iconImageView: UIImageView!
//    var iconImageView: UIButton = UIButton(type: .custom)
//    var nameBtn: UIButton = UIButton()
//    var Pointlabel: UIButton = UIButton()
//    var loginBtnClick:(() -> Void)?
//    
//    func setLoginedView(){
//        if let user = packtrack_user {
//            let nameText = String(format: "%@  %d Point", user.name!, user.packtrack_point!)
//            nameBtn.setTitle(nameText, for: UIControlState())
//            let tempstr = String(format: "%@ (%d Point)", user.email!, user.packtrack_point!)
//            Pointlabel.setTitle(tempstr, for: UIControlState())
//            iconImageView.setImage(UIImage(named: "v2_my_avatar"), for: UIControlState())
//            loginBtnClick = nil
//        }
//    }
//    func setLogoutView(btnClick:(() -> Void)?){
//        nameBtn.setTitle("未登録", for: UIControlState())
//        Pointlabel.setTitle("クリックしてログインする", for: UIControlState())
//        iconImageView.setImage(UIImage(named: "v2_my_avatar"), for: UIControlState())
//        loginBtnClick = btnClick
//    }
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
////        iconImageView = UIImageView(image: UIImage(named: "v2_my_avatar"))
//        iconImageView.setImage(UIImage(named: "v2_my_avatar"), for: UIControlState())
//        nameBtn.setTitle("未登録", for: UIControlState())
////        phoneNum.titleLabel?.text = "Register/Login"
//        nameBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
//        nameBtn.titleLabel?.textColor = UIColor.white
//        nameBtn.titleLabel?.textAlignment = .left
//        nameBtn.contentHorizontalAlignment = .left
////        nameBtn.setImage(UIImage(named: "v2_my_settings_icon"), for: UIControlState())
//        
//        Pointlabel.setTitle("クリックしてログインする", for: UIControlState())
//        Pointlabel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
//        Pointlabel.titleLabel?.textColor = UIColor.white
//        Pointlabel.titleLabel?.textAlignment = .left
//        Pointlabel.contentHorizontalAlignment = .left
//        
//        addSubview(iconImageView)
//        addSubview(nameBtn)
//        addSubview(Pointlabel)
//        
//        iconImageView.addTarget(self, action: #selector(setUpButtonClick), for: .touchUpInside)
//        nameBtn.addTarget(self, action: #selector(setUpButtonClick), for: .touchUpInside)
//        Pointlabel.addTarget(self, action: #selector(setUpButtonClick), for: .touchUpInside)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    func setUpButtonClick() {
//        loginBtnClick?()
//    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
////        iconImageView.frame = CGRect(x: (width - 100) * 0.5, y: 0, width: 100, height: 80)
////        nameBtn.frame = CGRect(x: 0, y: 80, width: width, height: 30)
//        iconImageView.frame = CGRect(x: 20, y: 10, width: 100, height: 100)
//        nameBtn.frame = CGRect(x: iconImageView.frame.origin.x + iconImageView.frame.width - 5 ,
//                               y: 35, width: 200, height: 30)
//        Pointlabel.frame = CGRect(x: iconImageView.frame.origin.x + iconImageView.frame.width - 5 ,
//                               y: 60, width: 200, height: 30)
//    }
//    
//    
//}

