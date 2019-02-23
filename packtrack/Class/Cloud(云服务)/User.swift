//
//  User.swift
//  gameofchats
//
//  Created by Brian Voong on 6/29/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

//备份在云上的数据的Key
let KEY_profileImageUrl = "prof_img"
let KEY_packtrack_backupFileUrl = "pt_file"
let KEY_packtrack_backupTime = "pt_time"
let KEY_packtrack_Point = "pt_p"

class MyUser: NSObject {
    
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    var packtrack_backupFileUrl: String?
    var packtrack_backup_time: String?
    var packtrack_point: Int?
    
    var version: Int = 0
    var adclose: Bool = false
    var pro: Bool = false
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary[KEY_profileImageUrl] as? String
        self.packtrack_backupFileUrl = dictionary[KEY_packtrack_backupFileUrl] as? String
        self.packtrack_backup_time = dictionary[KEY_packtrack_backupTime] as? String
        if let point =  dictionary[KEY_packtrack_Point]{
            self.packtrack_point = point as! Int
        }else{
            self.packtrack_point = 0
        }
        if let version =  dictionary["version"] as? Int{
            self.version = version
        }else{
            self.version = 0
        }
        if let adclose =  dictionary["adclose"] as? Bool{
            self.adclose = adclose
        }else{
            self.adclose = false
        }
        if let pro =  dictionary["pro"] as? Bool{
            self.pro = pro
        }else{
            self.pro = false
        }
    }
    func getPacktrackBackupTime() -> String?{
        if let time = packtrack_backup_time{
            //文件名的格式
            let File_Name_Format = "YYYYMMdd_HHmmss"
            //NSDateに変換
            if let date = DateUtils.dateFromString(string: time, format: "YYYYMMdd_HHmmss"){
                let str = DateUtils.stringFromDate(date: date, format: "yyyy年MM月dd日 HH時mm分")
                //"yyyy年MM月dd日 HH時mm分"
                return str
            }else{
                return ""
            }
        }
        return nil
    }
//    //生成文件名
//    func createFileNameWithDate()->String{
//        let formater = DateFormatter()
//        formater.dateFormat = File_Name_Format
//        let dateStr = formater.string(from: Date())
//        return dateStr
//    }
}
