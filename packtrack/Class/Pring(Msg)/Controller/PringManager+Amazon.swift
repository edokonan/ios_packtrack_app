//
//  PringManager+Amazon.swift
//  packtrack
//
//  Created by ksymac on 2018/8/29.
//  Copyright © 2018年 ZHUKUI. All rights reserved.
//

import Foundation


//Save to Cloud


extension PringManager {
//    //MARK: - 判断是否需要同步到cloud上
//    func updAmazonToFcm(user:String,pass:String,status:Int){
//        //check token
//        if fcmtoken == nil || enableRemoteNotification != true{
//            return
//        }
////        if oldno == newbean.trackNo{
////            self.updateToFCM(bean: newbean)
////        }else{
////            self.deleteDataToFCM(trackno: oldno)
////            self.addDataToFCM(bean: newbean)
////        }
//    }
    
    //MARK: - 增删改
    func addAmazonDataToFCM(user:String,pass:String,status: Int) {
        //check token
        if fcmtoken == nil || enableRemoteNotification != true{
            return
        }

        let data: AmazonUserData = AmazonUserData()
        data.a_user = user
        data.a_psd = pass
        data.a_status = status
        data.d_type = "I"
        data.d_token = fcmtoken!
        if let email = packtrack_user?.email{
            data.d_usermail = email
        }
        if let id = packtrack_user?.id{
            data.f_id = id
        }
        data.save()
    }
    
    func updateAmazonDataToFCM(user:String,pass:String,status:Int) {
        if fcmtoken == nil || enableRemoteNotification != true{
            return
        }
        //更新云端数据
        AmazonUserData.where(\AmazonUserData.a_user, isEqualTo: user)
//            .where(\PringData.d_token, isEqualTo: fcmtoken!)
            .get { (snapshot, error) in
                //                print(snapshot?.documents)
                if snapshot?.documents.count == 0{
                    self.addAmazonDataToFCM(user: user,pass:pass,status: status)
                    return
                }
                for document in (snapshot?.documents)!{
//                    print(document.data())
                    document.reference.updateData([
                        "a_psd": pass,
                        "a_status": status,
                        "d_usermail": packtrack_user?.email ?? "",
                        "d_token": fcmtoken ?? "",
                        "f_id": packtrack_user?.id ?? "",
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
    func deleteAmazonDataToFCM(user:String)   {
        if fcmtoken == nil || enableRemoteNotification != true{
            return
        }
        AmazonUserData.where(\AmazonUserData.a_user, isEqualTo: user)
//            .where(\PringData.d_token, isEqualTo: fcmtoken!)
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
