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

extension TrackMainViewController:MainCardCellDelegate{
    func MainCardCellBtnClick1(_ bean : TrackMain?){
        self.movetoEditView(bean!)
    }
    func MainCardCellBtnClick2(_ bean : TrackMain?){
//        self.delTable(indexPath)
//        self.moveTable(indexPath)
        self.reDeliveyAction(bean: bean!)
    }
    func MainCardCellBtnClick3(_ bean : TrackMain?){
        displayOtherSheet(vc:self, bean: bean)
    }
    
    func getIndexWithBean(bean : TrackMain?) -> IndexPath?{
        for i in 0...listTrackMain.count-1 {
            if listTrackMain[i].trackNo == bean?.trackNo{
                return IndexPath.init(row: i, section: 0)
            }
        }
        return nil
    }
    
    func reDeliveyAction(bean : TrackMain?) {
        guard let indexPath = getIndexWithBean(bean: bean) else {
            return
        }
        
        self.moveToRedeliveryVC(indexPath,type: 1)
    }
    
    
    func displayOtherSheet(vc:UIViewController,bean : TrackMain?) {
        guard let indexPath = getIndexWithBean(bean: bean) else {
            return
        }
        // 选择分享目标
        let shareMenu = UIAlertController(title: nil, message: "メニュー", preferredStyle: .actionSheet)
        let delAction = UIAlertAction(title: "削除", style: .default, handler: { (action:UIAlertAction) -> Void in
            self.delTable(indexPath)
        })
        let moveAction = UIAlertAction(title: "移動", style: .default, handler: { (action:UIAlertAction) -> Void in
            self.moveTable(indexPath)
        })
        let copyAction = UIAlertAction(title: "番号をコピー", style: .default, handler: { (action:UIAlertAction) -> Void in
            self.copyNo(indexPath)
        })
//        let reDeliveyAction = UIAlertAction(title: "再配達サイトへ", style: .default, handler: { (action:UIAlertAction) -> Void in
//            self.moveToRedeliveryVC(indexPath,type: 1)
//        })
        let openWebAction = UIAlertAction(title: "ホームサイトへ(Webブラウザ)", style: .default, handler: { (action:UIAlertAction) -> Void in
            self.copyNo(indexPath)
            self.moveToHomePage(indexPath,type:2)
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        shareMenu.addAction(delAction)
        shareMenu.addAction(moveAction)
        shareMenu.addAction(copyAction)
//        shareMenu.addAction(reDeliveyAction)
        shareMenu.addAction(openWebAction)
        shareMenu.addAction(cancelAction)
        
        shareMenu.popoverPresentationController?.sourceView = self.view;
        if let cell = tableView.cellForRow(at: indexPath){
            shareMenu.popoverPresentationController?.sourceRect = CGRect.init(x: 0,
                                                                              y: cell.frame.origin.y,
                                                                              width: cell.frame.width/2,
                                                                              height: cell.frame.height);
        }
        self.present(shareMenu, animated: true, completion: nil)
    }
}

