//
//  new.swift
//  packtrack
//
//  Created by ksymac on 2017/12/13.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit
import GoogleMobileAds


extension TrackNoAddViewController: FADDelegate,GADBannerViewDelegate {
    func initAdmobView(){
        // MARK:加入广告
        #if FREE
        if MyUserDefaults.shared.getPurchased_ADClose(){
            self.FiveAdViewHeight.constant=0
//            self.FiveAdView.frame.size = CGSize(width: self.FiveAdView.frame.width, height: 0)
//            self.FiveAdView.removeFromSuperview()
        }else{
            var admobView: GADBannerView = GADBannerView()
            admobView = GADBannerView(adSize:kGADAdSizeBanner)
            admobView.frame.origin = CGPoint(x:0, y:0)
            admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
            admobView.adUnitID = AdMobID_ADDView
            admobView.delegate = self
            admobView.rootViewController = self
            let admobRequest:GADRequest = GADRequest()
            admobView.load(admobRequest)
            self.FiveAdViewHeight.constant=admobView.frame.height
//            self.FiveAdView.frame.size = CGSize(width: self.FiveAdView.frame.width, height: admobView.frame.height)
            self.FiveAdView.addSubview(admobView)
        }
        #else
            self.FiveAdViewHeight.constant=0
//            self.FiveAdView.removeFromSuperview()
        #endif
    }
    
    
    func initFiveAD(){
        self.FiveAdViewHeight.constant = 0
        // InFeedの生成と表示
//        infeed = FADInFeed(slotId: AD_FIVE_InFeed_slotId, width: 320)
//        infeed?.delegate = self
//        infeed?.loadAd()
        
//        adW320H180 = FADAdViewW320H180(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 180), slotId: AD_FIVE_adW320H180_slotId)
//        adW320H180?.delegate = self
//        adW320H180?.loadAd()
    }
    func fiveAdDidLoad(_ ad: FADAdInterface!) {
        if (infeed?.state == kFADStateLoaded) {
            infeed?.frame = CGRect.init(x: 0, y: 0, width: 320, height: 180)
            self.FiveAdView.addSubview(infeed!)
        }
        if (adW320H180?.state == kFADStateLoaded) {
            self.FiveAdView.addSubview(adW320H180!)
        }
    }
    
    func fiveAd(_ ad: FADAdInterface!, didFailedToReceiveAdWithError errorCode: FADErrorCode) {
        print(errorCode)
    }
    
    func fiveAdDidClick(_ ad: FADAdInterface!) {
        
    }
    
    func fiveAdDidClose(_ ad: FADAdInterface!) {
        
    }
    
    func fiveAdDidStart(_ ad: FADAdInterface!) {
        
    }
    
    func fiveAdDidPause(_ ad: FADAdInterface!) {
        
    }
    
    func fiveAdDidResume(_ ad: FADAdInterface!) {
        
    }
    
    func fiveAdDidViewThrough(_ ad: FADAdInterface!) {
        
    }
    
    func fiveAdDidReplay(_ ad: FADAdInterface!) {
        
    }
    
}


