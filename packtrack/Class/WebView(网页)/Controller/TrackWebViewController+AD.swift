//
//  TrackWebViewController.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/14.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//
import UIKit
import GoogleMobileAds

#if FREE
extension TrackWebViewController:FADDelegate{
    func initADView(){
        ADView.backgroundColor = GlobalBackgroundColor
        
        if (adW320H180_trackwebview?.state == kFADStateLoaded) {
            adW320H180_trackwebview?.delegate = self
            self.addFiveAdView()
            return
        }
        adW320H180_trackwebview = FADAdViewCustomLayout(slotId: AD_FIVE_adWcustom_webview_slotId,width:Float(UIScreen.main.bounds.width))
        adW320H180_trackwebview?.delegate = self
        adW320H180_trackwebview?.loadAd()
    }
    func loadFiveAD(){
//        adW320H180_trackwebview = FADAdViewW320H180(frame: CGRect.init(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: 180), slotId: AD_FIVE_adWcustom_webview_slotId)

    }
    func fiveAdDidLoad(_ ad: FADAdInterface!) {
        if (adW320H180_trackwebview?.state == kFADStateLoaded) {
            self.addFiveAdView()
        }

    }
    func addFiveAdView(){
//        self.ADViewHeight.constant = 180.0
//        self.ADView.addSubview(adW320H180_trackwebview!)
        if isiPhoneXScreen(){
            ADViewHeight.constant = (adW320H180_trackwebview?.height)! + 30
        }else{
            ADViewHeight.constant = (adW320H180_trackwebview?.height)!
        }
        self.ADView.addSubview(adW320H180_trackwebview!)
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
        //        adWcustom_mainview_Through = true
        weak var unownedSelf = self
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            //            unownedSelf?.resetListTrackMainWithAdBean()
            //            unownedSelf?.tableView.reloadData()
        })
    }
    
    func fiveAdDidReplay(_ ad: FADAdInterface!) {
        print("fiveAdDidReplay")
    }
}
#else

#endif

