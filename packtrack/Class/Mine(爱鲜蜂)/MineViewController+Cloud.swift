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

// MARK:上传，下载
extension MineViewController{
    // MARK:- 生成备份文件,上传数据到云端
    func createBakupFile(){
        guard let user = packtrack_user else {
            popLoginVC()
            return
        }
        self.checkPoint(flg: 0) {
            SVProgressHUD.dismiss()
            let alert: UIAlertController = UIAlertController(title: "バックアップ", message: "バックアップデータを作成しますか？", preferredStyle:  UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "確定", style: UIAlertActionStyle.default, handler:{
                (action: UIAlertAction!) -> Void in
//                SVProgressHUD.show()
                self.startBackUp()
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{(action: UIAlertAction!) -> Void in
            })
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
            Analytics.logEvent("Cloud_BackUp", parameters: [
                "user": Auth.auth().currentUser?.uid,
                ])
        }
    }
    func startBackUp(){
        SVProgressHUD.show(withStatus: "バックアップファイル作成中")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let fileurl = myCloudDB.createJsonFileWithDB(){
                let filename = myCloudDB.createFileNameWithDate()
                self.uploadFileToCloud(fileURL: fileurl, fileName: filename,
                                       oldFileURL: packtrack_user?.packtrack_backupFileUrl)
            }else{
                SVProgressHUD.show(withStatus: "バックアップファイル作成失敗")
                SVProgressHUD.dismiss(withDelay: 2)
            }
        }
    }
    func uploadFileToCloud(fileURL: URL?, fileName: String, oldFileURL: String?){
        if let user = Auth.auth().currentUser {
            weak var weak_self = self
            CloudDBRef().uploadFileIntoDatabaseWithUID(user.uid, fileURL: fileURL, fileName: fileName, successCompetion: {
                weak_self?.AddPointWithUse(addPoint: (0 - common_bakup_point))
                weak_self?.DelOldBakUpFile(oldFileURL: oldFileURL)
                SVProgressHUD.dismiss()
                weak_self?.showEndDialog(title:"バックアップ",msg: "バックアップデータ作成完了")
            },failureCompetion: {
                SVProgressHUD.dismiss()
                weak_self?.showEndDialog(title:"バックアップ",msg: "バックアップデータ作成失敗した")
            }
            )
        }else{
            print("err")
        }
    }
    // MARK:- 删除现存的旧的备份文件
    func DelOldBakUpFile(oldFileURL: String?){
        //如果存在现在的备份文件的话，就删除
        if let oldfileurl = oldFileURL{
            myCloudDB.DelBakFileWityFileURL(oldfileurl, successCompetion: {
                Analytics.logEvent("Cloud_DelOldBakUpFile", parameters: [
                    "user": Auth.auth().currentUser?.uid,
                    ])
            }, failureCompetion: {
                
            })
        }

    }
    
    //MARK: 从云端下载数据并进行
    func restoreData(){
        guard let user = packtrack_user else {
            popLoginVC()
            return
        }
        //for test
        //packtrack_user?.packtrack_backupFileUrl = 
        guard let strurl = packtrack_user?.packtrack_backupFileUrl,
            let url =  URL(string: strurl) else {
                SVProgressHUD.showError(withStatus: "バックアップデータがありません。復元できません。")
                SVProgressHUD.dismiss(withDelay: 2)
                return
        }
        self.checkPoint(flg: 1)  {
            SVProgressHUD.dismiss()
            let alert: UIAlertController = UIAlertController(title: "データ復元", message: "バックアップからデータを復元しますか？", preferredStyle:  UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "確定", style: UIAlertActionStyle.default, handler:{
                (action: UIAlertAction!) -> Void in
                self.downloadAndRestoreWithCloudFile(url: url)
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{(action: UIAlertAction!) -> Void in
            })
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
            
            Analytics.logEvent("Cloud_RestoreData", parameters: [
                "user": Auth.auth().currentUser?.uid,
                ])
        }
    }
    func downloadAndRestoreWithCloudFile(url:URL ){
        SVProgressHUD.resetOffsetFromCenter()
        SVProgressHUD.show(withStatus: "データ復元中")
        weak var weak_self = self
        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
//                print(error)
                weak_self?.showEndDialog(title:"復元",msg: "データ復元失敗した")
                return
            }
            myCloudDB.restoreDataFromCloudData(data: data!,
                                               successCompetion:{
                                                weak_self?.showEndDialog(title:"復元",msg: "データ復元完了しました。")
                                                weak_self?.AddPointWithUse(addPoint: (0 - common_bakup_point))
            },failureCompetion: {
                weak_self?.showEndDialog(title:"復元",msg: "データ復元失敗した")
            }
            )
            //            DispatchQueue.main.async(execute: {
            //                if let downloadedImage = UIImage(data: data!) {
            //                    self.headView.iconView.iconImageView.setImage(downloadedImage, for: UIControlState())
            //                }
            //            })
        }).resume()
    }
    func showEndDialog(title:String , msg : String){
        SVProgressHUD.dismiss()
        //        DispatchQueue.main.async(execute: {
        //
        //        })
        let alert: UIAlertController = UIAlertController(title: title, message: msg, preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "確定", style: UIAlertActionStyle.default, handler:{(action: UIAlertAction!) -> Void in
        })
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        //        SVProgressHUD.showSuccess(withStatus:  msg)
        //        SVProgressHUD.dismiss(withDelay: 10)
    }
    // MARK:- ローカルDBクリア
    func clearDB(){
        let alert: UIAlertController = UIAlertController(title: "ローカルデータを削除", message: "既存デートを全部削除してもいいですか？", preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            myCloudDB.clearDB()
            SVProgressHUD.resetOffsetFromCenter()
            SVProgressHUD.showSuccess(withStatus:  "データを削除しました。")
            SVProgressHUD.dismiss(withDelay: 3)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{(action: UIAlertAction!) -> Void in
            //            print("Cancel")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK:- ローカルDBクリア
    func openSettingMsgView(){
        
        var msg_str = ""
        if enableRemoteNotification == true{
            #if FREE
            msg_str = "設定画面から通知OFFを設定できます。 「設定＞通知＞MY宅配便」で通知許可をOFFに設定してください。"
            #else
            msg_str = "設定画面から通知OFFを設定できます。 「設定＞通知＞MY宅配便Pro」で通知許可をOFFに設定してください。"
            #endif
        }else{
            #if FREE
            msg_str = "通知設定は未許可です。「設定＞通知＞MY宅配便」で通知を許可してください。"
            #else
            msg_str = "通知設定は未許可です。「設定＞通知＞MY宅配便Pro」で通知を許可してください。"
            #endif
        }
        
        let alert: UIAlertController = UIAlertController(title: "通知設定", message: msg_str, preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "設定する", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            if let url = URL(string: UIApplicationOpenSettingsURLString){
                if (UIApplication.shared.canOpenURL(url)){
                    UIApplication.shared.openURL(url)
                }
            }
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{(action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
        
        

    }
    
    
    
    // MARK:- 更新Point
    func AddPointWithUse(addPoint: Int)->Bool{
        guard let uid = Auth.auth().currentUser?.uid else {
            return false
        }
        weak var weak_self = self
        myCloudDB.AddPointWithUser(uid, addPoint: addPoint,
                                   successCompetion: {
                                    weak_self?.reloadViewWithUserData()
        },
                                   failureCompetion: {})
        return false
    }
    //MARK:-删除文件
    func DelBakFilewithUser()->Bool{
        guard let uid = Auth.auth().currentUser?.uid else {
            return false
        }
        weak var weak_self = self
        let alert: UIAlertController = UIAlertController(title: "バックアップデート削除", message: "バックアップデートを削除してもいいですか？", preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            myCloudDB.DelBakFilewithUser(uid,successCompetion: {
                weak_self?.reloadViewWithUserData()
                self.showEndDialog(title: "バックアップデータ", msg: "バックアップデータを削除しました。")
            },failureCompetion: {})
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{(action: UIAlertAction!) -> Void in
            
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
        return false
    }
    
}
