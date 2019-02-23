//
//  RMTrackStatus.swift
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
//    + "status INTEGER not null default 0,"//"status":.IntVal,
//    + "statusname text not null default '',"//"statusname":.StringVal,
//    + "indexno INTEGER not null default 0,"//"indexno":.IntVal,
//    + "insertDate text not null default '',"//"insertDate":.StringVal,
//    //"updateDate":.StringVal,
//    + "updateDate text not null default '');"
class RMTrackStatus: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var status = 0
    @objc dynamic var statusname = ""
    @objc dynamic var indexno = 0
    
    @objc dynamic var isDeleted = false
    @objc dynamic var insertDate:String = ""
    @objc dynamic var updateDate:String = ""
    
    @objc dynamic var createdAt:Date?
//    @objc dynamic var updatedAT:Date?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension RMTrackStatus: CKRecordConvertible {
    
}

extension RMTrackStatus: CKRecordRecoverable {
    
}
