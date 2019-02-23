//
//  RMTrackMain.swift
//  packtrack
//
//  Created by ksymac on 2019/2/11.
//  Copyright © 2019年 ZHUKUI. All rights reserved.
//
import Foundation
import RealmSwift
import IceCream
import CloudKit

//+ "ID integer primary key autoIncrement,"
//    + "trackNO text not null default '',"//"trackNO":.StringVal,
//    + "trackType text not null default '',"//"trackType":.StringVal,
//    + "typeName text not null default '',"//"typeName":.StringVal,
//    + "networking BOOL not null default false,"//"networking":.BoolVal,
//    + "status INTEGER not null default 0,"//"status":.IntVal,
//    + "comment text not null default '',"//"comment":.StringVal,
//    + "commentTitle text not null default '',"//"commentTitle":.StringVal, ..not null default ''
//    + "haveUpdate BOOL not null default false,"//"haveUpdate":.BoolVal,
//    + "errorCode INTEGER not null default 0,"//"errorCode":.IntVal,
//    + "errorMsg text not null default '',"//"errorMsg":.StringVal,
//    + "latestDate text not null default '',"//"latestDate":.StringVal,
//    + "latestStatus text not null default '',"//"latestStatus":.StringVal,
//    + "latestStore text not null default '',"//"latestStore":.StringVal,
//    + "latestDetail text not null default '',"//"latestDetail":.StringVal,
//    + "latestDetailNo INTEGER not null default 0,"//"latestDetailNo":.IntVal,
//    + "insertDate text not null default '',"//"insertDate":.StringVal,
//    + "updateDate text not null default '');"

class RMTrackMain: Object {
    @objc dynamic var id = NSUUID().uuidString
    
    @objc dynamic var trackNo = ""
    @objc dynamic var trackType = ""
    @objc dynamic var typeName = ""
    @objc dynamic var status = 0

    @objc dynamic var comment = ""
    @objc dynamic var commentTitle = ""
    @objc dynamic var haveUpdate = false
    
    @objc dynamic var latestDate = ""
    @objc dynamic var latestStatus = ""
    @objc dynamic var latestStore = ""
    @objc dynamic var latestDetail = ""
    @objc dynamic var latestDetailNo = -1
    
    @objc dynamic var isDeleted = false
    @objc dynamic var insertDate = ""
    @objc dynamic var updateDate = ""
    
    
    override class func primaryKey() -> String? {
        return "trackNo"
    }
}

extension RMTrackMain: CKRecordConvertible {
}

extension RMTrackMain: CKRecordRecoverable {
}
