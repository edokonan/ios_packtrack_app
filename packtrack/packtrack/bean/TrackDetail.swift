//
//  TrackDetail.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/12.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import Foundation

class TrackDetail:Codable {
    var rowID : Int = -1
    var id : Int = 0
    var trackNo: String = ""
    var detailNo: Int = 0
    var date: String = ""
    var status: String = ""
    var store: String = ""
    var detail: String = ""
    var insertDate: String = ""
    // イニシャライザ
    init(trackno: String, detailno: Int,date: String,
        status: String,store: String,detail:String) {
            self.trackNo = trackno
            self.detailNo = detailno
            self.date = date
            self.status = status
            self.store = store
            self.detail = detail
    }
    init() {
        
    }
}
