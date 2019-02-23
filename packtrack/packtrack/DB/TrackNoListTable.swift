//////
//////  MySwiftData.swift
//////  packtrack
//////
//////  Created by ZHUKUI on 2015/08/08.
//////  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//////
//////  MySwiftData.swift
//////  iNotice006.1_SwiftDataBase
//////
//////  Created by tarou yamasaki on 2015/02/04.
//////  Copyright (c) 2015年 tarou yamasaki. All rights reserved.
//////
////
//import Foundation
//
//class TrackNoListTable {
////    if !tb.contains("TrackNoListTable_001") {
////    // TrackNoListTable_001を作成,その際"id"は自動生成 dataはStringVal = string型
////    if let err = SD.createTable(table: "TrackNoListTable_001",
////    withColumnNamesAndTypes: ["TrackNO":.StringVal,
////    "TrackType":.StringVal,
////    "Temp3":.StringVal,
////    "Temp4":.StringVal,]) {
//    let create_sql =
//        "create table if not exists TrackNoListTable_001("
//            + "ID integer primary key autoIncrement,"
//            + "trackNO text not null default '',"//"trackNO":.StringVal,
//            + "TrackType text not null default '',"//"trackType":.StringVal,
//            + "Temp3 text not null default '',"//"Temp3":.StringVal,
//            + "Temp4 text not null default '');"//"Temp4":.StringVal,
//
//    // テーブル作成
//    init() {
//        let (tb, err) = SD.existingTables()
//        // TrackNoListTable_001が無ければ
//        if !tb.contains("TrackNoListTable_001") {
//            if let err = SD.createTable(sql: create_sql){
//            } else {
//            }
//        }
//    }
////    /**
////    INSERT文（追加）
////    var add = 自作databaseクラス.add("3urprise") これでdatabaseに"3urprise"と追加される
////    */
////    func add(_ str:String,str2:String) -> String {
////
////        var result:String? = nil
//////        if let err = SD.executeChange(sqlStr: "INSERT INTO TrackNoListTable_001 (TrackNO,TrackType) VALUES (?,?)", withArgs: [str,str2]) {
//////        } else {
//////            let (id, err) = SD.lastInsertedRowID()
//////            if err != nil {
//////                // err
//////                result="-1"
//////            }else{
//////                // ok
//////                result = String(id)
//////            }
//////        }
////        return result!
////    }
////
////    /**
////    DELETE文
////    var del = 自作databaseクラス.delete(Int) これでテーブルのID削除
////    */
////    func delete(_ id:Int) -> Bool {
//////        if let err = SD.executeChange(sqlStr: "DELETE FROM TrackNoListTable_001 WHERE ID = ?", withArgs: [id]) {
//////            // there was an error during the insert, handle it here
//////
//////            return false
//////        } else {
//////            // no error, the row was inserted successfully
//////            return true
//////        }
////        return false;
////    }
////
//    /**
//    SELECT文
//    var selects = 自作databaseクラス.getAll() これでNSMutableArray型の内容が取得出来る
//    */
//    func getAll() -> NSMutableArray {
//        let result = NSMutableArray()
//        // 新しい番号から取得する場合は "SELECT * FROM TrackNoListTable_001 ORDER BY ID DESC" を使う
//        let sqlstr = "SELECT * FROM TrackNoListTable_001"
//        let (resultSet, err) = SD.executeQuery(sqlStr:sqlstr)
//        if err != nil {
//            // nil
//        } else {
//            for row in resultSet {
//                if let id = row["ID"]?.asInt() {
//                    let dataStr = row["TrackNO"]?.asString()!
//                    let dataStr2 = row["TrackType"]?.asString()!
//
//                    let dic = ["ID":id, "TrackNO":dataStr!, "TrackType":dataStr2!] as [String : Any]
//                    result.add(dic)
//                }
//            }
//        }
//        return result
//    }
//}
//
