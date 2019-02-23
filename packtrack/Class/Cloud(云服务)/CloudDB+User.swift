//
//  ViewController.swift
//  packtrack
//
//  Created by ksymac on 2017/11/29.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit
import Firebase

extension CloudDBRef {

    //MARK:- 更新用户的Point
    func AddPointWithUser(_ uid: String, addPoint: Int,
                          successCompetion: (()->())?,
                          failureCompetion: (()->())?)->Bool{
        
        let ref = Database.database().reference()
        let usersReference = ref.child(CloudDB_UserTable).child(uid)
        guard let oldPoint = packtrack_user?.packtrack_point else{
            return false
        }
        let newPoint = oldPoint + addPoint
        let values =  [KEY_packtrack_Point: newPoint,] as [String : Any?]
        usersReference.updateChildValues(values, withCompletionBlock: {
            (err, ref) in
            if err != nil {
                print(err!)
                return
            }else{
                packtrack_user?.packtrack_point = newPoint
                if let block = successCompetion{
                    block()
                }
            }
        })
        return false
    }
    //MARK: - 删除用户的备份文件
    func DelBakFilewithUser(_ uid: String,
                            successCompetion: (()->())?,
                            failureCompetion: (()->())?)->Bool{
        
        let ref = Database.database().reference()
        let usersReference = ref.child(CloudDB_UserTable).child(uid)
        let values = [KEY_packtrack_backupFileUrl: nil, KEY_packtrack_backupTime: nil,] as [String : Any?]
        usersReference.updateChildValues(values, withCompletionBlock: {
            (err, ref) in
            if err != nil {
                print(err!)
                return
            }else{
                let fireurl = packtrack_user?.packtrack_backupFileUrl
                packtrack_user?.packtrack_backupFileUrl = nil
                packtrack_user?.packtrack_backup_time = nil
                self.DelBakFileWityFileURL(fireurl!, successCompetion: {
                    
                }, failureCompetion: {
                    
                })
                if let block = successCompetion{
                    block()
                }
            }
        })
        return false
    }
    //MARK: 删除备份文件
    func DelBakFileWityFileURL(_ fireurl: String,
                 successCompetion: (()->())?,
                 failureCompetion: (()->())?){

        let spaceRef = Storage.storage().reference(forURL: fireurl)
        spaceRef.delete(completion: { (err) in
            if err != nil {
                print(err!)
                return
            }else{
                
            }
        })
    }
    
}
