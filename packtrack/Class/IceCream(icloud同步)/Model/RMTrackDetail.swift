//
//  RMTrackDetail.swift
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
//    + "trackNo text not null default '',"//"trackNo":.StringVal,
//    + "detailNo INTEGER not null default 0,"//"detailNo":.IntVal,
//    + "date text not null default '',"//"date":.StringVal,
//    + "status text not null default '',"//"status":.StringVal,
//    + "store text not null default '',"//"store":.StringVal,
//    + "detail text not null default '',"//"detail":.StringVal,
//    + "insertDate text not null default '');"
class RMTrackDetail: Object {
//    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var id = ""
    @objc dynamic var trackNO = ""
    @objc dynamic var detailNo = 0
    @objc dynamic var date = ""
    @objc dynamic var status = ""
    @objc dynamic var store = ""
    @objc dynamic var detail = ""
    
    @objc dynamic var isDeleted = false
    @objc dynamic var insertDate:String?
    
//    @objc dynamic var insertDate:Date?
//    @objc dynamic var updateDate:Date?
    // Relationships usage in Realm: https://realm.io/docs/swift/latest/#relationships
//    @objc dynamic var owner: RMTrackMain? // to-one relationships must be optional

    override class func primaryKey() -> String? {
        return "id"
    }
    class func getPrimaryKey(trackNO:String, detailNo:Int) -> String {
        return NSString.init(format: "%@_%d", trackNO,detailNo) as String
    }
}

extension RMTrackDetail: CKRecordConvertible {
}

extension RMTrackDetail: CKRecordRecoverable {
}
