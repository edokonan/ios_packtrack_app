//
//  TrackStatus.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/10/03.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import Foundation

class TrackStatus : Codable{
    var rowID : Int = -1
    
    var status: Int = -999
    var statusname: String = ""//
    var indexno: Int = 0
    var count: Int = 0
    
    var insertDate: String = ""
    var updateDate: String = ""
}
