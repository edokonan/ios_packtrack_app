//
//  ComFunc.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/14.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import UIKit
import SwiftyJSON

extension ComFunc {
    //json 解析
    func parseJson(_ strTrackType : String,json : JSON) -> TrackMain {
        var trackMain = TrackMain()
        //print(json)
        switch strTrackType {
          case Company_jppost:
            let emsdata = json["emsdata"]
            if emsdata == nil{
                break
            }
            //var trackMain : TrackMain = TrackMain(no: self.strTrackNo, type: self.strTrackType)
            trackMain.typeName = emsdata["typename"].string!
            trackMain.trackNo = emsdata["strno"].string!
            trackMain.trackType = strTrackType
            
            let statusList: Array<JSON> = json["emsdata"]["statusList"].arrayValue
            
            for i in 0 ..< statusList.count {
                let subJson: JSON  = statusList[i]
                let detail : TrackDetail = TrackDetail()
                
                detail.date = subJson["time_str"].string!//时间
                detail.status = subJson["status_str"].string!//状态
                detail.detail = subJson["detail_str"].string!//店铺
                detail.detailNo = i
                detail.store = ""
                detail.trackNo = trackMain.trackNo
                detail.insertDate = ""
                
                trackMain.detailList.insert(detail, at: 0)
                
                if(i == (statusList.count-1)){
                    trackMain.latestDetailNo = i
                    trackMain.latestDetail = detail.detail
                    trackMain.latestStatus = detail.status
                    trackMain.latestStore = detail.store
                    trackMain.latestDate = detail.date
                }
            }
            break
          case Company_yamato:
            let emsdata = json["yamatodata"]
            if emsdata == nil{
                break
            }
            //print(emsdata)
            trackMain.trackNo = emsdata["slipNo"].string!
            trackMain.trackType = strTrackType
            trackMain.typeName = emsdata["itemType"].string!
            //trackMain.strStatus =
            if(trackMain.typeName.isEmpty){
                trackMain.typeName = emsdata["status"].string!
            }
            
            let statusList: Array<JSON> = json["yamatodata"]["statusList"].arrayValue
            
            for i in 0 ..< statusList.count {
                let subJson: JSON  = statusList[i]
                let detail : TrackDetail = TrackDetail()
                detail.date = subJson["date"].string!
                if !subJson["time"].string!.isEmpty{
                    detail.date += " " + subJson["time"].string!
                }
                detail.status = subJson["status"].string!
//                detail.detail = subJson["placeName"].string! + subJson["placeCode"].string!
                detail.detail = subJson["placeName"].string!
                detail.store = ""
                detail.detailNo = i
                detail.trackNo = trackMain.trackNo
                detail.insertDate = ""
                
                trackMain.detailList.insert(detail, at: 0)
                
                if(i == (statusList.count-1)){
                    trackMain.latestDetailNo = i
                    trackMain.latestDetail = detail.detail
                    trackMain.latestStatus = detail.status
                    trackMain.latestStore = detail.store
                    trackMain.latestDate = detail.date
                }
            }
            break
          case Company_sagawa:
            let emsdata = json["sagawadata"]
            if emsdata == nil{
                break
            }
            //var trackMain : TrackMain = TrackMain(no: self.strTrackNo, type: self.strTrackType)
            trackMain.typeName = emsdata["detail"].string!
            trackMain.trackNo = emsdata["no"].string!
            trackMain.trackType = strTrackType
            let statusList: Array<JSON> = json["sagawadata"]["statusList"].arrayValue
            
            for i in 0 ..< statusList.count {
                let subJson: JSON  = statusList[i]
                let detail : TrackDetail = TrackDetail()
                detail.status = subJson["detail"].string!
                detail.date = subJson["date"].string!
                if !subJson["time"].string!.isEmpty{
                    detail.date += " " + subJson["time"].string!
                }
                detail.detail = subJson["store"].string!.removeWhitespace2()
                detail.detailNo = i
                detail.store = ""
                //if(i == 0){
                //    detail.status = emsdata["sendplace"].string!
                //}
                //let stemp = emsdata["delivery_place"].string!
                //if((!stemp.isEmpty) && (i == (statusList.count-1))){
                //    detail.status = emsdata["delivery_place"].string!
                //}
                detail.trackNo = trackMain.trackNo
                detail.insertDate = ""
                
                trackMain.detailList.insert(detail, at: 0)
                
                if(i == (statusList.count-1)){
                    trackMain.latestDetailNo = i
                    trackMain.latestDetail = detail.detail
                    trackMain.latestStatus = detail.status
                    trackMain.latestStore = detail.store
                    trackMain.latestDate = detail.date
                }
            }
            //detail view typename
            if(!trackMain.latestDetail.isEmpty){
                trackMain.typeName = trackMain.latestStatus
            }
            break
          case Company_tmg:
            let tmgdata = json["tmgdata"]
            if tmgdata == nil{
                break
            }
            print(tmgdata)
            trackMain.typeName = tmgdata["status"].string!
            trackMain.trackNo = tmgdata["itemNo"].string!
            
            let statusList: Array<JSON> = tmgdata["statusList"].arrayValue
            for i in 0 ..< statusList.count {
                let subJson: JSON  = statusList[i]
                let detail : TrackDetail = TrackDetail()
                detail.status = subJson["status"].string!
                detail.date = subJson["datetime"].string!
                detail.detail = subJson["placeName"].string!.removeWhitespace2()
                detail.detailNo = i
                detail.trackNo = trackMain.trackNo
                trackMain.detailList.insert(detail, at: 0)
                
                if(i == (statusList.count-1)){
                    trackMain.latestDetailNo = i
                    trackMain.latestDetail = detail.detail
                    trackMain.latestStatus = detail.status
                    trackMain.latestStore = detail.store
                    trackMain.latestDate = detail.date
                }
            }
            break
            
            
        case Company_seino:
            let data = json["seinodata"]
            if data == nil{
                break
            }
            print(data)
            
            trackMain.typeName = data["status"].string! + "\n" + data["deliveinfo"].string!
            trackMain.trackNo = data["itemNo"].string!
            let statusList: Array<JSON> = data["statusList"].arrayValue
            for i in 0 ..< statusList.count {
                let subJson: JSON  = statusList[i]
                let detail : TrackDetail = TrackDetail()
                detail.status = subJson["status"].string!
                detail.date = subJson["datetime"].string!
                detail.detail = subJson["placeName"].string!.removeWhitespace2()
                detail.detailNo = i
                detail.trackNo = trackMain.trackNo
                trackMain.detailList.insert(detail, at: 0)
                
                if(i == (statusList.count-1)){
                    trackMain.latestDetailNo = i
                    trackMain.latestDetail = detail.detail
                    trackMain.latestStatus = detail.status
                    trackMain.latestStore = detail.store
                    trackMain.latestDate = detail.date
                }
            }
            break
            
          default:
            break
        }
        
        return trackMain
    }
    
}
