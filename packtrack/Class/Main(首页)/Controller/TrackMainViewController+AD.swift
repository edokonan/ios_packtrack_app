//
//  TrackMainViewController.swift
//  Created by ZHUKUI on 2015/08/13.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
import UIKit

extension TrackMainViewController: FADDelegate{
    func initFiveAD(){
        if (adWcustom_mainview?.state == kFADStateLoaded) {
            adWcustom_mainview?.delegate = self
            self.addFiveAdView()
            return
        }
        adWcustom_mainview = FADAdViewCustomLayout( slotId: AD_FIVE_adWcustom_mainview_slotId,width:Float(UIScreen.main.bounds.width))
        adWcustom_mainview?.delegate = self
        adWcustom_mainview?.loadAd()
    }
    
    func fiveAdDidLoad(_ ad: FADAdInterface!) {
        if (adWcustom_mainview?.state == kFADStateLoaded) {
            self.resetListTrackMainWithAdBean()
            self.tableView.reloadData()
            return
        }
    }
    func addFiveAdView(){
//        UIAdViewHeight.constant = (adWcustom_mainview?.height)!
//        self.UIAdView.addSubview(adWcustom_mainview!)
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
