//
//  AmazonOrdersModel.swift
//  packtrack
//
//  Created by ksymac on 2018/8/26.
//  Copyright © 2018年 ZHUKUI. All rights reserved.
//

import Foundation

class AmazonOrdersModel{
    var Orders_Amazon:[Order_Amazon_Cls] = []
    var order0_list:[Order_Amazon_Cls]{ //已发送未到达
        return Orders_Amazon.filter { (item) -> Bool in
            return ( item.orderId != nil && item.shipmentId != nil && item.isdelivered==false)
        }
    }
    var order1_list:[Order_Amazon_Cls]{ //未发送
        return Orders_Amazon.filter { (item) -> Bool in
            return ( item.orderId != nil && item.shipmentId == nil)
        }
    }
    var order2_list:[Order_Amazon_Cls]{ //已经配送完毕
        return Orders_Amazon.filter { (item) -> Bool in
            return ( item.orderId != nil && item.shipmentId != nil && item.isdelivered==true)
        }
    }
    var order3_list:[Order_Amazon_Cls]{ //电子书籍，不需要发送
        return Orders_Amazon.filter { (item) -> Bool in
            return ( item.orderId == nil && item.shipmentId == nil)
        }
    }
    
    //add item
    func add(newitem:Order_Amazon_Cls){
        let ind1 = Orders_Amazon.index { (item) -> Bool in
            return ( item.title == newitem.title)
        }
        if ind1 != nil && ind1! > 0{
            return
        }
        if newitem.orderId == nil && newitem.shipmentId == nil{
            newitem.titles.append(newitem.title)
            Orders_Amazon.append(newitem)
            return
        }
        let ind = Orders_Amazon.index { (item) -> Bool in
            return ( item.orderId == newitem.orderId && item.shipmentId == newitem.shipmentId)
        }
        if let i = ind{
            let item = Orders_Amazon[i]
            if !item.titles.contains(newitem.title){
                item.titles.append(newitem.title)
            }
            return
        }else{
            newitem.titles.append(newitem.title)
            Orders_Amazon.append(newitem)
            return
        }
    }
    
    func printInfo_item(order:Order_Amazon_Cls){
        print("-----------------------")
//        print(order.titles)
//        print(order.orderLink)
//        print(order.orderId)
//        print(order.shipmentId)
//        print(order.isGotShipInfo)
//        print(order.trackno)
//        print(order.tracktype)
//        print(order.tracktypename)
//        print(order.trackstatus)
    }
    func printInfo(){
        for order in Orders_Amazon{
            print("-----------------------")
//            print(order.titles)
//            print(order.orderLink)
//            print(order.orderId)
//            print(order.shipmentId)
//            print(order.isGotShipInfo)
//            print(order.trackno)
//            print(order.tracktype)
//            print(order.tracktypename)
//            print(order.trackstatus)
        }
    }
    //获取下一个需要检测的订单
    func getNextOrder()->URL?{
        for item in Orders_Amazon{
            if let orderId = item.orderId,
                let shipmentId = item.shipmentId,
                item.isdelivered == false,
                item.isGotShipInfo == false{
//                let str1 = "https://www.amazon.co.jp/gp/your-account/ship-track/event-list/ref=ya_st_track_details_link?ie=UTF8&orderId=%@&shipmentId=%@",
                let str1 = "https://www.amazon.co.jp/progress-tracker/package/ref=yo_ii_hz_track_action?_encoding=UTF8&itemId=ljkjornlpmqnt&orderId=%@&shipmentId=%@"
                let urlstr =  String(format: str1,  arguments: [orderId, shipmentId])
                print("-----------getNextOrder()------------")
                print(urlstr)
                return URL.init(string: urlstr)
            }
        }
        return nil
    }
    //批量添加到DB上去
    func AddListDataToLocalDB()->URL?{
        for item in Orders_Amazon{
            if item.isNeedGetShipInfo == true,
                item.isGotShipInfo == true,
                item.isAddLocalDB == false{
                if let bean = item.addToLocalDB(){
                    item.isAddLocalDB = true
                }
            }
        }
        return nil
    }
}
//https://www.amazon.co.jp/gp/your-account/ship-track?ie=UTF8&itemId=lhsilxklsnnpt&orderId=250-7126951-6699051&ref=yo_pop_mb_tp&shipmentId=Dv9sJgcSH&
class Order_Amazon_Cls {
    var title = ""
    var titles:[String] = []
    var imglink = ""
    var order_status = ""

    
    var itemId:String?
    var orderId:String?
    var shipmentId:String?
    var orderLink:String?
    var packageId:String?
    var lineItemId:String? //
    
    var isGotShipInfo:Bool = false //有无获取到ship的
    var isNeedGetShipInfo:Bool { //需要检测shipinfo的
        return self.orderId != nil && self.shipmentId != nil
            && self.isdelivered==false  && self.isGotShipInfo==false
    }
    var isAddLocalDB:Bool = false
    
    var trackno:String?
    var tracktype:String?{
        guard let name = tracktypename else {
            return nil
        }
        if name.contains("郵便") {return TrackComType.Company_jppost.rawValue}
        if name.contains("ヤマト") {return TrackComType.Company_yamato.rawValue}
        if name.contains("佐川") {return TrackComType.Company_sagawa.rawValue}
        if name.contains("西濃") {return TrackComType.Company_seino.rawValue}
        if name.contains("カトーレック") {return TrackComType.Company_katlec.rawValue}
        if name.contains("デリバリープロバイダ") {return TrackComType.Company_tmg.rawValue}
        return TrackComType.Company_tmg.rawValue
    }
    var tracktypename:String?
    var trackstatus:String?
    var trackdetail:String?
    func setTrackStatus(str:String){
        trackstatus = str.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
    }
    var isdelivered:Bool {//已经配送完毕
        if (order_status.contains("配達しました") || order_status.contains("返品")){
            return true
        }
        return false
    }
    //
    var trackinfo:String?{
        willSet {
            if let str = newValue {
                if let temp:[String]  = str.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "").components(separatedBy: "配送業者"){
                    if temp.count > 1{
                        let temp2 = temp[1].components(separatedBy: "伝票番号")
                        tracktypename = temp2[0].replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: ":", with: "").replacingOccurrences(of: " ", with: "")
                        if temp2.count > 1{
                            let temp3 = temp2[1].components(separatedBy: "（")
                            let temp4 = temp3[0].replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: ":", with: "").replacingOccurrences(of: " ", with: "")
                            if let number = Int(temp4.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                                trackno = String(number)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //添加到DB
    func addToLocalDB() -> TrackMain? {
        var temp : TrackMain? =  nil
        guard let trackno = trackno, let tracktype = tracktype else{
            return nil
        }
        //temp = TrackMainModel.shared.getAllByTrackNo(trackno)
        temp = IceCreamMng.shared.getMainBeanByTrackNo(trackno)
        var strComment =  self.titles[0]
        if self.titles.count > 1{
            strComment = String.init(format: "%@ 等(%d件)", titles[0], titles.count )
        }
        if(temp == nil){
            let trackmain = TrackMain()
            trackmain.trackNo = trackno
            trackmain.trackType = tracktype
            trackmain.commentTitle = strComment
            trackmain.comment = "amazon 注文番号:" + (orderId ?? "")
            trackmain.status = ComFunc.TrackList_doing
            
            //_ = TrackMainModel.shared.add(trackmain)
            IceCreamMng.shared.addOrUpdMainAtAddView(trackmain)
            PringManager.shared.addDataToFCM(bean: trackmain)
        }else{
            temp!.trackNo = trackno
            temp!.trackType = tracktype
            temp!.commentTitle = strComment
            temp!.comment = "amazon 注文番号:" + (orderId ?? "")
            if(temp!.status == ComFunc.TrackList_del){
                temp!.status = ComFunc.TrackList_doing
            }
            //_ = TrackMainModel.shared.updateByID(temp!)
            IceCreamMng.shared.addOrUpdMainAtAddView(temp!)
            PringManager.shared.updaKeyToFcm(oldno: trackno, newbean: temp!)
        }
        //temp = TrackMainModel.shared.getAllByTrackNo(trackno)
        temp = IceCreamMng.shared.getMainBeanByTrackNo(trackno)
        isAddLocalDB = true
        return temp
    }
}



