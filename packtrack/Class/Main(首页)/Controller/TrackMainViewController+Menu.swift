//
//  TrackMainViewController.swift
//  Created by ZHUKUI on 2015/08/13.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
import UIKit
import Alamofire
import SwiftyJSON
import GoogleMobileAds
import FirebaseCore
import FirebaseAnalytics

extension TrackMainViewController:SlideMenuDelegate,BTNavigationDropdownMenu_Delegate{
    //MARK : 显示下拉菜单，被按钮调用
    func showDropdownMenu() {
        self.showMenu(nil)
    }
    //MARK : 隐藏下拉菜单，被按钮调用
    func hideDropdownMenu() {
        self.closeMenu()
    }
    //MARK: - 选中菜单条目时调用
    func slideMenuItemSelectedAtIndex(_ index: Int) {
        self.closeMenu()
        if index >= 0 {
            self.nowSelectedStatus = self.statuslist[index].status
            self.menuView?.setMenuTitle1(self.statusitems[index])
            self.refreshByNewDBData()
        }
    }
    
    // MARK:  不添加左边的菜单
    func addSlideMenuButton(){
    }
    
    //MARK: - 显示菜单时的详细处理
    func showMenu(_ sender : UIButton?){
//        overlayView.frame = self.view.frame
        self.overlayView.isHidden = false
        
        self.resetMenuView()
        self.menuVC.refresh()
        
        self.menuVC.isShown = true
        self.menuView?.isShown = true
        
        if menuVC.view.superview != self.overlayView{
            menuVC.delegate = self
            self.overlayView.addSubview(menuVC.view)
        }
//        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            self.menuView?.menuArrow.transform = (self.menuView?.menuArrow.transform.rotated(by: 180 * 3 * CGFloat(M_PI/360)))!
            sender?.isEnabled = true
        }, completion:nil)
    }

    //MARK: - 关闭菜单时的详细处理
    func closeMenu(){
        self.menuVC.isShown = false
        self.menuView?.isShown = false
        
        // To Hide Menu If it already there
//        self.slideMenuItemSelectedAtIndex(-1);
//        let viewMenuBack : UIView = view.subviews.last!
        let viewMenuBack : UIView = self.menuVC.view
        UIView.animate(withDuration: 0.3, animations: {
            () -> Void in
            var frameMenu : CGRect = viewMenuBack.frame
            frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
            viewMenuBack.frame = frameMenu
            viewMenuBack.layoutIfNeeded()
            viewMenuBack.backgroundColor = UIColor.clear
            
            self.menuView?.menuArrow.transform = CGAffineTransform.identity//(self.menuView?.menuArrow.transform.rotated(by: 180 * CGFloat(M_PI/360)))!
        }, completion: { (finished) -> Void in
            viewMenuBack.removeFromSuperview()
            self.overlayView.isHidden = true
        })
    }
    //MARK: - 点击控制菜单的按钮的处理 ，旧的，现在并没有左右
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
//        if (sender.tag == 10){
//            sender.tag = 0;
//            closeMenu()
//            return
//        }
//        sender.isEnabled = false
//        sender.tag = 10
//        menuVC.btnMenu = sender
//        self.showMenu(sender)
        if  self.menuView?.isShown ?? false {
            closeMenu()
        }else{
            menuVC.btnMenu = sender
            self.showMenu(sender)
        }
    }
    
    //MARK: - 设置左右滑动时，显示菜单
    func setSwipe() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        rightSwipe.direction = .right
        self.tableView.addGestureRecognizer(rightSwipe)
    }
    func didSwipe(sender: UISwipeGestureRecognizer) {
        if self.tableView.isEditing {
//            print("self.tableView.isEditing")
            self.tableView.isEditing = false
            return
        }
        if sender.direction == .right {
//            print("Right")
            self.showDropdownMenu()
        }else if sender.direction == .left {
//            print("Left")
        }
    }
    func setDoubleTapTab() {
        if let tabvc = self.navigationController?.tabBarController as? MyTabBarController {
            tabvc.onTabTapBlock_0 = {
                if self.menuVC.isShown{
                    self.hideDropdownMenu()
                }else{
                    self.showDropdownMenu()
                }
            }
        }
    }
}

