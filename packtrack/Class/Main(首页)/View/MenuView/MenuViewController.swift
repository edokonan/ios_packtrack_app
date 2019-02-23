//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//
import Foundation
import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    // 现状，是否已经显示
    var isShown : Bool! = false
    var items: [AnyObject]!
    var iSelected : Int = 0
//    var isShown: Bool!
    
    class func instance() -> MenuViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
    }
    
    /**
    *  Array to display menu options
    */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
    *  Transparent button to hide menu
    */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
//    /**
//    *  Array containing menu options
//    */
//    var arrayMenuOptions = [Dictionary<String,String>]()
    
    /**
    *  Menu button which was tapped to display the menu
    */
    var btnMenu : UIButton?
    
    /**
    *  Delegate of the MenuVC
    */
    var delegate : SlideMenuDelegate?
    
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap")
//    myView.addGestureRecognizer(tapRecognizer)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMenuOptions.tableFooterView = UIView()
        tblMenuOptions.tableFooterView?.backgroundColor = UIColor.red
        tblMenuOptions.tableFooterView?.addGestureRecognizer(tapRecognizer)
        
        self.view.backgroundColor = UIColor.clear
        self.tblMenuOptions.backgroundColor = GlobalHeadColor
        // Do any additional setup after loading the view.
        
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        rightSwipe.direction = .right
        tblMenuOptions.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        leftSwipe.direction = .left
        tblMenuOptions.addGestureRecognizer(leftSwipe)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        updateArrayMenuOptions()
    }
//    func updateArrayMenuOptions(){
//        arrayMenuOptions.append(["title":"Home", "icon":"HomeIcon"])
//        arrayMenuOptions.append(["title":"Play", "icon":"PlayIcon"])
//        tblMenuOptions.reloadData()
//    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu?.tag = 0
        
        if (self.delegate != nil) {
            var index = Int(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
//        UIView.animate(withDuration: 0.3, delay: 0.2  ,animations: { () -> Void in
//            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
//            self.view.layoutIfNeeded()
//            self.view.backgroundColor = UIColor.clear
//            }, completion: { (finished) -> Void in
//                self.view.removeFromSuperview()
//                self.removeFromParentViewController()
//        })
    }
    


    func refresh(){
        if tblMenuOptions != nil {
            tblMenuOptions.reloadData()
//            tblMenuOptions.tableFooterView?.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = GlobalHeadColor
    
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
//        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
//        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        
        let str = items[indexPath.row] as! String
        lblTitle.text = str
        lblTitle.textColor = UIColor.white
        lblTitle.font = UIFont(name: "Avenir-Heavy", size: 18)
        
        
        if indexPath.row == iSelected {
            imgIcon.image = UIImage.init(named: "checkmark_icon")
        }else{
            imgIcon.image = UIImage.init()
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var old_indexPath = indexPath
        old_indexPath.row = iSelected
        iSelected = indexPath.row
        
        tblMenuOptions.reloadData()
        
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrayMenuOptions.count
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 100
//    }
//
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return ""
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let v = UITableViewHeaderFooterView()
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        v.addGestureRecognizer(tapRecognizer)
//        return v
//    }
//
    func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
       print("handleTap")
    }
    func didSwipe(sender: UISwipeGestureRecognizer) {

        if sender.direction == .right {
            print("Right")
        }
        else if sender.direction == .left {
//            print("Left")
            self.delegate?.slideMenuItemSelectedAtIndex(-1)
        }
    }
}
