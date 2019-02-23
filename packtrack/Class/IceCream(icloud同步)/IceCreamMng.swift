//
//  IceCreamMng.swift
//  packtrack
//
//  Created by ksymac on 2019/02/14.
//  Copyright © 2019 ZHUKUI. All rights reserved.
//

import Foundation
import RealmSwift
import IceCream
import RxRealm
import RxSwift

class IceCreamMng: NSObject {
    static let shared = IceCreamMng()
    let notIsDelSql = String(format: "isDeleted = false")
    lazy var trackMainModel = TrackMainModel()//model
    lazy var trackDetailModel = TrackDetailModel()//model
    lazy var trackStatusModel = TrackStatusModel()//model
    lazy var realm = try! Realm()
    
    //MARK: - 添加或编辑现有的数据
    func addOrUpdMainAtAddView(_ item: TrackMain) {
        if let obj = realm.object(ofType: RMTrackMain.self, forPrimaryKey: item.trackNo) {
            try! realm.write {
                obj.trackType = item.trackType
                obj.comment = item.comment
                obj.commentTitle = item.commentTitle
                obj.status = item.status
                obj.isDeleted = false
            }
        }else{
            item.insertDate = ComFunc.shared.getNowDateStr()
            item.updateDate = ComFunc.shared.getNowDateStr()
            let obj = RMTrackMain()
            obj.trackNo = item.trackNo
            obj.trackType = item.trackType
            obj.typeName = item.typeName
            obj.comment = item.comment
            obj.commentTitle = item.commentTitle
            obj.insertDate = item.insertDate //添加时，更新时间
            obj.updateDate = item.updateDate //添加时，更新时间
            try! realm.write {
                realm.add(obj)
            }
        }
    }
    //MARK: - 从网络获取，更新数据
    func UpdMainFromNet(_ item: TrackMain) {
        if let obj = realm.object(ofType: RMTrackMain.self, forPrimaryKey: item.trackNo) {
            try! realm.write {
                obj.trackType = item.trackType
                obj.typeName = item.typeName
                obj.haveUpdate = item.haveUpdate
                obj.latestDate = item.latestDate
                obj.latestStatus = item.latestStatus
                obj.latestStore = item.latestStore
                obj.latestDetail = item.latestDetail
                obj.latestDetailNo = item.latestDetailNo
                //obj.insertDate = item.insertDate
                obj.updateDate = ComFunc.shared.getNowDateStr()
                obj.isDeleted = false
            }
            //更新云端数据
            PringManager.shared.updateToFCM(bean: item)
        }
    }
    //MARK: - 从旧的DB，或者从Firebasefile 覆盖数据
    func addOrUpdMainFromOldDB(_ item: TrackMain) {
        if let obj = realm.object(ofType: RMTrackMain.self, forPrimaryKey: item.trackNo) {
            try! realm.write {
                obj.trackType = item.trackType
                obj.comment = item.comment
                obj.commentTitle = item.commentTitle
                obj.typeName = item.typeName
                obj.status = item.status
                obj.haveUpdate = item.haveUpdate
                obj.latestDate = item.latestDate
                obj.latestStatus = item.latestStatus
                obj.latestStore = item.latestStore
                obj.latestDetail = item.latestDetail
                obj.latestDetailNo = item.latestDetailNo
                obj.insertDate = item.insertDate
                obj.updateDate = item.updateDate
                obj.isDeleted = false
            }
        }else{
            let obj = RMTrackMain()
            obj.trackNo = item.trackNo
            obj.trackType = item.trackType
            obj.typeName = item.typeName
            obj.comment = item.comment
            obj.commentTitle = item.commentTitle
            obj.status = item.status
            obj.haveUpdate = item.haveUpdate
            obj.latestDate = item.latestDate
            obj.latestStatus = item.latestStatus
            obj.latestStore = item.latestStore
            obj.latestDetail = item.latestDetail
            obj.latestDetailNo = item.latestDetailNo
            obj.insertDate = item.insertDate
            obj.updateDate = item.updateDate
            try! realm.write {
                realm.add(obj)
            }
        }
    }
    
    //MARK: - 更新单个项目
    func updMainStatus(_ trackmain:TrackMain) {
        if let obj = realm.object(ofType: RMTrackMain.self, forPrimaryKey: trackmain.trackNo) {
            try! realm.write {
                obj.status = trackmain.status
            }
        }
    }
    func setReaded(_ trackNo:String) {
        if let obj = realm.object(ofType: RMTrackMain.self, forPrimaryKey: trackNo) {
            try! realm.write {
                obj.haveUpdate = false
            }
        }
    }
    func deleteMainByTrackNo(_ trackNo:String) -> Bool {
        if let obj = realm.object(ofType: RMTrackMain.self, forPrimaryKey: trackNo) {
            try! realm.write {
//                realm.delete(obj)
                obj.isDeleted = true
            }
            //更新云端数据
            PringManager.shared.deleteDataToFCM(trackno: trackNo)
        }
        return true
    }
    //MARK: - 获取列表
    func getTrackMainlist() -> [RMTrackMain] {
        let mains = realm.objects(RMTrackMain.self)
        return mains.toArray()
    }
    func getTrackMainlistForMainView(_ intStatus : Int) -> Results<RMTrackMain> {
        if(intStatus == ComFunc.TrackList_all){
            let sql = String(format: "status >= 0 and %@", notIsDelSql)
            let items = realm.objects(RMTrackMain.self).filter(sql)
            return items
        }else{
            let sql = String(format: "status = %d and %@", intStatus, notIsDelSql)
            let items = realm.objects(RMTrackMain.self).filter(sql)
            return items
        }
    }
    
    //getCountByStatus
    func getCountByStatus(_ intStatus : Int) -> Int {
        if(intStatus == ComFunc.TrackList_all){
            let sql = String(format: "status >= 0 and %@", notIsDelSql)
            let items = realm.objects(RMTrackMain.self).filter(sql)
            return items.count
        }else{
            let sql = String(format: "status = %d and %@", intStatus, notIsDelSql)
            let items = realm.objects(RMTrackMain.self).filter(sql)
            return items.count
        }
    }
    func getAllMainBeansByStatus(_ intStatus : Int) -> Array<TrackMain> {
        var result = Array<TrackMain>()
        var items : Results<RMTrackMain>?
        let sortProperties = [SortDescriptor(keyPath: "insertDate", ascending: false),]
        if(intStatus < -1){
            items = realm.objects(RMTrackMain.self).filter(notIsDelSql).sorted(by: sortProperties)
        }else{
            let sql = String(format: "status = %d and %@", intStatus, notIsDelSql)
            items = realm.objects(RMTrackMain.self).filter(sql).sorted(by: sortProperties)
        }
        if let items = items {
            for item in items  {
                let trackmain : TrackMain = TrackMain()
                trackmain.trackNo = item.trackNo
                trackmain.trackType = item.trackType
                trackmain.typeName = item.typeName
                //            trackmain.networking = item.networking
                trackmain.status = item.status
                trackmain.comment = item.comment
                trackmain.commentTitle = item.commentTitle
                trackmain.haveUpdate = item.haveUpdate
                trackmain.latestDate = item.latestDate
                trackmain.latestStatus = item.latestStatus
                trackmain.latestStore = item.latestStore
                trackmain.latestDetail = item.latestDetail
                trackmain.latestDetailNo = item.latestDetailNo
                trackmain.insertDate = item.insertDate
                trackmain.updateDate = item.updateDate
                
                result.append(trackmain)
            }
        }

        return result
    }
    
    func getMainBeanByTrackNo(_ trackNo:String) -> TrackMain? {
        if let item = realm.object(ofType: RMTrackMain.self, forPrimaryKey: trackNo) {
            let trackmain : TrackMain = TrackMain()
            trackmain.trackNo = item.trackNo
            trackmain.trackType = item.trackType
            trackmain.typeName = item.typeName
            //trackmain.networking = item.networking
            trackmain.status = item.status
            trackmain.comment = item.comment
            trackmain.commentTitle = item.commentTitle
            trackmain.haveUpdate = item.haveUpdate
            trackmain.latestDate = item.latestDate
            trackmain.latestStatus = item.latestStatus
            trackmain.latestStore = item.latestStore
            trackmain.latestDetail = item.latestDetail
            trackmain.latestDetailNo = item.latestDetailNo
            trackmain.insertDate = item.insertDate
            trackmain.updateDate = item.updateDate
            return trackmain
        }
        return nil
    }
}
