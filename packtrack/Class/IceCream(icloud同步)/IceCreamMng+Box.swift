//
//  IceCreamMng+Box.swift
//  packtrack
//
//  Created by ksymac on 2019/02/15.
//  Copyright © 2019 ZHUKUI. All rights reserved.
//
import RealmSwift
import IceCream
import RxRealm
import RxSwift

extension IceCreamMng{
    
    func getSection2List() -> Array<TrackStatus> {
        var result = Array<TrackStatus>()
        let sortProperties = [SortDescriptor(keyPath: "insertDate", ascending: false),]
        let items = realm.objects(RMTrackStatus.self).filter(notIsDelSql).sorted(by: sortProperties)
        for item in items {
            let status = TrackStatus()
            status.status = item.status
            status.statusname = item.statusname
            status.indexno = item.indexno
            status.count = getCountByStatus(item.status)
            status.insertDate = item.insertDate
            status.updateDate = item.updateDate
            result.append(status)
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
            trackmain.count = getCountByStatus(ComFunc.InitStatus[i])
            result.append(trackmain)
        }
        return result
    }
    func getAllStatusList() -> Array<TrackStatus> {
        var result = getSection1List()
        let result2 = getSection2List()
        result = result + result2
        return result
    }
    
    func getAllStatusStrItems() -> Array<String> {
        var reslist : Array<String> = []
        let result = getAllStatusList()
        for row in result {
            reslist.append(row.statusname + " (" + String(row.count) + ")")//件
        }
        return reslist
    }
    

    
    //Mark: --add view
//    func addStatus(_ trackstatus:TrackStatus) -> Bool {
//        //追加
//        trackstatus.insertDate = ComFunc().getNowDateStr()
//        trackstatus.updateDate = ComFunc().getNowDateStr()
//        let main = RMTrackStatus()
//        main.status = trackstatus.status
//        main.statusname = trackstatus.statusname
//        main.indexno = trackstatus.indexno
//        main.insertDate = trackstatus.insertDate
//        main.updateDate = trackstatus.updateDate
//        try! realm.write {
//            realm.add(main)
//        }
//        return true
//    }
    //MARK: get id ミリ秒で取得する
    func getNextStatusBoxId() -> Int {
//        let number = Int.random(in: 0 ... 999)
        let someDate = Date()
        let timeInterval = someDate.timeIntervalSince1970
        let myInt = Int(timeInterval)
        return myInt
    }
    func updateStatusBoxByID(_ trackstatus:TrackStatus) -> Bool {
        let sql = String(format: "status = %d", trackstatus.status)
        let items = realm.objects(RMTrackStatus.self).filter(sql)
        for item in items{
            try! realm.write {
                item.statusname = trackstatus.statusname
                item.isDeleted = false
            }
        }
        return true
    }
    
    //Mark: -- 生成新的ID
    func addOrupdStatus(_ trackstatus:TrackStatus) -> Bool {
        let sql = String(format: "status = %d", trackstatus.status)
        let items = realm.objects(RMTrackStatus.self).filter(sql)
        if items.count > 0{
            for item in items{
                try! realm.write {
                    trackstatus.updateDate = ComFunc().getNowDateStr()
                    item.statusname = trackstatus.statusname
                    item.updateDate = trackstatus.updateDate
                    item.isDeleted = false
                }
            }
        }else{
            trackstatus.insertDate = ComFunc().getNowDateStr()
            trackstatus.updateDate = ComFunc().getNowDateStr()
            let obj = RMTrackStatus()
            obj.status = trackstatus.status
            obj.statusname = trackstatus.statusname
            obj.indexno = trackstatus.indexno
            obj.insertDate = trackstatus.insertDate
            obj.updateDate = trackstatus.updateDate
            obj.createdAt = Date()
            try! realm.write {
                realm.add(obj)
            }
        }
        return true
    }
    
    func deleteByStatusId(_ statusid:Int) -> Bool {
        let sql = String(format: "status = %d", statusid)
        let items = realm.objects(RMTrackStatus.self).filter(sql)
//        try! realm.write {
//            realm.delete(items)
//        }
        for item in items {
            try! realm.write {
                item.isDeleted = true
            }
        }
        return true
    }
    //update
    func UpdateOrAdd_Status(_ trackstatus:TrackStatus) -> Bool {
        trackstatus.insertDate = ComFunc().getNowDateStr()
        trackstatus.updateDate = ComFunc().getNowDateStr()
        let sql = String(format: "status = %d", trackstatus.status)
        let items = realm.objects(RMTrackStatus.self).filter(sql)
        if(items.count > 0){
            try! realm.write {
                items[0].statusname = trackstatus.statusname
                items[0].indexno = trackstatus.indexno
                items[0].insertDate = trackstatus.insertDate
                items[0].updateDate = trackstatus.updateDate
                items[0].isDeleted = false
            }
        }else{
            let main = RMTrackStatus()
            main.status = trackstatus.status
            main.statusname = trackstatus.statusname
            main.indexno = trackstatus.indexno
            main.insertDate = trackstatus.insertDate
            main.updateDate = trackstatus.updateDate
            try! realm.write {
                realm.add(main)
            }
        }
        return true
    }
}
