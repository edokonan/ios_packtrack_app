//
//  Video.swift
//  Sample
//
//  Created by 1amageek on 2017/11/29.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import Foundation
import Pring
import FirebaseFirestore
import FirebaseStorage

@objcMembers
class PringData: Object {
    override open class var modelName: String {
        return "data"
    }
    override open class var path: String {
        return "packtrack/\(self.modelVersion)/\(self.modelName)"
    }
    
    var title: String = ""
    var comment: String = ""
    
    var trackNo: String = ""
    var trackType: String = ""//1,2,3
    
//    var typeName: String = ""//国際、見つからない等
//    var status: Int = 0     //doing
    var strStatus: String = ""
    
    var deli_over = false
    var cron_level = 1 //开始的level为1
    var err_level = 0 //0 什么都不做
    
    #if FREE
    var cron_group = 2 //开始的cron_group为2
    var is_pro = false
    #else
    var cron_group = 1 //开始的cron_group为1
    var is_pro = true
    #endif
    
    var d_type: String = "" //devicetype
    var d_token: String = "" //devicetoken
    var d_usermail: String = "" //devicetoken
}





