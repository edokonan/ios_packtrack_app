//
//  B2_ReviewRequest.swift
//  packtrack
//
//  Created by Behrad Bagheri on 4/7/17.
//  Copyright © 2017 BehradBagheri. All rights reserved.
import Foundation
import StoreKit

class MyReviewManager: NSObject {
    static let shared = MyReviewManager()
    
    static let didReviewSetting = "didReview"  // UserDefauls dictionary key where we store number of runs
    static let runIncrementerSetting = "numberOfRuns"  // UserDefauls dictionary key where we store number of runs
    static let minimumRunCount = 2                     // Minimum number of runs that we should have until we ask for review
    
    static func incrementAppRuns() {                   // counter for number of runs for the app. You can call this from App Delegate
        let usD = UserDefaults()
        let runs = getRunCounts() + 1
        usD.setValuesForKeys([runIncrementerSetting: runs])
        usD.synchronize()
    }
    
    static func getRunCounts () -> Int {               // Reads number of runs from UserDefaults and returns it.
        let usD = UserDefaults()
        let savedRuns = usD.value(forKey: runIncrementerSetting)
        
        var runs = 0
        if (savedRuns != nil) {
            runs = savedRuns as! Int
        }
        
        print("Run Counts are \(runs)")
        return runs
    }
    
    static func setDidReveiew() {                   // counter for number of runs for the app. You can call this from App Delegate
        let usD = UserDefaults()
        usD.setValuesForKeys([didReviewSetting: true])
        usD.synchronize()
    }
    static func getDidReview() -> Bool {               // Reads number of runs from UserDefaults and returns it.
        let usD = UserDefaults()
        let savedRuns = usD.value(forKey: didReviewSetting)
        if (savedRuns != nil) {
            return true
        }
        return false
    }
    
    static func showReviewWithAddEvent(vc:UIViewController) {
        if getDidReview() == true{
            return
        }
        
        incrementAppRuns()
        
        let runs = getRunCounts()
        print("Show Review")
        if (runs > minimumRunCount) {
            //            if #available(iOS 10.3, *) {
            //                print("Review Requested")
            //                SKStoreReviewController.requestReview()
            //                setDidReveiew()
            //            } else {
            //
            //            }
            requestReview(vc: vc)
        } else {
            print("Runs are now enough to request review!")
        }
    }
    static func requestReview(vc:UIViewController) {
        #if FREE
        let review_str = "itms-apps://itunes.apple.com/app/id1031589055?action=write-review"
        #else
        let review_str = "itms-apps://itunes.apple.com/app/id1048459282?action=write-review"
        #endif
        
        if #available(iOS 10.3, *) {
            print("Review Requested")
            SKStoreReviewController.requestReview()
            setDidReveiew()
        }else if let url = URL(string: review_str){
            showAlertController(url: url,vc: vc)
            setDidReveiew()
        }
    }
    static func showAlertController(url: URL,vc:UIViewController) {
        let alert = UIAlertController(title: "評価とレビュー",
                                      message: "いつもありがとうございます！\nレビューをお願いします！",
                                      preferredStyle: .alert)//
        vc.present(alert, animated: true, completion: nil)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        alert.addAction(cancelAction)
        let reviewAction = UIAlertAction(title: "Review",
                                         style: .default,
                                         handler: {
                                            (action:UIAlertAction!) -> Void in
                                            if #available(iOS 10.0, *) {
                                                UIApplication.shared.open(url, options: [:])
                                            }
                                            else {
                                                UIApplication.shared.openURL(url)
                                            }
        })
        alert.addAction(reviewAction)
    }
    
}
