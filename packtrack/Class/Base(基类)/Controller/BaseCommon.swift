//
//  BaseCommon.swift
//  packtrack
//
//  Created by ksymac on 2017/04/01.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import Foundation
let FIRAnalytics_Screen_Class1 = "Screen"

//MARK: 每次的使用点数
#if FREE
let common_bakup_point = 10
#else
let common_bakup_point = 0
#endif
//MARK: 看广告的奖励点数
let common_reward_point = 20

//MARK: AdMob ID
let AdMobID_Main = "ca-app-pub-5780207203103146/2771165919"
let AdMobID_ADDView = "ca-app-pub-5780207203103146/8852082304"
let AdMobID_DetailView = "ca-app-pub-5780207203103146/1458544842"
let AdMobID_RedeliveryView = "ca-app-pub-5780207203103146/8524138574"

let AdMobTest:Bool = true
let AdUnitID_Offical = "ca-app-pub-5780207203103146/8230570433"
let AdUnitID_Test = "ca-app-pub-5780207203103146/3444835581"
let ADMOD_VideoAdUnitID = AdUnitID_Offical
//广告单元 ID：ca-app-pub-5780207203103146/3628668418//ios_插页广告

//MARK: FIVE ID
let AD_FIVE_APPID = "426223"
////インフィード_1 InFeed
//let AD_FIVE_InFeed_slotId = "758230"
////レクタングル_1
//let AD_FIVE_adW320H180_slotId = "899409"
//custom_
//100011976    W320H70_MainView W320×H70
//100060488    W320H70_DetailWebView W320×H70
//100024923    W320H70_DetailView W320×H70
//320_90 = "100223807"
//320_100 = "100317786"
let AD_FIVE_adWcustom_mainview_slotId = "100011976"
//let AD_FIVE_adWcustom_detailview_slotId = "100024923"
let AD_FIVE_adWcustom_webview_slotId = "100060488"


#if FREE
var config:FADConfig?
var infeed:FADInFeed?
var adW320H180:FADAdViewW320H180?

var adW320H180_detailview:FADAdViewW320H180?
var adW320H180_detailview_Through:Bool = false

var adWcustom_detailview:FADAdViewCustomLayout?
var adWcustom_detailview_Through:Bool = false

var adWcustom_mainview:FADAdViewCustomLayout?
var adWcustom_mainview_Through:Bool = false

//var adW320H180_trackwebview:FADAdViewW320H180?
var adW320H180_trackwebview:FADAdViewCustomLayout?
//var adW320H180_trackwebview_Through:Bool = false



let FiveAD_TEST:Bool = false
#else

#endif



//用于管理Schema
var OpenManager_Host :String?


func isiPhoneXScreen() -> Bool {
    guard #available(iOS 11.0, *) else {
        return false
    }
    if (UIApplication.shared.windows[0].safeAreaInsets.top > 0.0) {
        return  true;
    }
    return false
}
