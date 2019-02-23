//
//  IceCreamMng+Detail.swift
//  packtrack
//
//  Created by ksymac on 2019/02/15.
//  Copyright © 2019 ZHUKUI. All rights reserved.
//

import Foundation
import RealmSwift
import IceCream
import RxRealm
import RxSwift

extension IceCreamMng{
    func AddOrUpdDetail(_ detail:TrackDetail) -> Bool {
        let idkey = RMTrackDetail.getPrimaryKey(trackNO: detail.trackNo,detailNo: detail.detailNo)
        if let obj = realm.object(ofType: RMTrackDetail.self, forPrimaryKey: idkey) {
            try! realm.write {
                obj.trackNO = detail.trackNo
                obj.detailNo = detail.detailNo
                obj.date = detail.date
                obj.status = detail.status
                obj.store = detail.store
                obj.detail = detail.detail
                obj.insertDate = ComFunc().getNowDateStr()
                obj.isDeleted = false
            }
        }else{
            detail.insertDate = ComFunc().getNowDateStr()
            let main = RMTrackDetail()
            main.id = idkey
            main.trackNO = detail.trackNo
            main.detailNo = detail.detailNo
            main.date = detail.date
            main.status = detail.status
            main.store = detail.store
            main.detail = detail.detail
            main.insertDate = detail.insertDate
            try! realm.write {
                realm.add(main)
            }
        }
        return true
    }
    func deleteDetailsByTrackNo(_ trackNo:String) -> Bool {
        let sql = String(format: "trackNO = '%@' AND isDeleted = false", trackNo)
        let items = realm.objects(RMTrackDetail.self).filter(sql)
//        try! realm.write {
//            realm.delete(items)
//        }
        for item in items{
            try! realm.write {
                item.isDeleted = true
            }
        }
        return true
    }
    func getDetailsByTrackNo(_ trackNo:String) -> Array<TrackDetail> {
        var result = Array<TrackDetail>()
        let sql = String(format: "trackNO = '%@'  AND isDeleted = false", trackNo)
        let sortProperties = [SortDescriptor(keyPath: "detailNo", ascending: false),]
        let items = realm.objects(RMTrackDetail.self).filter(sql).sorted(by: sortProperties)
        for item in items {
            let trackdetail = TrackDetail()
            trackdetail.trackNo = item.trackNO
            trackdetail.detailNo = item.detailNo
            trackdetail.date = item.date
            trackdetail.status = item.status
            trackdetail.store = item.store
            trackdetail.detail = item.detail
            trackdetail.insertDate = item.insertDate ?? ""
            result.append(trackdetail)
        }
        return result
    }
    func getAllDetails() -> Array<TrackDetail> {
        var result = Array<TrackDetail>()
        let sortProperties = [SortDescriptor(keyPath: "trackNO", ascending: false),
                              SortDescriptor(keyPath: "detailNo", ascending: false),]
        let items = realm.objects(RMTrackDetail.self).filter(notIsDelSql).sorted(by: sortProperties)
        for item in items {
            let trackdetail = TrackDetail()
            trackdetail.trackNo = item.trackNO
            trackdetail.detailNo = item.detailNo
            trackdetail.date = item.date
            trackdetail.status = item.status
            trackdetail.store = item.store
            trackdetail.detail = item.detail
            trackdetail.insertDate = item.insertDate ?? ""
            result.append(trackdetail)
        }
        return result
    }
}
