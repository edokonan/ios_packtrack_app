//
//  IceCreamMng+import.swift
//  packtrack
//
//  Created by ksymac on 2019/02/16.
//  Copyright © 2019 ZHUKUI. All rights reserved.
//
import RealmSwift
import IceCream
import RxRealm
import RxSwift

extension IceCreamMng{
    func deleteAllDataForTest(){
        MyUserDefaults.shared.setImportToIceCream(false)
//        let items1 = realm.objects(RMTrackStatus.self)
//        try! realm.write {
//            realm.delete(items1)
//        }
//        let items2 = realm.objects(RMTrackMain.self)
//        try! realm.write {
//            realm.delete(items2)
//        }
//        let items3 = realm.objects(RMTrackDetail.self)
//        try! realm.write {
//            realm.delete(items3)
//        }
    }
    //flg
    func startImportToIceCreamFromOldDB(){
        let b = MyUserDefaults.shared.getImportToIceCream()
        if(b==false){
            importStatus()
            importMain()
            MyUserDefaults.shared.setImportToIceCream(true)
        }
    }
    //1.import status
    func importStatus() -> Bool{
        let list:Array<TrackStatus> = trackStatusModel.getSection2List()
        for bean in list{
            UpdateOrAdd_Status(bean)
        }
        return true
    }
    //2.import main
    func importMain() -> Bool{
        let list:Array<TrackMain> = trackMainModel.getAll(allstatus: true)
        for bean in list{
            addOrUpdMainFromOldDB(bean)
            importDetail(bean.trackNo)
        }
        return false
    }
    //3.import detail
    func importDetail(_ trackno:String) -> Bool{
        deleteDetailsByTrackNo(trackno)
        let list:Array<TrackDetail> = trackDetailModel.getAllByTrackNo(trackno)
        for bean in list {
            AddOrUpdDetail(bean)
        }
        return true
    }
}
