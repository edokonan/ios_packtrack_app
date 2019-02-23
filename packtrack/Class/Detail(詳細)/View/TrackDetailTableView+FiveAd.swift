
//
//  new.swift
//  packtrack
//
//  Created by ksymac on 2017/12/13.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit

extension TrackDetailTableView: FADDelegate{
//    func initFiveAD(){
//        if (adW320H180_detailview?.state == kFADStateLoaded) {
//            adW320H180_detailview?.delegate = self
//            self.addFiveAdView()
//            return
//        }
//        var height = (180 / 320 * UIScreen.main.bounds.width)
////        if height > 210 {
////            height = 210
////        }
//        height = 180
//        adW320H180_detailview = FADAdViewW320H180(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height), slotId: AD_FIVE_adW320H180_slotId)
//        adW320H180_detailview?.delegate = self
//        adW320H180_detailview?.loadAd()
//    }
    func initFiveAD(){
        UIAdViewHeight.constant = 0
//        if (adWcustom_detailview?.state == kFADStateLoaded) {
//            adWcustom_detailview?.delegate = self
//            self.addFiveAdView()
//            return
//        }
//        let  listTrackMain = TrackMainModel.shared.getAll()
//        if listTrackMain.count<2{
//            return
//        }
//        adWcustom_detailview = FADAdViewCustomLayout( slotId: AD_FIVE_adWcustom_detailview_slotId,width:Float(UIScreen.main.bounds.width))
//        adWcustom_detailview?.delegate = self
//        adWcustom_detailview?.loadAd()
    }
    
    func fiveAdDidLoad(_ ad: FADAdInterface!) {
//        if (adW320H180_detailview?.state == kFADStateLoaded) {
//            self.addFiveAdView()
//        }
        if (adWcustom_detailview?.state == kFADStateLoaded) {
            self.addFiveAdView()
            return
        }
    }
    func addFiveAdView(){
        if adW320H180_detailview_Through {
            UIAdViewHeight.constant = 0
            self.UIAdView.backgroundColor = GlobalBackgroundColor
            return
        }
//        var height = (180 / 320 * UIScreen.main.bounds.width)
//        if height > 210 {
//            height = 210
//        }
//        height = 180
//        UIAdViewHeight.constant = height
//        self.UIAdView.addSubview(adW320H180_detailview!)
        if isiPhoneXScreen(){
            UIAdViewHeight.constant = (adWcustom_detailview?.height)! + 30
        }else{
            UIAdViewHeight.constant = (adWcustom_detailview?.height)!
        }
        self.UIAdView.addSubview(adWcustom_detailview!)
    }
    
    func fiveAd(_ ad: FADAdInterface!, didFailedToReceiveAdWithError errorCode: FADErrorCode) {
        print(errorCode)
    }
    
    func fiveAdDidClick(_ ad: FADAdInterface!) {
        print("fiveAdDidClick")
    }
    
    func fiveAdDidClose(_ ad: FADAdInterface!) {
        print("fiveAdDidClose")
    }
    
    func fiveAdDidStart(_ ad: FADAdInterface!) {
        print("fiveAdDidStart")
    }
    
    func fiveAdDidPause(_ ad: FADAdInterface!) {
        print("fiveAdDidPause")
    }
    
    func fiveAdDidResume(_ ad: FADAdInterface!) {
        print("fiveAdDidResume")
    }
    
    func fiveAdDidViewThrough(_ ad: FADAdInterface!) {
        print("fiveAdDidViewThrough")
//        adW320H180_detailview_Through = true
//        weak var unownedSelf = self
//        let deadlineTime = DispatchTime.now() + .seconds(10)
//        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
//            unownedSelf?.addFiveAdView()
//        })
    }
    
    func fiveAdDidReplay(_ ad: FADAdInterface!) {
        print("fiveAdDidReplay")
    }
}


