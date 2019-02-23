//
//  AppDelegate.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/05.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseCrash
import AFNetworking
import AVFoundation
import SwiftyStoreKit
import IceCream
import CloudKit
import RealmSwift
import RxRealm
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // window 必须
    var window: UIWindow?
    var tracker: GAITracker?
    var tabBarController:MyTabBarController?
    var mainViewController:TrackMainViewController?
    var toolBoxTableViewController:ToolBoxTableViewController?
    
    let gcmMessageIDKey = "gcm.message_id"
    var gcmClickTrackNo:String?
    
    var syncEngine: SyncEngine?
    
    //https://github.com/googlesamples/google-services/blob/master/ios/analytics/AnalyticsExampleSwift/AppDelegate.swift#L27-L35
    //http://qiita.com/kaneshin/items/71f1c19d094e87e30a07
    // MARK: - 设置状态栏颜色,设置监视网络状态
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        //firebase
        FirebaseApp.configure()
//        FIRCrashMessage("test packtrack")
        //开始监视网络
        IJReachability.startMonitoring()
        //开始设置AD和
        initAD()
        //开始启动跟踪
        setupGoogleAnalytics()
        
        //设置音乐
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        //设置购买
        setupIAP()
        //获取当前云端的用户
        UserManager.shared.getCurrentUser()
        
        self.setMsg(application)
        
        let config = Realm.Configuration(schemaVersion: 4,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 4) {
                    
                }
        })
        Realm.Configuration.defaultConfiguration = config
        //icecream
        syncEngine = SyncEngine(objects: [
//            SyncObject<Person>(),
//            SyncObject<Dog>(),
//            SyncObject<Cat>(),
            SyncObject<RMTrackStatus>(),
            SyncObject<RMTrackMain>(),
            SyncObject<RMTrackDetail>(),
            ])
        application.registerForRemoteNotifications()
        
        IceCreamMng.shared.startImportToIceCreamFromOldDB()
        IceCream.shared.enableLogging = false
        return true
    }

    func setupIAP() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in
            // contentURL is not nil if downloadState == .finished
            let contentURLs = downloads.flatMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                print("Saving: \(contentURLs)")
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
    }
    func setupGoogleAnalytics() {
        GAI.sharedInstance().trackUncaughtExceptions = true;
        GAI.sharedInstance().dispatchInterval = 20
        //GAI.sharedInstance().logger.logLevel = GAILogLevel.Error
        //.Verbose
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            #if FREE
                appDelegate.tracker = GAI.sharedInstance().tracker(withTrackingId: "UA-36383173-8")
            #else
                appDelegate.tracker = GAI.sharedInstance().tracker(withTrackingId: "UA-36383173-4")
            #endif
        }
    }
    func initAD(){
        #if FREE
        if !MyUserDefaults.shared.getPurchased_ADClose(){
            //admob 初期设置
            GADMobileAds.configure(withApplicationID: "ca-app-pub-5780207203103146~1294432711")
        }
            ComFunc.ver_free = true
//            iRate.sharedInstance().applicationBundleID = "com.ksyapp.packtrack"
//            iRate.sharedInstance().onlyPromptIfLatestVersion = false
//            iRate.sharedInstance().usesUntilPrompt = 3
//            iRate.sharedInstance().daysUntilPrompt = 0
//            iRate.sharedInstance().eventsUntilPrompt = 3
//            iRate.sharedInstance().remindPeriod = 1
        #else
            ComFunc.ver_free = false
            UserDefaults.standard.set(true, forKey: "pro_view_auto_refresh")
//            iRate.sharedInstance().applicationBundleID = "com.ksyapp.packtrackpro"
//            iRate.sharedInstance().onlyPromptIfLatestVersion = false
//            iRate.sharedInstance().usesUntilPrompt = 3
//            iRate.sharedInstance().daysUntilPrompt = 0
//            iRate.sharedInstance().eventsUntilPrompt = 3
//            iRate.sharedInstance().remindPeriod = 2
        #endif
//        initFiveAD()
    }
//    func initFiveAD(){
//        #if FREE
//        if MyUserDefaults.shared.getPurchased_ADClose(){
//            return
//        }
//        // 初期化
//        config = FADConfig(appId: AD_FIVE_APPID)
//        config?.fiveAdFormat = Set<Int>(arrayLiteral:
//            //kFADFormatInterstitialLandscape.rawValue,
//            //kFADFormatInterstitialPortrait.rawValue,
//            //kFADFormatInFeed.rawValue,
//            //kFADFormatW320H180.rawValue,
//            kFADFormatCustomLayout.rawValue
//        )
//        //        config?.isTest = true
//        FADSettings.register(config)
//        FADSettings.enableSound(false)
//        FADSettings.enableLoading(true)
//        #else
//        
//        #endif
//
//    }
//    func checkDB(){
//        let trackMainModel = TrackMainModel()//model
//        let trackDetailModel = TrackDetailModel()//model
//        let trackStatusModel = TrackStatusModel()//model
//    }
    //    //MARK: 设置FireBase服务
    //    class func setAnalytics() {
    //        Analytics.logEvent("test", parameters: nil);
    //        Analytics.logEvent("share_image", parameters: [
    //            "name": "test",
    //            "full_text":"text as NSObject"
    //            ])
    //    }
    

    func applicationWillEnterForeground(_ application: UIApplication) {
        //print("applicationWillEnterForeground")
        //⬇️analytics
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "ApplicationActive")
        let params = GAIDictionaryBuilder.createScreenView().build() as! [AnyHashable: Any]
        tracker?.send(params)
        
        Analytics.setScreenName("ApplicationActive", screenClass: FIRAnalytics_Screen_Class1)
        #if FREE
        #else
            UserDefaults.standard.set(true, forKey: "pro_view_auto_refresh")
            mainViewController?.init_auto_refresh()
        #endif
//        self.checkShareExtension()
    }
    
    //    //home
    //    "mypacktrack://home
    //    //不在票
    //    "mypacktrack://undeliverable.notice"
    //    //追加
    //    "mypacktrack://add.item"
    //    //再配達
    //    "mypacktrack://redelivery
    //comksy-ptrack://search?no=1&type=1
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("url : \(url.absoluteString)")
        print("scheme : \(url.scheme!)")
        if let host = url.host{
            print("host : \(host)")
            if let port = url.port{
                print("port : \(port)")
            }
            if let query = url.query{
                print("query : \(query)")
            }
            OpenManager_Host = host
        }
        return true
    }
    
    
    // MARK: 进入前台时，进行处理
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let host = OpenManager_Host {
            print(host)
            if host == "home" {//home
                tabBarController?.selectedIndex = 0
                if let vc:UINavigationController =  tabBarController?.childViewControllers[0] as? UINavigationController{
                    vc.popToRootViewController(animated: false)
                }
            }
            if host == "add.item" {//追加
                tabBarController?.selectedIndex = 1
                if let vc:UINavigationController =  tabBarController?.childViewControllers[1] as? UINavigationController{
                    vc.popToRootViewController(animated: false)
                }
            }
            if host == "undeliverable.notice" {//不在票
//                tabBarController?.selectedIndex = 3
                tabBarController?.scanUndeliverableItemNotice(in_style: StyleDIY.zhiFuBaoStyle())
            }
            if host == "redelivery" {//再配達
                tabBarController?.selectedIndex = 2
                if let vc:UINavigationController =  tabBarController?.childViewControllers[2] as? UINavigationController{
                    vc.popToRootViewController(animated: false)
                }
            }
            OpenManager_Host = nil
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    // MARK: 退出时，关闭些必须关闭的打开窗口
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        tabBarController?.dismissAllPop()
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
}

