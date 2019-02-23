//
// SwiftData.swift
import Foundation
import UIKit
import FMDB

public struct SDColumn {
    var value: AnyObject
    init(obj: AnyObject) {
        value = obj
    }
    public func asString() -> String? {
        return value as? String
    }
    public func asInt() -> Int? {
        return value as? Int
    }
    public func asDouble() -> Double? {
        return value as? Double
    }
    public func asBool() -> Bool? {
        return value as? Bool
    }
    public func asData() -> NSData? {
        return value as? NSData
    }
    public func asDate() -> NSDate? {
        return value as? NSDate
    }
    public func asAnyObject() -> AnyObject? {
        return value
    }
}
public struct SDRow {
    var values = [String: SDColumn]()
    public subscript(key: String) -> SDColumn? {
        get {
            return values[key]
        }
        set(newValue) {
            values[key] = newValue
        }
    }
}


// MARK: - SwiftData
func getdbpath() -> String  {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/SwiftData.sqlite"
}
public struct SwiftData {
    let db:FMDatabase? = FMDatabase.init(path: getdbpath())

    func existingTables() -> (result: [String], error: Int?) {
        var result = [String] ()
        var error: Int? = nil
        let sql = "SELECT name FROM sqlite_master WHERE type = \"table\""
        db?.open()
        if let results =  db?.executeQuery(sql, withArgumentsIn: []){
            while results.next() {
                if let name = results.string(forColumn: "name"){
                    result.append(name)
//                    print(name)
                }
            }
        }
        db?.close()
//        //添加数据
//        BOOL res2= [CoreFMDB executeUpdate:@"insert into user (name,age) values('jack',27);"];
//
//        if(res2){
//            NSLog(@"添加数据成功");
//        }else{
//            NSLog(@"添加数据失败");
//        }
//        //查询出表所有的列
//        NSArray *columns = [CoreFMDB executeQueryColumnsInTable:@"user"];
//        NSLog(@"列信息：%@",columns);
//        //查询数据
//        [CoreFMDB executeQuery:@"select * from user;" queryResBlock:^(FMResultSet *set) {
//
//            while ([set next]) {
//            NSLog(@"%@-%@",[set stringForColumn:@"name"],[set stringForColumn:@"age"]);
//            }
//
//            }];
//
//        //计算记录数
//        NSUInteger count = [CoreFMDB countTable:@"user"];
        return (result, error)
    }
//    func createTable(table: String,
//                     withColumnNamesAndTypes values: [String: SwiftData.DataType]) -> Int? {
//        var error: Int? = nil
////        CoreFMDB.executeUpdate(<#T##sql: String!##String!#>)
////                //创建表
////                BOOL res =  [CoreFMDB executeUpdate:@"create table if not exists user(id integer primary key autoIncrement,name text not null default '',age integer not null default 0);"];
////
////                if(res){
////                    NSLog(@"创表执行成功");
////                }else{
////                    NSLog(@"创表执行失败");
////                }
//        return error
//    }
    func createTable(sql: String) -> Int? {
        var error: Int? = nil
        do {
            db?.open()
            if let res:Bool = try db?.executeUpdate(sql, withArgumentsIn: []){
                if(res ){
                    debug_print("创表执行成功");
                }else{
                    debug_print("创表执行失败");
                }
            }
            db?.close()
        }catch{
             debug_print("不明なエラーです。")
        }
        return error
    }
    /**
     *  执行sql
     *  @param table 表名
     *  @return 操作结果
     */
    func executeQuery(sqlStr: String) -> (result: [SDRow], error: Int?) {
        var result = [SDRow] ()
        var error: Int? = nil
        print(sqlStr)
        db?.open()
        if let results =  db?.executeQuery(sqlStr, withArgumentsIn: []){
            while results.next() {
                var row = SDRow()
                for  i in 0...results.columnCount-1{
//                    results.string(forColumnIndex: i)
                   let x =  results.object(forColumnIndex: i)
//                    print(i)
//                    print(results.columnName(for: i)!)
//                    print(x)
                   row[results.columnName(for: i)!] = SDColumn(obj:x as AnyObject)
                }
                result.append(row)
            }
        }
        db?.close()
        return (result, error)
    }
    func executeQuery(sqlStr: String, withArgs: [AnyObject]? = nil) -> (result: [SDRow], error: Int?) {
        var result = [SDRow] ()
        var error: Int? = nil
        var sql = sqlStr
        debug_print(sqlStr)
        db?.open()
        if let results =  db?.executeQuery(sqlStr, withArgumentsIn: withArgs!){
            while results.next() {
                var row = SDRow()
                for  i in 0...results.columnCount-1{
                    //                    results.string(forColumnIndex: i)
                    let x =  results.object(forColumnIndex: i)
//                    print(i)
//                    print(results.columnName(for: i)!)
//                    print(x)
                    row[results.columnName(for: i)!] = SDColumn(obj:x as AnyObject)
                }
                result.append(row)
            }
        }
        db?.close()
        return (result, error)
    }
//    /**
//     *  清空表（但不清除表结构）
//     *  @param table 表名
//     *  @return 操作结果
//     */
//    func truncateTable(table: String) -> Bool{
//        return CoreFMDB.truncateTable(table)
//    }
//    func executeChange(sqlStr: String) -> Int? {
//        
//        var error: Int? = nil
//        return error
//        
//    }
    func executeChange(sqlStr: String, withArgs: [Any]) -> NSError? {
//        var error: Int? = nil
        db?.open()
        debug_print(sqlStr)
        if let results = db?.executeUpdate(sqlStr, withArgumentsIn: withArgs){
            debug_print(results)
            if results {
            }else{
                if let err = db?.lastError() {
                    return err as NSError
                }
            }
        }
        db?.close()
        return nil
    }

    func lastInsertedRowID() -> (rowID: Int, error: Int?) {
        var result = 0
        var error: Int? = nil
        return (result, error)
    }

    //close a custom connection to the sqlite3 database
    func closeCustomConnection() -> Int? {
        
        return nil
    }
    
    
    //rollback a transaction
    func rollbackTransaction() -> Int? {
        
        return nil
    }


    private class SQLiteDB {

        
    }
    public enum DataType {
        
        case StringVal
        case IntVal
        case DoubleVal
        case BoolVal
        case DataVal
        case DateVal
        case UIImageVal
        
        private func toSQL() -> String {
            
            switch self {
            case .StringVal, .UIImageVal:
                return "TEXT"
            case .IntVal:
                return "INTEGER"
            case .DoubleVal:
                return "DOUBLE"
            case .BoolVal:
                return "BOOLEAN"
            case .DataVal:
                return "BLOB"
            case .DateVal:
                return "DATE"
            }
        }
        
    }
}

let SD = SwiftData()
