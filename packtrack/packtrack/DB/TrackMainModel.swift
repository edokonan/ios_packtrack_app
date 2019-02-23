//
//  TrackMainModel.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/12.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import Foundation


class TrackMainModel {
    
    static let shared = TrackMainModel()
    let create_sql =
        "create table if not exists TrackMainTable_001("
            + "ID integer primary key autoIncrement,"
            + "trackNO text not null default '',"//"trackNO":.StringVal,
            + "trackType text not null default '',"//"trackType":.StringVal,
            + "typeName text not null default '',"//"typeName":.StringVal,
            + "networking BOOL not null default false,"//"networking":.BoolVal,
            + "status INTEGER not null default 0,"//"status":.IntVal,
            + "comment text not null default '',"//"comment":.StringVal,
            + "commentTitle text not null default '',"//"commentTitle":.StringVal, ..not null default ''
            + "haveUpdate BOOL not null default false,"//"haveUpdate":.BoolVal,
            + "errorCode INTEGER not null default 0,"//"errorCode":.IntVal,
            + "errorMsg text not null default '',"//"errorMsg":.StringVal,
            + "latestDate text not null default '',"//"latestDate":.StringVal,
            + "latestStatus text not null default '',"//"latestStatus":.StringVal,
            + "latestStore text not null default '',"//"latestStore":.StringVal,
            + "latestDetail text not null default '',"//"latestDetail":.StringVal,
            + "latestDetailNo INTEGER not null default 0,"//"latestDetailNo":.IntVal,
            + "insertDate text not null default '',"//"insertDate":.StringVal,
            //"updateDate":.StringVal,
            + "updateDate text not null default '');"
    //            // TrackNoListTable_001を作成,その際"id"は自動生成 dataはStringVal = string型
    //            if let err = SD.createTable(table: "TrackMainTable_001",
    //                withColumnNamesAndTypes: [
    //                    "trackNO":.StringVal,
    //                    "trackType":.StringVal,
    //                    "typeName":.StringVal,
    //                    "networking":.BoolVal,
    //                    "status":.IntVal,
    //                    "comment":.StringVal,
    //                    "commentTitle":.StringVal,
    //                    "haveUpdate":.BoolVal,
    //                    "errorCode":.IntVal,
    //                    "errorMsg":.StringVal,
    //                    "latestDate":.StringVal,
    //                    "latestStatus":.StringVal,
    //                    "latestStore":.StringVal,
    //                    "latestDetail":.StringVal,
    //                    "latestDetailNo":.IntVal,
    //                    "insertDate":.StringVal,
    //                    "updateDate":.StringVal,
    //                ]) {
    //    CREATE TABLE TrackMainTable_001 (ID INTEGER PRIMARY KEY AUTOINCREMENT, "updateDate" TEXT, "commentTitle" TEXT, "haveUpdate" BOOLEAN, "latestDetail" TEXT, "latestDetailNo" INTEGER, "comment" TEXT, "insertDate" TEXT, "latestStore" TEXT, "trackNO" TEXT, "errorCode" INTEGER, "latestDate" TEXT, "latestStatus" TEXT, "networking" BOOLEAN, "typeName" TEXT, "status" INTEGER, "errorMsg" TEXT, "trackType" TEXT)
    // テーブル作成
    init() {
        let (tb, err) = SD.existingTables()
        // TrackNoListTable_001が無ければ
        if !tb.contains( "TrackMainTable_001") {
            if let err = SD.createTable(sql: create_sql){
                debug_print("--DB: create TrackMainTable_001 error---")
            } else {
                debug_print("--DB: create TrackMainTable_001---")
//                UserDefaults.standard.set(14, forKey: "TrackMainModel_Version")
            }
        }
        if let i: Int = UserDefaults.standard.integer(forKey: "TrackMainModel_Version"){
            if(i < 15){
                //  if let _ = SD.addColumns(("TrackMainTable_001") as! String, columnNamesAndTypes: ["commentTitle":.StringVal]){
                //                        UserDefaults.standard.set(14, forKey: "TrackMainModel_Version")
                //                    }else{
                //                        UserDefaults.standard.set(14, forKey: "TrackMainModel_Version")
                //                    }
                let addcol_sql = "alter table TrackMainTable_001 add column commentTitle text not null default '';"
                if let err = SD.executeChange( sqlStr:addcol_sql, withArgs: []){
                    print(err)
                }else{
                    debug_print("--DB: update ok---")
                    UserDefaults.standard.set(15, forKey: "TrackMainModel_Version")
                }
            }
            if(i < 16){
                let updatecol_sql = "update TrackMainTable_001 set commentTitle = '' where commentTitle is null;"
                if let err = SD.executeChange( sqlStr:updatecol_sql, withArgs: []){
                    print(err)
                }else{
                    debug_print("--DB: update ok---")
                    UserDefaults.standard.set(16, forKey: "TrackMainModel_Version")
                }
            }
        }
    }
    
    /**
    INSERT文（追加）
    var add = 自作databaseクラス.add("3urprise") これでdatabaseに"3urprise"と追加される
    */
    func add(_ trackmain:TrackMain , restoreflg:Bool = false) -> String {
        var result:String? = nil
        if restoreflg == false {
            trackmain.insertDate = ComFunc.shared.getNowDateStr()
            trackmain.updateDate = ComFunc.shared.getNowDateStr()
        }
        if let err = SD.executeChange(sqlStr: "INSERT INTO TrackMainTable_001 (trackNO,trackType,typeName,networking,status, comment,commentTitle,haveUpdate,errorCode,errorMsg,latestDate,latestStatus,latestStore,latestDetail,latestDetailNo,insertDate,updateDate) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
            withArgs: [trackmain.trackNo as AnyObject,trackmain.trackType as AnyObject,trackmain.typeName as AnyObject,trackmain.networking as AnyObject,trackmain.status as AnyObject,trackmain.comment as AnyObject,trackmain.commentTitle as AnyObject,trackmain.haveUpdate as AnyObject,trackmain.errorCode as AnyObject,trackmain.errorMsg as AnyObject,trackmain.latestDate as AnyObject,trackmain.latestStatus as AnyObject,trackmain.latestStore as AnyObject,trackmain.latestDetail as AnyObject,trackmain.latestDetailNo as AnyObject,trackmain.insertDate as AnyObject,trackmain.updateDate as AnyObject,]) {
            // there was an error during the insert as AnyObject as AnyObject, handle it here
        } else {
            // no error, the row was inserted successfully
            // lastInsertedRowID = 直近の INSERT 文でデータベースに追加された行の ID を返す
            let (id, err) = SD.lastInsertedRowID()
            if err != nil {
                // err
                result="-1"
            }else{
                // ok
                result = String(id)
            }
        }
        return result!
    }
    
    func update(_ trackmain:TrackMain,restoreflg:Bool = false,onlyUpdateStatus:Bool = false) -> Bool {
        var result:Bool? = false
        if restoreflg == false {
            trackmain.updateDate = ComFunc().getNowDateStr()
        }
        if let err = SD.executeChange(sqlStr: "UPDATE TrackMainTable_001 set trackType=?,typeName=?,networking=?,status=?, comment=?,commentTitle=?,haveUpdate=?,errorCode=?,errorMsg=?,latestDate=?,latestStatus=?,latestStore=?,latestDetail=?,latestDetailNo=?,updateDate=? where trackNO=?",
            withArgs: [trackmain.trackType ,
                       trackmain.typeName ,trackmain.networking as AnyObject,trackmain.status as AnyObject,trackmain.comment as AnyObject,trackmain.commentTitle as AnyObject,trackmain.haveUpdate as AnyObject,trackmain.errorCode as AnyObject,trackmain.errorMsg as AnyObject,trackmain.latestDate as AnyObject,trackmain.latestStatus as AnyObject,trackmain.latestStore as AnyObject,trackmain.latestDetail as AnyObject,trackmain.latestDetailNo as AnyObject,trackmain.updateDate as AnyObject,trackmain.trackNo as AnyObject,]) {
                // there was an error during the insert, handle it here
        } else {
            // no error, the row was inserted successfully
            // lastInsertedRowID = 直近の INSERT 文でデータベースに追加された行の ID を返す
            let (id, err) = SD.lastInsertedRowID()
            if err != nil {
                // err
                result=false
            }else{
                // ok
                result=true
                
                //更新云端数据
                if(!onlyUpdateStatus){
                    PringManager.shared.updateToFCM(bean: trackmain)
                }
            }
        }
        return result!
    }
    func updateByID(_ trackmain:TrackMain) -> Bool {
        var result:Bool? = false
        
        trackmain.updateDate = ComFunc().getNowDateStr()
        
        if let err = SD.executeChange(sqlStr: "UPDATE TrackMainTable_001 set trackNO=?,trackType=?,typeName=?,networking=?,status=?, comment=?,commentTitle=?,haveUpdate=?,errorCode=?,errorMsg=?,latestDate=?,latestStatus=?,latestStore=?,latestDetail=?,latestDetailNo=?,updateDate=? where ID=?",
            withArgs: [trackmain.trackNo as AnyObject,trackmain.trackType as AnyObject,trackmain.typeName as AnyObject,trackmain.networking as AnyObject,trackmain.status as AnyObject,trackmain.comment as AnyObject,trackmain.commentTitle as AnyObject,trackmain.haveUpdate as AnyObject,trackmain.errorCode as AnyObject,trackmain.errorMsg as AnyObject,trackmain.latestDate as AnyObject as AnyObject,trackmain.latestStatus as AnyObject as AnyObject,trackmain.latestStore as AnyObject as AnyObject,trackmain.latestDetail as AnyObject as AnyObject,trackmain.latestDetailNo as AnyObject as AnyObject,trackmain.updateDate as AnyObject as AnyObject,trackmain.rowID as AnyObject as AnyObject,]) {
                // there was an error during the insert, handle it here
        } else {
            // no error, the row was inserted successfully
            // lastInsertedRowID = 直近の INSERT 文でデータベースに追加された行の ID を返す
            let (id, err) = SD.lastInsertedRowID()
            if err != nil {
                // err
                result=false
            }else{
                // ok
                result=true
            }
        }
        return result!
    }
    
    func updateStatus(_ trackmain:TrackMain) -> Bool {
        var result:Bool? = false
        trackmain.updateDate = ComFunc().getNowDateStr()
        if let err = SD.executeChange(sqlStr: "UPDATE TrackMainTable_001 set trackType=?,typeName=?,networking=?,status=?, comment=?,commentTitle=?,haveUpdate=?,errorCode=?,errorMsg=?,latestDate=?,latestStatus=?,latestStore=?,latestDetail=?,latestDetailNo=?,updateDate=? where trackNO=?",
            withArgs: [trackmain.trackType as AnyObject,trackmain.typeName as AnyObject,trackmain.networking as AnyObject,trackmain.status as AnyObject,trackmain.comment as AnyObject,trackmain.commentTitle as AnyObject,trackmain.haveUpdate as AnyObject,trackmain.errorCode as AnyObject,trackmain.errorMsg as AnyObject,trackmain.latestDate as AnyObject,trackmain.latestStatus as AnyObject,trackmain.latestStore as AnyObject,trackmain.latestDetail as AnyObject,trackmain.latestDetailNo as AnyObject,trackmain.updateDate as AnyObject,trackmain.trackNo as AnyObject,]) {
                // there was an error during the insert, handle it here
        } else {
            // no error, the row was inserted successfully
            // lastInsertedRowID = 直近の INSERT 文でデータベースに追加された行の ID を返す
            let (id, err) = SD.lastInsertedRowID()
            if err != nil {
                // err
                result=false
            }else{
                // ok
                result=true
            }
        }
        return result!
    }
    func setReaded(_ strTrackNo: String) -> Bool {
        var result:Bool? = false
        
        if let err = SD.executeChange(sqlStr: "UPDATE TrackMainTable_001 set haveUpdate=? where trackNO=?",
            withArgs: [false ,strTrackNo]) {
                // there was an error during the insert, handle it here
        } else {
            // no error, the row was inserted successfully
            // lastInsertedRowID = 直近の INSERT 文でデータベースに追加された行の ID を返す
            let (id, err) = SD.lastInsertedRowID()
            if err != nil {
                // err
                result=false
            }else{
                // ok
                result=true
            }
        }
        return result!
    }
    /**
    DELETE文
    var del = 自作databaseクラス.delete(Int) これでテーブルのID削除
    */
    func delete(_ id:Int, trackno:String) -> Bool {
        if let err = SD.executeChange(sqlStr: "DELETE FROM TrackMainTable_001 WHERE ID = ?", withArgs: [id as AnyObject]) {
            // there was an error during the insert, handle it here
            return false
        } else {
            //更新云端数据
            PringManager.shared.deleteDataToFCM(trackno: trackno)
            // no error, the row was inserted successfully
            return true
        }
    }
    
    /**
    SELECT文
    var selects = 自作databaseクラス.getAll() これでNSMutableArray型の内容が取得出来る
    */
    func getAll(allstatus : Bool = false) -> Array<TrackMain> {
        var result = Array<TrackMain>()
        // 新しい番号から取得する場合は "SELECT * FROM TrackNoListTable_001 ORDER BY ID DESC" を使う
        var SQL = "SELECT * FROM TrackMainTable_001 WHERE status >= 0 ORDER BY ID DESC"
        if(allstatus == true){
            SQL = "SELECT * FROM TrackMainTable_001 ORDER BY ID DESC"
        }
        let (resultSet, err) = SD.executeQuery(sqlStr: SQL)
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]?.asInt() {
                    let trackmain : TrackMain = TrackMain()
                    
                    trackmain.rowID = id
                    let trackNo = row["trackNO"]?.asString()!
                    let trackType = (row["trackType"]?.asString()!)!
                    let typeName = row["typeName"]?.asString()!
                    let networking = row["networking"]?.asBool()!
                    let status = row["status"]?.asInt()!
                    let comment = row["comment"]?.asString()!
                
                    var commentTitle : String = ""
                    if let row_commentTitle = row["commentTitle"]{
                        if let x = row_commentTitle.asString() {
                            commentTitle = x
                        } else {
//                            print("value is nil")
                        }
                    }
                    
                    let haveUpdate = row["haveUpdate"]?.asBool()!
                    let errorCode = row["errorCode"]?.asInt()!
                    let errorMsg = row["errorMsg"]?.asString()!
                    let latestDate = row["latestDate"]?.asString()!
                    let latestStatus = row["latestStatus"]?.asString()!
                    let latestStore = row["latestStore"]?.asString()!
                    let latestDetail = row["latestDetail"]?.asString()!
                    let latestDetailNo = row["latestDetailNo"]?.asInt()!
                    let insertDate = row["insertDate"]?.asString()!
                    let updateDate = row["updateDate"]?.asString()!
                    
                    trackmain.trackNo = trackNo!
                    trackmain.trackType = trackType
                    trackmain.typeName = typeName!
                    trackmain.networking = networking!
                    trackmain.status = status!
                    trackmain.comment = comment!
                    trackmain.commentTitle = commentTitle
                    trackmain.haveUpdate = haveUpdate!
                    trackmain.errorCode = errorCode!
                    trackmain.errorMsg = errorMsg!
                    trackmain.latestDate = latestDate!
                    trackmain.latestStatus = latestStatus!
                    trackmain.latestStore = latestStore!
                    trackmain.latestDetail = latestDetail!
                    trackmain.latestDetailNo = latestDetailNo!
                    trackmain.insertDate = insertDate!
                    trackmain.updateDate = updateDate!
                    
                    result.append(trackmain)
                }
            }
        }
        return result
    }
    
    func getCountByStatus(_ intStatus : Int) -> Int {
        //var strSQL : String
        if(intStatus == ComFunc.TrackList_all){
            let strSQL = "SELECT count(*) FROM TrackMainTable_001 WHERE status >= 0  ORDER BY ID DESC"
            let (resultSet, err) = SD.executeQuery(sqlStr: strSQL )
            if err != nil {
                return 0;
            } else {
                var nRows : Int = 0
                for row in resultSet {
//                    let x = row["count(*)"]
                    nRows = (row["count(*)"]?.asInt()!)!
                }
                return nRows
            }
        }else{
            let strSQL = "SELECT count(*) FROM TrackMainTable_001 WHERE status = ?  ORDER BY ID DESC"
            let (resultSet, err) = SD.executeQuery(sqlStr: strSQL , withArgs: [intStatus as AnyObject])
            if err != nil {
                return 0;
            } else {
                var nRows : Int = 0
                for row in resultSet {
                    nRows = (row["count(*)"]?.asInt()!)!
                }
                return nRows
            }
        }
    }
    
    func getAllByStatus(_ intStatus : Int) -> Array<TrackMain> {
        var result = Array<TrackMain>()
        // 
        let strSQL : String = "SELECT * FROM TrackMainTable_001 WHERE status = ?  ORDER BY ID DESC"
        //let temp = TrackMainTable_Status()?.rawValue(intStatus)
        /**let temp = TrackMainTable_Status(rawValue: intStatus)
        if(temp == TrackMainTable_Status.all){
            strSQL = "SELECT * FROM TrackMainTable_001 WHERE status >= 0  ORDER BY ID DESC"
        }else{
            
            strSQL = "SELECT * FROM TrackMainTable_001 WHERE status = ?  ORDER BY ID DESC"
        }**/
        let (resultSet, err) = SD.executeQuery(sqlStr: strSQL , withArgs: [intStatus as AnyObject ])
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]?.asInt() {
                    let trackmain : TrackMain = TrackMain()
                    
                    trackmain.rowID = id
                    let trackNo = row["trackNO"]?.asString()!
                    let trackType = (row["trackType"]?.asString()!)!
                    let typeName = row["typeName"]?.asString()!
                    let networking = row["networking"]?.asBool()!
                    let status = row["status"]?.asInt()!
                    let comment = row["comment"]?.asString()!
                    
                    var commentTitle : String = ""
                    if let row_commentTitle = row["commentTitle"]{
                        if let x = row_commentTitle.asString() {
                            commentTitle = x
                        } else {
                             print("value is nil")
                        }
                    }
                    let haveUpdate = row["haveUpdate"]?.asBool()!
                    let errorCode = row["errorCode"]?.asInt()!
                    let errorMsg = row["errorMsg"]?.asString()!
                    let latestDate = row["latestDate"]?.asString()!
                    let latestStatus = row["latestStatus"]?.asString()!
                    let latestStore = row["latestStore"]?.asString()!
                    let latestDetail = row["latestDetail"]?.asString()!
                    let latestDetailNo = row["latestDetailNo"]?.asInt()!
                    let insertDate = row["insertDate"]?.asString()!
                    let updateDate = row["updateDate"]?.asString()!
                    
                    trackmain.trackNo = trackNo!
                    trackmain.trackType = trackType
                    trackmain.typeName = typeName!
                    trackmain.networking = networking!
                    trackmain.status = status!
                    trackmain.comment = comment!
                    trackmain.commentTitle = commentTitle
                    trackmain.haveUpdate = haveUpdate!
                    trackmain.errorCode = errorCode!
                    trackmain.errorMsg = errorMsg!
                    trackmain.latestDate = latestDate!
                    trackmain.latestStatus = latestStatus!
                    trackmain.latestStore = latestStore!
                    trackmain.latestDetail = latestDetail!
                    trackmain.latestDetailNo = latestDetailNo!
                    trackmain.insertDate = insertDate!
                    trackmain.updateDate = updateDate!
                    
                    result.append(trackmain)
                }
            }
        }
        return result
    }
    
    func getAllByTrackNo(_ trackNo:String) -> TrackMain? {
        var result:TrackMain? = nil
        // 新しい番号から取得する場合は "SELECT * FROM TrackNoListTable_001 ORDER BY ID DESC" を使う
        let (resultSet, err) = SD.executeQuery(sqlStr: "SELECT * FROM TrackMainTable_001 WHERE trackNO = ?  ORDER BY ID DESC", withArgs: [trackNo as AnyObject])
        if err != nil {
            return nil
        } else {
            for row in resultSet {
                if let id = row["ID"]?.asInt() {
                    let trackmain : TrackMain = TrackMain()
                    
                    trackmain.rowID = id
                    let trackNo = row["trackNO"]?.asString()!
                    let trackType = (row["trackType"]?.asString()!)!
                    let typeName = row["typeName"]?.asString()!
                    let networking = row["networking"]?.asBool()!
                    let status = row["status"]?.asInt()!
                    let comment = row["comment"]?.asString()!
                    var commentTitle : String = ""
                    if let row_commentTitle = row["commentTitle"]{
                        if let x = row_commentTitle.asString() {
                            commentTitle = x
                        } else {
                            print("value is nil")
                        }
                    }
                    let haveUpdate = row["haveUpdate"]?.asBool()!
                    let errorCode = row["errorCode"]?.asInt()!
                    let errorMsg = row["errorMsg"]?.asString()!
                    let latestDate = row["latestDate"]?.asString()!
                    let latestStatus = row["latestStatus"]?.asString()!
                    let latestStore = row["latestStore"]?.asString()!
                    let latestDetail = row["latestDetail"]?.asString()!
                    let latestDetailNo = row["latestDetailNo"]?.asInt()!
                    let insertDate = row["insertDate"]?.asString()!
                    let updateDate = row["updateDate"]?.asString()!
                    
                    trackmain.trackNo = trackNo!
                    trackmain.trackType = trackType
                    trackmain.typeName = typeName!
                    trackmain.networking = networking!
                    trackmain.status = status!
                    trackmain.comment = comment!
                    trackmain.commentTitle = commentTitle
                    trackmain.haveUpdate = haveUpdate!
                    trackmain.errorCode = errorCode!
                    trackmain.errorMsg = errorMsg!
                    trackmain.latestDate = latestDate!
                    trackmain.latestStatus = latestStatus!
                    trackmain.latestStore = latestStore!
                    trackmain.latestDetail = latestDetail!
                    trackmain.latestDetailNo = latestDetailNo!
                    trackmain.insertDate = insertDate!
                    trackmain.updateDate = updateDate!
                    
                    result = trackmain
                }
            }
        }
        return result
    }
    
    //MARK: - retore   如果有的话，删除有的明细数据
    func retoreData( datas : Array<TrackMain> , trackdetail: TrackDetailModel) -> Bool {
//        let trackdetail = TrackDetailModel()
        for data in datas{
//            getAllByStatus(<#T##intStatus: Int##Int#>)
            if let trackmain = getAllByTrackNo(data.trackNo){
                self.update(data,restoreflg: true)
                trackdetail.deleteByTrackNo(data.trackNo)
            }else{
                self.add(data,restoreflg: true)
            }
        }
        return true
    }
    //MARK: - delete all
    func clearDB() -> Bool{
        if let err = SD.executeChange(sqlStr: "DELETE FROM TrackMainTable_001 ", withArgs: []) {
            return false
        } else {
            return true
        }
    }
}
