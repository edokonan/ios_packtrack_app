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
class AmazonUserData: Object {
    override open class var modelName: String {
        return "amazonuser"
    }
    override open class var path: String {
        return "packtrack/\(self.modelVersion)/\(self.modelName)"
    }
    var a_user: String = ""
    var a_psd: String = ""
    var a_status: Int = 0
    
    var f_id: String = "" //firebase user id
    
    var d_type: String = "" //devicetype
    var d_token: String = "" //devicetoken
    var d_usermail: String = "" //devicetoken
}





