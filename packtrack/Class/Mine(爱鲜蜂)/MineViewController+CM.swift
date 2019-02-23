//
//  ViewController.swift
//  packtrack
//
//  Created by ksymac on 2017/11/26.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import SVProgressHUD


extension MineViewController: GADRewardBasedVideoAdDelegate{
    //MARK:-ポイントをチェックする
    func checkPoint(flg:Int, rewardCompetion: (()->())?)->Bool{
        weak var weak_self = self
        if let point = packtrack_user?.packtrack_point {
            if point >= common_bakup_point{
                if let block = rewardCompetion{
                    block()
                }
                return true
            }else{
                var title = "CMを見ってバックアップ"
                if flg == 1{
                    title = "CMを見ってデータ復元"
                }
                let msg = "ポイント不足、CMを見ってポイントを貰えます。よろしいでしょうか？"
                let alert: UIAlertController = UIAlertController(title: title, message: msg, preferredStyle:  UIAlertControllerStyle.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "確定", style: UIAlertActionStyle.default, handler:{(action: UIAlertAction!) -> Void in
                    weak_self?.RewardCompetion = rewardCompetion
                    weak_self?.showAD()
                })
                let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{(action: UIAlertAction!) -> Void in
                })
                alert.addAction(cancelAction)
                alert.addAction(defaultAction)
                present(alert, animated: true, completion: nil)
                return false
            }
        }
        return false
    }
    //MARK:-CMを見ってポイントを貰える
    func seeCM(){
        self.RewardCompetion = nil
        self.showAD()
    }
    func showAD(){
        GADRewardBasedVideoAd.sharedInstance().delegate = self as! GADRewardBasedVideoAdDelegate
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: ADMOD_VideoAdUnitID)
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 10)
    }
    //MARK:-Rewardポイント
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        weak var weak_self = self
        myCloudDB.AddPointWithUser(uid, addPoint: common_reward_point,
                                   successCompetion: {
                                        weak_self?.reloadViewWithUserData()
                                    },
                                   failureCompetion: {})
        //获得奖励
        getCMReward = true
    }
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        SVProgressHUD.dismiss()
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            print("Reward based video ad is received.")
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }else{
            print("error, Reward based video ad is received.")
            RewardError()
        }
    }
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
        let str = String(format: "CMを最後まで見ったら、%dポイントを貰る", common_reward_point)
        //        SVProgressHUD.showInfo(withStatus: str)
        let offheight = UIScreen.main.bounds.height/3
        let offset :UIOffset =  UIOffset(horizontal: 0, vertical: offheight)
        SVProgressHUD.setOffsetFromCenter(offset)
        SVProgressHUD.showInfo(withStatus: str)
        SVProgressHUD.dismiss(withDelay: 2) {
            SVProgressHUD.resetOffsetFromCenter()
        }
        getCMReward = false
//        SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: 0))
        Analytics.logEvent("CM_StartPlay", parameters: [
            "user":  Auth.auth().currentUser?.uid,
            ])
    }
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
//        DispatchQueue.main.async(execute: {
//        })
        if let block = self.RewardCompetion {
            if getCMReward == true{
                block()
            }
        }
    }
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
        RewardError()
    }
    
    func RewardError(){
        let str = String(format: "CMロードが失敗しました")
//        SVProgressHUD.resetOffsetFromCenter()
        SVProgressHUD.showError(withStatus: str)
        SVProgressHUD.dismiss(withDelay: 3)
        self.RewardCompetion = nil
        getCMReward = false
    }
}
