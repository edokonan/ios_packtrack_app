//
//  UserManager.swift
//  packtrack
//
//  Created by ksymac on 2018/4/21.
//  Copyright © 2018年 ZHUKUI. All rights reserved.
//

import UIKit
import Firebase


let CloudDB_UserTable_Test = "TestUsers"
let CloudDB_UserTable = "users"
//let CloudDB_UserTable = "TestUsers"
class UserManager: NSObject {
    static let shared = UserManager()
    func getCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        weak var weak_self = self
        //get user
        Database.database().reference().child(CloudDB_UserTable).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                packtrack_user = MyUser(dictionary: dictionary)
                weak_self?.UpdataToVersion_1()
            }else{
                packtrack_user = nil
            }
        }, withCancel: nil)

    }
    func UpdataToVersion_1(){
        guard var currentuser = packtrack_user else {
            return
        }
        if currentuser.version > 0 {
            //同步到本地
            if !MyUserDefaults.shared.getPurchased_ADClose(){
                if currentuser.adclose == true{
                    MyUserDefaults.shared.setPurchased_ADClose(true)
                }
            }
            if currentuser.pro == true{
                MyUserDefaults.shared.setPurchased_ADClose(true)
            }

        }else{
            //出问题的用户的特别对应
            if currentuser.email == "test2@zhukui.com"
                || currentuser.email == "n.club.iwata@gmail.com"
            {
                MyUserDefaults.shared.setPurchased_ADClose(true)
            }
            sync_User_Purchased_ADClose()
        }
        #if FREE
        #else
        sync_User_pro()
        #endif

        
    }
    func sync_User_Purchased_ADClose(){
        guard var currentuser = packtrack_user else {
            return
        }
        if MyUserDefaults.shared.getPurchased_ADClose() &&
            currentuser.adclose == false {
            packtrack_user?.adclose = true
            var values: [String: AnyObject] = ["version": 1 as AnyObject,]
            values["adclose"] = true as AnyObject
            print(values)
            update_user(values)
        }
    }
    func sync_User_pro(){
        guard let currentuser = packtrack_user else {
            return
        }
        if MyUserDefaults.shared.getPurchased_ADClose() &&
            currentuser.pro == false {
            var values: [String: AnyObject] = ["version": 1 as AnyObject,]
            packtrack_user?.pro = true
            packtrack_user?.adclose = true
            values["adclose"] = true as AnyObject
            values["pro"] = true as AnyObject
            update_user(values)
        }
    }
    
    
    func update_user(_  values: [String: AnyObject]){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference()
        let usersReference = ref.child(CloudDB_UserTable).child(uid)
        weak var weak_self = self
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                return
            }else{
                print(ref)
            }
        })
    }
}
