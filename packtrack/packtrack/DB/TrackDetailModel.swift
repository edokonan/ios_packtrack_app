//
//  TrackDetailModel.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/12.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import Foundation


class TrackDetailModel {
    static let shared = TrackDetailModel()
//    if let err = SD.createTable(table: "TrackDetailTable_001",
//                                withColumnNamesAndTypes: ["trackNo":.StringVal,
//                                                          "detailNo":.IntVal,
//                                                          "date":.StringVal,
//                                                          "status":.StringVal,
//                                                          "store":.StringVal,
//                                                          "detail":.StringVal,
//                                                          "insertDate":.StringVal,
    let create_sql =
        "create table if not exists TrackDetailTable_001("
            + "ID integer primary key autoIncrement,"
            + "trackNo text not null default '',"//"trackNo":.StringVal,
            + "detailNo INTEGER not null default 0,"//"detailNo":.IntVal,
            + "date text not null default '',"//"date":.StringVal,
            + "status text not null default '',"//"status":.StringVal,
            + "store text not null default '',"//"store":.StringVal,
            + "detail text not null default '',"//"detail":.StringVal,
            //"insertDate":.StringVal,
            + "insertDate text not null default '');"
    
//    CREATE TABLE TrackDetailTable_001 (ID INTEGER PRIMARY KEY AUTOINCREMENT, "detail" TEXT, "date" TEXT, "trackNo" TEXT, "insertDate" TEXT, "detailNo" INTEGER, "status" TEXT, "store" TEXT)

    
    
    // テーブル作成
    init() {
        let (tb, err) = SD.existingTables()
        if !tb.contains("TrackDetailTable_001") {
            // TrackNoListTable_001を作成,その際"id"は自動生成 dataはStringVal = string型
//            if let err = SD.createTable(table: "TrackDetailTable_001",
//                withColumnNamesAndTypes: ["trackNo":.StringVal,
//                    "detailNo":.IntVal,
//                    "date":.StringVal,
//                    "status":.StringVal,
//                    "store":.StringVal,
//                    "detail":.StringVal,
//                    "insertDate":.StringVal,
//                ]) {
            if let err = SD.createTable(sql: create_sql){
                debug_print("--DB: create TrackDetailTable_001 error---")
            } else {
                debug_print("--DB: create TrackDetailTable_001---")
            }
        }
    }
    
    /**
    INSERT文（追加）
    var add = 自作databaseクラス.add("3urprise") これでdatabaseに"3urprise"と追加される
    */
    func add(_ trackdetail:TrackDetail) -> String {
        
        var result:String? = nil
        
        trackdetail.insertDate = ComFunc().getNowDateStr()
        
        if let err = SD.executeChange(sqlStr: "INSERT INTO TrackDetailTable_001 (trackNO,detailNo,date,status,store, detail,insertDate) VALUES (?,?,?,?,?,?,?)",
            withArgs: [trackdetail.trackNo as AnyObject,trackdetail.detailNo as AnyObject,trackdetail.date as AnyObject,trackdetail.status as AnyObject,trackdetail.store as AnyObject,trackdetail.detail as AnyObject,trackdetail.insertDate as AnyObject]) {
            // there was an error during the insert, handle it here
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
    
    /**
    DELETE文
    var del = 自作databaseクラス.delete(Int) これでテーブルのID削除
    */
    func deleteByRowID(_ id:Int) -> Bool {
        if let err = SD.executeChange(sqlStr: "DELETE FROM TrackDetailTable_001 WHERE ID = ?", withArgs: [id as AnyObject,]) {
            // there was an error during the insert, handle it here
            return false
        } else {
            // no error, the row was inserted successfully
            return true
        }
    }
    func deleteByTrackNo(_ trackNo:String) -> Bool {
        if let err = SD.executeChange(sqlStr: "DELETE FROM TrackDetailTable_001 WHERE trackNO = ?", withArgs: [trackNo as AnyObject,]) {
            // there was an error during the insert, handle it here
            return false
        } else {
            // no error, the row was inserted successfully
            return true
        }
    }
    
    /**
    SELECT文
    var selects = 自作databaseクラス.getAll() これでNSMutableArray型の内容が取得出来る
    */
    func getAll() -> Array<TrackDetail> {
        var result = Array<TrackDetail>()
        // 新しい番号から取得する場合は "SELECT * FROM TrackNoListTable_001 ORDER BY ID DESC" を使う
        let (resultSet, err) = SD.executeQuery(sqlStr: "SELECT * FROM TrackDetailTable_001 ORDER BY detailNo DESC")
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]?.asInt() {
                    let trackdetail : TrackDetail = TrackDetail()
                    
                    trackdetail.rowID = id
                    
                    let trackNo = row["trackNo"]?.asString()!
                    let detailNo = row["detailNo"]?.asInt()!
                    let date = row["date"]?.asString()!
                    let status = row["status"]?.asString()!
                    let store = row["store"]?.asString()!
                    let detail = row["detail"]?.asString()!
                    let insertDate = row["insertDate"]?.asString()!
                    
                    trackdetail.trackNo = trackNo!
                    trackdetail.detailNo = detailNo!
                    trackdetail.date = date!
                    trackdetail.status = status!
                    trackdetail.store = store!
                    trackdetail.detail = detail!
                    trackdetail.insertDate = insertDate!
                    
                    result.append(trackdetail)
                }
            }
        }
        return result
    }
    func getAllByTrackNo(_ trackNo:String) -> Array<TrackDetail> {
        var result = Array<TrackDetail>()
        // 新しい番号から取得する場合は "SELECT * FROM TrackNoListTable_001 ORDER BY ID DESC" を使う
        let (resultSet, err) = SD.executeQuery(sqlStr: "SELECT * FROM TrackDetailTable_001 WHERE trackNo = ? ORDER BY detailNo DESC", withArgs: [trackNo as AnyObject])
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]?.asInt() {
                    let trackdetail : TrackDetail = TrackDetail()
                    trackdetail.rowID = id
                    
                    let strtrackNo = row["trackNo"]?.asString()!
                    let detailNo = row["detailNo"]?.asInt()!
                    let date = row["date"]?.asString()!
                    let status = row["status"]?.asString()!
                    let store = row["store"]?.asString()!
                    let detail = row["detail"]?.asString()!
                    let insertDate = row["insertDate"]?.asString()!

                    trackdetail.detailNo = detailNo!
                    trackdetail.date = date!
                    trackdetail.status = status!
                    trackdetail.store = store!
                    trackdetail.detail = detail!
                    trackdetail.insertDate = insertDate!
                    trackdetail.trackNo = strtrackNo!
                    
                    result.append(trackdetail)
                }
            }
        }
        return result
    }
    
    
    
    
    
    
    //MARK: - Retore
    func retoreData( datas:Array<TrackDetail>) -> Bool {
        for data in datas{
            add(data)
        }
        return true
    }
    //MARK: - delete all
    func clearDB() -> Bool{
        if let err = SD.executeChange(sqlStr: "DELETE FROM TrackDetailTable_001 ", withArgs: []) {
            return false
        } else {
            return true
        }
    }
}
