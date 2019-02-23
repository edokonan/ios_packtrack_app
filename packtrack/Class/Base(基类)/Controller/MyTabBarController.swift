//
//  MyTabBarController.swift
//  packtrack
//
//  Created by ksymac on 2017/10/30.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    var onTabTapBlock_0 : (()->())?
    var onTabTapBlock_1 : (()->())?
    var onTabTapBlock_2 : (()->())?
    var onTabTapBlock_3 : (()->())?
    var onTabTapBlock_4 : (()->())?
    var myUINavigationController = MyUINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        for i in 0...((tabBar.items?.count)!-1){
            tabBar.items?[i].tag = i
        }
        
        let tabBarItem1 = tabBar.items![0]
        let tabBarItem = tabBar.items![1]
        tabBarItem.title = "追加"
//        if let img = UIImage.init(named: "search"){
//                let img1 = img.resize(size: (tabBarItem1.selectedImage?.size)!)
//                tabBarItem.selectedImage = img1
//                tabBarItem.image = img1
//                tabBarItem.title = "追加"
//        }
        if (tabBar.items?.count)! < 3 {
            return
        }else{
            let tabBarItem4 = tabBar.items![2]
            if let img = UIImage.init(named: "delivery256"){
                let img1 = img.resize(size: (tabBarItem1.selectedImage?.size)!)
                tabBarItem4.selectedImage = img1
                tabBarItem4.image = img1
                tabBarItem4.title = "再配達"
            }
        }
        if (tabBar.items?.count)! < 4 {
            return
        }else{
            let tabBarItem_settings = tabBar.items![3]
            
            if let img = UIImage.init(named: "tab_person"){
                let img1 = img.resize(size: (tabBarItem1.selectedImage?.size)!)
                tabBarItem_settings.selectedImage = img1
                tabBarItem_settings.image = img1
            }
        }
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
        appDelegate.tabBarController = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var old_index = 0
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if self.selectedIndex == item.tag{
            switch item.tag {
            case 0:
                if let block = self.onTabTapBlock_0 {
                    block()
                }
            default:
                print("nothing")
            }
        }
    }
    
//    var scheme_flg = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        if let host = OpenManager_Host {
//            print(host)
//            if host == "add.item" {
//                self.selectedIndex = 1
//            }
//            OpenManager_Host = nil
//        }
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        OpenManager_Host = nil
//    }
//    // UITabBarControllerDelegate
//    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
//        print("Selected view controller")
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
extension UIImage {
    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
        let resizedSize = CGSize(width: (self.size.width * ratio), height: (self.size.height * ratio))
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 2)
        draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
//    // 比率だけ指定する場合
//    func resize(#ratio: CGFloat) -> UIImage {
//        let resizedSize = CGSize(width: Int(self.size.width * ratio), height: Int(self.size.height * ratio))
//        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 2)
//        drawInRect(CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
//        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return resizedImage
//    }
}
