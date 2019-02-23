//
//  RMCache.swift
//  packtrack
//
//  Created by ksymac on 2019/02/15.
//  Copyright © 2019 ZHUKUI. All rights reserved.
//
import Foundation
import RealmSwift
import IceCream
import CloudKit

class RMCache: Object {
    @objc dynamic var id = NSUUID().uuidString
    
    @objc dynamic var key = ""
    @objc dynamic var ver = ""
    @objc dynamic var content = ""
    
    @objc dynamic var insertDate = ""
    @objc dynamic var updateDate = ""
    
    @objc dynamic var isDeleted = false
    override class func primaryKey() -> String? {
        return "key"
    }
}

extension RMCache: CKRecordConvertible {
}

extension RMCache: CKRecordRecoverable {
}
