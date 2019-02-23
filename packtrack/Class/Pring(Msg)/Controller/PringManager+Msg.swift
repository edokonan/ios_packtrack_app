//
//  ViewController.swift
//  Sample
//
//  Created by 1amageek on 2017/10/10.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

var fcmtoken:String?{
    get{
        return MyUserDefaults.shared.getFCMTOKEN()
    }
    set{
        MyUserDefaults.shared.setFCMTOKEN(newValue!)
    }
}
var enableRemoteNotification:Bool?{
    get{
        return MyUserDefaults.shared.getEnableRemoteNotification()
    }
    set{
        MyUserDefaults.shared.setEnableRemoteNotification(newValue!)
    }
}

var fcmPushOnOff:Bool = false
var appver=""
/*
 增加时，ADD
 更新时，Update，
 更新结束时，Delete
 手动修改时，trackno和tracktype变化时，delete，ADD
 手动删除时，Delete
 △关闭通知时，全删除
 △打开通知时，全添加
 */
extension PringManager {
    //MARK: - 修改key
    func updaKeyToFcm(oldno:String,newbean:TrackMain){
        //check token
        if fcmtoken == nil || enableRemoteNotification != true{
            return
        }
        if oldno == newbean.trackNo{
            self.updateToFCM(bean: newbean)
        }else{
            self.deleteDataToFCM(trackno: oldno)
            self.addDataToFCM(bean: newbean)
        }
    }
    
    //MARK: - 增删改
    func addDataToFCM(bean:TrackMain) {
        //check token
        if fcmtoken == nil || enableRemoteNotification != true{
            return
        }
        //check type
        if bean.trackType != "1" && bean.trackType != "2"  && bean.trackType != "3"
            && bean.trackType != "9" && bean.trackType != "6"{
            return
        }
        //如果已经收到了，就推出
        let deli_over = comfunc.isDeliveryOver(bean)
        if deli_over == true{
            return
        }
        
        let strstatus = bean.getNowStatus()
        let data: PringData = PringData()
        data.title = bean.commentTitle
        data.comment = bean.comment
        data.trackNo =  bean.trackNo
        data.trackType =  bean.trackType
        data.d_type = "I"
        data.d_token = fcmtoken!
        if let email = packtrack_user?.email{
            data.d_usermail = email
        }
//        data.typeName = bean.typeName//现状
//        data.status = bean.status//
        data.strStatus = strstatus//
        data.deli_over = deli_over
        if comfunc.isErrNo(bean){
            data.err_level = 1
        }
        #if FREE
            data.cron_group = Int(arc4random_uniform(4) + 2)
        #else
//            data.cron_group = Int(arc4random_uniform(2) + 1)
            data.cron_group = 1
        #endif
        data.save()
    }
    
    func updateToFCM(bean:TrackMain) {
        if fcmtoken == nil || enableRemoteNotification != true{
            return
        }
        //check type
        if bean.trackType != "1" && bean.trackType != "2"  && bean.trackType != "3"
                && bean.trackType != "9" && bean.trackType != "6"{
            return
        }
        //如果已经收到了，就删除云端数据
        let deli_over = comfunc.isDeliveryOver(bean)
        if deli_over == true{
            deleteDataToFCM(trackno: bean.trackNo)
            return
        }
        var err_level = 0
        if comfunc.isErrNo(bean){
            err_level = 1
        }
        //更新云端数据
        PringData.where(\PringData.trackNo, isEqualTo: bean.trackNo)
//            .where(\PringData.trackType, isEqualTo: bean.trackType)
            .where(\PringData.d_token, isEqualTo: fcmtoken!)
            .get { (snapshot, error) in
//                print(snapshot?.documents)
                if snapshot?.documents.count == 0{
                    self.addDataToFCM(bean: bean)
                    return
                }
                var email = ""
                if let temp = packtrack_user?.email{
                    email = temp
                }
                for document in (snapshot?.documents)!{
                    print(document.data())
                    let strstatus = bean.getNowStatus()
                    document.reference.updateData([
                        "title": bean.commentTitle,
                        "comment": bean.comment,
                        "trackType": bean.trackType,
                        "d_usermail": email,
//                        "typeName": bean.typeName,//现状
//                        "status": bean.status,//
                        "strStatus": strstatus,
                        "deli_over": deli_over,
                        "err_level": err_level,
                        "updatedAt": Date(),//现状
                    ]){ err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }
        }
    }
    func deleteDataToFCM(trackno:String)   {
        if fcmtoken == nil || enableRemoteNotification != true{
            return
        }
        PringData.where(\PringData.trackNo, isEqualTo: trackno)
//            .where(\PringData.trackType, isEqualTo: bean.trackType)
            .where(\PringData.d_token, isEqualTo: fcmtoken!)
            .get { (snapshot, error) in
                for document in (snapshot?.documents)!{
                    print(document.data())
                    document.reference.delete(completion: { (err) in
                        if let err = err {
                            print("Error deleted document: \(err)")
                        } else {
                            print("Document successfully deleted")
                        }
                    })
                }
        }
    }
    
}

