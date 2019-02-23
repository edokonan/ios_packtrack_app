//
//  TrackMainModel.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/12.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import Foundation

class TrackStatusModel {
    static let shared = TrackStatusModel()
    
    let tablename = "TrackStatusTable_001"
    let create_sql =
        "create table if not exists TrackStatusTable_001("
            + "ID integer primary key autoIncrement,"
            + "status INTEGER not null default 0,"//"status":.IntVal,
            + "statusname text not null default '',"//"statusname":.StringVal,
            + "indexno INTEGER not null default 0,"//"indexno":.IntVal,
            + "insertDate text not null default '',"//"insertDate":.StringVal,
            //"updateDate":.StringVal,
            + "updateDate text not null default '');"
//CREATE TABLE TrackStatusTable_001 (ID INTEGER PRIMARY KEY AUTOINCREMENT, "indexno" INTEGER, "insertDate" TEXT, "updateDate" TEXT, "statusname" TEXT, "status" INTEGER)
    
    // テーブル作成
    init() {
        let (tb, err) = SD.existingTables()
        // TrackNoListTable_001が無ければ
        if !tb.contains(tablename) {
            if let err = SD.createTable(sql: create_sql){
                debug_print("--DB: create TrackStatusTable_001 error---")
            } else {
                debug_print("--DB: create TrackStatusTable_001---")
            }
        }
    }
    let trackMainModel = TrackMainModel.shared//model
    
    /**
    getAll()
    */
    func getSection2List() -> Array<TrackStatus> {
        var result = Array<TrackStatus>()
        let strSQL:String = "SELECT * FROM " + tablename
        let (resultSet, err) = SD.executeQuery(sqlStr: strSQL)
//        SD.executeQuery(sqlStr: strSQL )
        
        if err != nil {
            
        } else {
            for row in resultSet {
                if let id = row["ID"]?.asInt() {
                    let trackmain : TrackStatus = TrackStatus()
                    
                    trackmain.rowID = id
                    let status = row["status"]?.asInt()!
                    let statusname = row["statusname"]?.asString()!
                    let index = row["indexno"]?.asInt()!
                    
                    let insertDate = row["insertDate"]?.asString()!
                    let updateDate = row["updateDate"]?.asString()!
                    
                    trackmain.status = status!
                    trackmain.statusname = statusname!
                    trackmain.indexno = index!
                    trackmain.count = trackMainModel.getCountByStatus(trackmain.status)
                    //trackmain.count = 0
                    
                    trackmain.insertDate = insertDate!
                    trackmain.updateDate = updateDate!
                    
                    result.append(trackmain)
                }
            }
        }
        return result
    }
    
    func getSection1List() -> Array<TrackStatus> {
        var result = Array<TrackStatus>()
        for i in 0 ..< ComFunc.InitStatus.count {
            let trackmain : TrackStatus = TrackStatus()
            trackmain.status = ComFunc.InitStatus[i]
            trackmain.statusname = ComFunc.InitStatusName[i]
            trackmain.indexno = i
            trackmain.count = trackMainModel.getCountByStatus(trackmain.status)
            //trackmain.count = 0
            
            result.append(trackmain)
        }
        return result
    }
    func getAllList() -> Array<TrackStatus> {
        var result = getSection1List()
        let result2 = getSection2List()
        result = result + result2
        return result
    }
    
    func getAllItems() -> Array<String> {
        var reslist : Array<String> = []
        let result = getAllList()
        for row in result {
            reslist.append(row.statusname + " (" + String(row.count) + ")")//件
        }
        return reslist
    }
    
    
    func getMaxNo() -> Int {
        var ret = ComFunc.TrackList_startstatus
        // 新しい番号から取得する場合は "SELECT * FROM TrackNoListTable_001 ORDER BY ID DESC" を使う
        let (resultSet, err) = SD.executeQuery(sqlStr: "SELECT MAX(status) FROM " + tablename)
        if err != nil {
            ret = ComFunc.TrackList_startstatus
        } else {
            for row in resultSet {
                if let maxno = row["MAX(status)"]?.asInt() {
                    ret = maxno
                }else{
                    ret = ComFunc.TrackList_startstatus
                }
            }
        }
        return ret
    }

    
    
    
    //index
    func add(_ trackstatus:TrackStatus) -> String {
        var result:String? = nil
        trackstatus.insertDate = ComFunc().getNowDateStr()
        trackstatus.updateDate = ComFunc().getNowDateStr()
        
        if let err = SD.executeChange(sqlStr: "INSERT INTO TrackStatusTable_001 (status,statusname,indexno,insertDate,updateDate) VALUES (?,?,?,?,?)",
            withArgs: [trackstatus.status, trackstatus.statusname, trackstatus.indexno, trackstatus.insertDate, trackstatus.updateDate]) {
        //if let err = SD.executeChange("INSERT INTO " + tablename + " (status,statusname,indexno) VALUES (100,'tt',100)") {
                let (id, err) = SD.lastInsertedRowID()
                if err != nil {
                    // err
                    result="-1"
                }else{
                    // ok
                    result = String(id)
                }
        } else {
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
    
    //update
    func updateByID(_ trackmain:TrackStatus) -> Bool {
        var result:Bool? = false
        trackmain.updateDate = ComFunc().getNowDateStr()
        if let err = SD.executeChange(sqlStr: "UPDATE "+tablename+" set status=?,statusname=?,indexno=?,updateDate=? where ID=?",
            withArgs: [trackmain.status,trackmain.statusname,trackmain.indexno,trackmain.updateDate,trackmain.rowID,]) {
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
    func delete(_ id:Int) -> Bool {
        if let err = SD.executeChange(sqlStr: "DELETE FROM "+tablename+" WHERE ID = ?", withArgs: [id]) {
            // there was an error during the insert, handle it here
            return false
        } else {
            // no error, the row was inserted successfully
            return true
        }
    }
    
    //MARK: - etore
    func retoreData( datas:Array<TrackStatus>) -> Bool {
        if datas.count > 0 {
            clearDB()
        }
        for data in datas{
            add(data)
        }
        return true
    }
    //MARK: - delete all
    func clearDB() -> Bool{
        if let err = SD.executeChange(sqlStr: "DELETE FROM TrackStatusTable_001 ", withArgs: []) {
            return false
        } else {
            return true
        }
    }
}
