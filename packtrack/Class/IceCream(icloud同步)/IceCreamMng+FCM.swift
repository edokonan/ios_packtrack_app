//
//  IceCreamMng+FCM.swift
//  packtrack
//
//  Created by ksymac on 2019/02/17.
//  Copyright © 2019 ZHUKUI. All rights reserved.
//


import RealmSwift
import IceCream
import RxRealm
import RxSwift

extension IceCreamMng{
    //MARK: - retore 如果有的话，删除有的明细数据
    func restoreMainDataWithCloudFile( datas : Array<TrackMain>) -> Bool {
        for data in datas{
//            if let _ = getMainBeanByTrackNo(data.trackNo){
//                //self.update(data,restoreflg: true)
//                //trackdetail.deleteByTrackNo(data.trackNo)
//            }else{
//                addOrUpdMainFromOldDB(data)
//            }
            addOrUpdMainFromOldDB(data)
            deleteDetailsByTrackNo(data.trackNo)
        }
        return true
    }
    //MARK: - Retore details
    func restoreDetailDataWithCloudFile( datas:Array<TrackDetail>) -> Bool {
        for data in datas{
            AddOrUpdDetail(data)
        }
        return true
    }
    //MARK: - retore status
    func restoreStatusDataWithCloudFile( datas:Array<TrackStatus>) -> Bool {
//        if datas.count > 0 {
//            clearStatusDB()
//        }
        for data in datas{
            addOrupdStatus(data)
        }
        return true
    }
    
    //MARK: - clearDB
    func clearDB(){
        clearStatusDB()
        let sql = String(format: "isDeleted = false")
        let items2 = realm.objects(RMTrackMain.self).filter(sql)
//        try! realm.write {
//            realm.delete(items2)
//        }
        for item in items2{
            try! realm.write {
                item.isDeleted = true
            }
        }
        let items3 = realm.objects(RMTrackDetail.self).filter(sql)
//        try! realm.write {
//            realm.delete(items3)
//        }
        for item in items3{
            try! realm.write {
                item.isDeleted = true
            }
        }
    }
    func clearStatusDB(){
        let sql = String(format: "isDeleted = false")
        let items1 = realm.objects(RMTrackStatus.self).filter(sql)
//        try! realm.write {
//            realm.delete(items1)
//        }
        for item in items1{
            try! realm.write {
                item.isDeleted = true
            }
        }
    }
    
}
