//
//  MyADID.swift
//  packtrack
//
//  Created by ksymac on 2018/4/1.
//  Copyright © 2018年 ZHUKUI. All rights reserved.
//

import UIKit


//设置如何保存UserDefault
class MyUserDefaults: NSObject {
    static let shared = MyUserDefaults()
    
    // MARK: Share Extension
    let suiteName = "group.com.ksyapp.packtrack.shareextension"
    let key_sharedata = "packtrack_shareextension_key_add"
    let key_buy_adclose = "packtrack_key_buy_adclose"
    
    
    let key_fcm_token = "packtrack_key_fcm_token"
    let key_clouddb_version = "packtrack_key_clouddb_version"
    let key_enable_remote_notification = "packtrack_key_enable_remote_notification"
    
    
    let key_amazon_user = "packtrack_key_amazon_user"
    let key_amazon_psd = "packtrack_key_amazon_psd"
    let key_amazon_user_status = "packtrack_key_amazon_user_status"
    
    
    let key_import_icecream = "packtrack_key_import_icecream"
}

//MARK: FCMTOKEN
extension MyUserDefaults{
    func getFCMTOKEN() -> String?{
        guard let ret =  UserDefaults.standard.value(forKey: key_fcm_token) as? String else{
            return nil
        }
        return ret
    }
    func setFCMTOKEN(_ value:String){
        UserDefaults.standard.set(value, forKey: key_fcm_token)
        UserDefaults.standard.synchronize()
    }
    
    func getEnableRemoteNotification() -> Bool?{
        guard let ret =  UserDefaults.standard.value(forKey: key_enable_remote_notification) as? Bool else{
            return nil
        }
        return ret
    }
    func setEnableRemoteNotification(_ value:Bool){
        UserDefaults.standard.set(value, forKey: key_enable_remote_notification)
        UserDefaults.standard.synchronize()
    }
    
    func setAmazonUserData(user:String, psd:String){
        UserDefaults.standard.set(user, forKey: key_amazon_user)
//        UserDefaults.standard.set(psd, forKey: key_amazon_psd)
        UserDefaults.standard.synchronize()
    }
    func setAmazonUserDataStatus(status:Int){
        UserDefaults.standard.set(status, forKey: key_amazon_user_status)
        UserDefaults.standard.synchronize()
    }
}

//MARK: 购买关闭广告
extension MyUserDefaults{
    func getPurchased_ADClose() -> Bool{
        if packtrack_user?.adclose == true{
            setPurchased_ADClose(true)
            return true
        }
        guard let ret =  UserDefaults.standard.value(forKey: key_buy_adclose) as? Bool else{
            return false
        }
        return ret
    }
    func setPurchased_ADClose(_ value:Bool){
        UserDefaults.standard.set(value, forKey: key_buy_adclose)
        UserDefaults.standard.synchronize()
    }
}

//MARK: 购买关闭广告
extension MyUserDefaults{
    func getImportToIceCream() -> Bool{
        guard let ret =  UserDefaults.standard.value(forKey: key_import_icecream) as? Bool else{
            return false
        }
        return ret
    }
    func setImportToIceCream(_ value:Bool){
        UserDefaults.standard.set(value, forKey: key_import_icecream)
        UserDefaults.standard.synchronize()
    }
}



extension MyUserDefaults{
    func checkShareExtension()->Bool{
        if let prefs = UserDefaults(suiteName: suiteName) {
            if let newdic = prefs.object(forKey: key_sharedata) as? Dictionary<String, Dictionary<String, String>>{
                for (k,v) in newdic{
                    if let no = v["no"], let company = v["company"]{
                        var nostr = no.removeAllWhitespace()
                        if nostr.count > 0{
                            self.addToDB(strTrackNo: nostr, strTrackType: company)
                        }
                    }
                }
                prefs.removeObject(forKey: key_sharedata)
                return true
            }
        }
        return false
    }
    //insert or update
    func addToDB(strTrackNo:String,strTrackType:String) -> TrackMain? {
        var temp : TrackMain? =  nil
//        temp = TrackMainModel.shared.getAllByTrackNo(strTrackNo)
        temp = IceCreamMng.shared.getMainBeanByTrackNo(strTrackNo)
        if(temp == nil){
            let trackmain = TrackMain()
            trackmain.trackNo = strTrackNo
            trackmain.trackType = strTrackType
            trackmain.status = ComFunc.TrackList_doing
//            _ = TrackMainModel.shared.add(trackmain)
            IceCreamMng.shared.addOrUpdMainAtAddView(trackmain)
        }else{
            temp!.trackNo = strTrackNo
            temp!.trackType = strTrackType
            if(temp!.status == ComFunc.TrackList_del){
                temp!.status = ComFunc.TrackList_doing
            }
//            _ = TrackMainModel.shared.updateByID(temp!)
            IceCreamMng.shared.addOrUpdMainAtAddView(temp!)
        }
//        temp = TrackMainModel.shared.getAllByTrackNo(strTrackNo)
        temp = IceCreamMng.shared.getMainBeanByTrackNo(strTrackNo)
        return temp
    }
}


