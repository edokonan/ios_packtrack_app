//
//  DatabaseRef.swift
//  packtrack
//
//  Created by ksymac on 2017/11/13.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit
import Firebase

var packtrack_user : MyUser?
var cloudFile : NSURL?
let myCloudDB = CloudDBRef()
let key_backup_folder_name = "pt_bk"


class CloudDBRef: NSObject {

    //文件名的格式
    let File_Name_Format = "YYYYMMdd_HHmmss"
    
    //MARK: 根据UID，获取USER数据
    func fetchUser(withBlock:@escaping ()->()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        Database.database().reference().child(CloudDB_UserTable).child(uid)
            .observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                packtrack_user = MyUser(dictionary: dictionary)
                withBlock()
//                self.setupNavBarWithUser(user)
            }
        }, withCancel: nil)
        
        Database.database().reference().child(CloudDB_UserTable).child(uid).observe( .childChanged, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    packtrack_user = MyUser(dictionary: dictionary)
                    withBlock()
                    //                self.setupNavBarWithUser(user)
                }
            })
    }
    //MARK: 上传文件到DB，参数:uid,fileURL,fileName
    func uploadFileIntoDatabaseWithUID(_ uid: String,
                                       fileURL:URL?,
                                       fileName:String,
                                       successCompetion: (()->())?,
                                       failureCompetion: (()->())?){
//        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child(key_backup_folder_name)
                            .child(uid).child("\(fileName).json")
//        if let profileImage = UIImage(named: "nedstark"),
//            let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
//            storageRef.put(uploadData, metadata: nil, completion: {
       if let file = fileURL {
        storageRef.putFile(from: file, metadata: nil, completion: {
                (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let cloudFileURL = metadata?.downloadURL()?.absoluteString {
                    //更新用户数据
                    let values = [KEY_packtrack_backupFileUrl: cloudFileURL,
                                  KEY_packtrack_backupTime: fileName,
//                                  KEY_packtrack_Point: 10,
                                  ] as [String : Any]//"name": name, "email": email,
                    self.updateUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject],
                                                       successCompetion: successCompetion,
                                                       failureCompetion: failureCompetion)
                }
            })
        }
    }
    //更新USER的数据
    func updateUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject],
                                       successCompetion: (()->())?,
                                       failureCompetion: (()->())?
        ) {
        let ref = Database.database().reference()
        let usersReference = ref.child(CloudDB_UserTable).child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: {
            (err, ref) in
            if err != nil {
                print(err!)
                return
            }else{
                packtrack_user?.packtrack_backupFileUrl = values[KEY_packtrack_backupFileUrl] as? String
                packtrack_user?.packtrack_backup_time = values[KEY_packtrack_backupTime] as? String
//                packtrack_user?.packtrack_point = values[KEY_packtrack_Point] as? Int
                if let block = successCompetion{
                    block()
                }
            }
        })
    }
}
