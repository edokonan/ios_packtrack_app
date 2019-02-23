//
//  TrackMain.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/12.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import Foundation

class TrackMain:Codable{
    var rowID : Int = -1
    var trackNo: String = ""
    var trackType: String = ""//1,2,3
    var typeName: String = ""//国際、見つからない等  //现状
    var networking: Bool = false
    var status: Int = 0     //doing
    var strStatus: String = ""
    var comment: String = ""
    var commentTitle: String = ""
    var haveUpdate: Bool = false
    var errorCode: Int = 0
    var errorMsg: String = ""
    var latestDate: String = ""
    var latestStatus: String = ""
    var latestStore: String = ""
    var latestDetail: String = ""
    var latestDetailNo: Int = -1
    var insertDate: String = ""
    var updateDate: String = ""
    
    var isADView: Bool = false
    
    
    //显示在当前Main视图的detail或者更新到filestore上
    func getNowStatus()->String{
        let strTemp = latestDate + latestStatus + latestDetail
        if(strTemp.isEmpty){
            return typeName.removeWhitespace()
        }else{
            var strtemp = latestDate
            if !latestStatus.isEmpty{
                strtemp += " " + latestStatus
            }
            if !latestDetail.isEmpty{
                strtemp += " " + latestDetail
            }
            return strtemp
        }
    }

    var detailList : Array<TrackDetail> = Array<TrackDetail>()
    // イニシャライザ
    init(no: String, type: String) {
        self.trackNo = no
        self.trackType = type
    }
    init() {
    }
}
/**
enum TrackMain_Status : String {
    case doing =  "追跡中"
    case over = "追跡完了"
    case all = "全ての"
    case del = "ゴミ箱"
    
    func getName() -> String {
        switch(self) {
        case .doing:
            return "追跡中"
        case .over:
            return "追跡完了"
        case .all:
            return "全ての"
        case .del:
            return "ゴミ箱"
        }
    }
    func getValue() -> Int {
        switch(self) {
        case .doing:
            return 0
        case .over:
            return 1
        case .all:
            return -99999
        case .del:
            return -1
        }
    }
}**/
