//
//  Video.swift
//  Sample
//
//  Created by 1amageek on 2017/11/29.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import Foundation
import Pring

@objcMembers
class PringUser: Object {

    @objc enum UserType: Int {
        case normal
        case gold
        case premium
    }
    
    dynamic var type: UserType = .normal
    dynamic var name: String?
    dynamic var device: String?
    dynamic var thumbnail: File?
    dynamic var isDeleted: Bool = false
    dynamic var deta: Set<String> = []
    
    dynamic var item: Item?
    
    dynamic var files: [File] = []
    
    let followers: ReferenceCollection<MsgUser> = []
    let friends: ReferenceCollection<MsgUser> = []
    let items: NestedCollection<Item> = []
    let group: Reference<Group> = Reference()
    let media: ReferenceCollection<Media> = []
}





