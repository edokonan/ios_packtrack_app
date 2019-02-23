//
//  AmazonOrder.swift
//  packtrack
//
//  Created by ksymac on 2018/8/26.
//  Copyright © 2018年 ZHUKUI. All rights reserved.
//

import Foundation
import Kanna

class AmazonOrderParser {
    enum StatusType:Int {
        case nothing = 0
        case loginhtml = 1
        case LoginErr = 2
        case Logined = 10
        case LoginedOrderHistory = 11
        case Checking = 50
        case CheckingShipTrack = 51
        
        case Checkover = 90
    }
    let model = AmazonOrdersModel()
    var checkoverstr:String  {
        let str =  String(format: "注文情報をインポート完了(輸送中：%d件)",  arguments: [model.order0_list.count,])
        return str
    }
    static let baseUrl = "www.amazon.co.jp/gp/your-account/order-history/ref=aw_ya_hp_oh_aui"
    //1.根据当前网址判断状态
    func parseWebStatus(url:URL?) -> StatusType{
        if let strurl = url{
            let str = strurl.absoluteString
            print(strurl)
            if str.elementsEqual("https://www.amazon.co.jp/"){

            }else if str.range(of: "www.amazon.co.jp/ap/signin") != nil{
                //document.getElementById("ap_email").value
                //document.getElementById("ap_password").value
                //document.getElementById("auth-show-password-checkbox").checked=false;
                //let javascript_1 = "document.getElementsByName('rememberMe').checked=true;"//
                //webview.stringByEvaluatingJavaScript(from: javascript_1)
                return StatusType.loginhtml
            }else if str.range(of: "www.amazon.co.jp/gp/your-account/order-history") != nil{
                return StatusType.LoginedOrderHistory
            }else if (str.range(of: "www.amazon.co.jp/gp/your-account/ship-track") != nil
                || str.range(of: "www.amazon.co.jp/progress-tracker/package") != nil
                ){
                let url = URL.init(string: str)!
                if let para = url.queryParameters,
                    let shipmentId = para["shipmentId"],
                    let orderId = para["orderId"]{
                    print(para)
                    //let doc = webview.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")
                    //amazonOrderParser.parseShipHtml(html: doc, orderId: orderId, shipmentId: shipmentId)
                    //loadShipHtml()
                }
                return StatusType.CheckingShipTrack
            }else{
                
            }
        }
        return StatusType.nothing
        //https://www.amazon.co.jp/ap/signin
        //https://www.amazon.co.jp/ap/signin?openid.return_to=https%3A%2F%2Fwww.amazon.co.jp%2Fgp%2Fhomepage.html%3Fopf_redir%3D1%26ref_%3Dnavm_hdr_signin%26_encoding%3DUTF8&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.assoc_handle=anywhere_v2_jp&openid.mode=checkid_setup&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&&openid.pape.max_auth_age=0
        //https://www.amazon.co.jp/ap/signin?_encoding=UTF8&openid.assoc_handle=jpflex&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.mode=checkid_setup&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&openid.ns.pape=http%3A%2F%2Fspecs.openid.net%2Fextensions%2Fpape%2F1.0&openid.pape.max_auth_age=0&openid.return_to=https%3A%2F%2Fwww.amazon.co.jp%2Fgp%2Fyour-account%2Fship-track%2Fevent-list%3Fie%3DUTF8%26action%3Dsign-out%26orderId%3D250-0232170-5362200%26path%3D%252Fgp%252Fyour-account%252Fship-track%252Fevent-list%26ref_%3DARRAY%25280x8b0472ac%2529%26shipmentId%3DDhpFlpHKH%26signIn%3D1%26useRedirectOnSuccess%3D1
        //                https://www.amazon.co.jp/ap/signin
        //"https://www.amazon.co.jp/gp/homepage.html?opf_redir=1&ref_=navm_hdr_signin&_encoding=UTF8&"
        //注文履歴   https://www.amazon.co.jp/gp/your-account/order-history/ref=aw_ya_hp_oh_aui
        // https://www.amazon.co.jp/gp/your-account/order-history?ie=UTF8&ref_=aw_ya_hp_oh_aui&
        //アカウントサービス　https://www.amazon.co.jp/gp/aw/ya?ref=navm_hdr_hello
    }
    //2.解析订单
    func parseOrdersHtml(html:String){
        if let doc = try? HTML(html: html, encoding: .utf8) {
            //            print(doc.title)
            if let div = doc.at_css("div.a-section:nth-child(2)"){
                print(div)
            }
            for div in doc.css("div.a-section.a-padding-small"){
                let item = Order_Amazon_Cls()
                if let img  = div.at_css("img:nth-child(1)"),
                    let img_title_name  = img["alt"],
                    let img_src = img["src"]{
                    item.title = img_title_name
                    item.imglink = img_src
                }
                if let link = div.at_css("a:nth-child(1)"),
                    let link_href = link["href"]{
                    //print(link)
                    //                    print(link_href)
                    item.orderLink = "https://www.amazon.co.jp" + link_href
                    let url = URL.init(string:  item.orderLink!)!
                    if let para = url.queryParameters{
                        print(para)
                        item.shipmentId = para["shipmentId"]
                        item.orderId = para["orderId"]
                        item.packageId = para["packageId"]
                        item.lineItemId = para["lineItemId"]
                    }
                }
                //print(div.innerHTML!)
                if let txt = div.at_css("div.a-column.a-span8.a-span-last"),
                    var str = txt.text {
                    str = str.replacingOccurrences(of: " ", with: "")
                    print(str)
                    if let temp:[String]  = str.components(separatedBy: "\n"){
                        let newitems = temp.filter { (item) -> Bool in
                            return item.contains("注文") || item.contains("配達") || item.contains("発送") || item.contains("輸送") || item.contains("予定") || item.contains("配") || item.contains("送") || item.contains("返品") || item.contains("完了")
                        }
                        item.order_status = newitems.joined(separator: " ")
                    }
                }
                model.add(newitem: item)
                model.printInfo_item(order: item)
            }
            //            // Search for nodes by XPath
            //            for link in doc.xpath("//a | //link") {
            //                print(link.text)
            //                print(link["href"])
            //            }
            //            // Search for nodes by CSS
            //            for link in doc.css("a, link") {
            //                print(link.text)
            //                print(link["href"])
            //            }
        }
        //        model.printInfo()
    }
    //3.解析运输单
    func parseShipHtml(html:String,orderId:String,shipmentId:String){
        let ind = model.Orders_Amazon.index { (item) -> Bool in
            return ( item.orderId == orderId && item.shipmentId == shipmentId)
        }
        print(ind)
        let item = model.Orders_Amazon[ind!]
        if let doc = try? HTML(html: html, encoding: .utf8) {
//            if let div = doc.at_css("div.a-container"){
            if let div = doc.at_css("div#carrierRelatedInfo-container"){
                item.trackinfo = div.text
            }
            if let div = doc.at_css("div.shipment-status-content"),
             let str = div.text{
                item.setTrackStatus(str: str)
            }
            //详细
            if let div = doc.at_css("div.a-box-group.a-spacing-mini"){
                item.trackdetail = div.text
            }
            item.isGotShipInfo = true
            item.addToLocalDB()
        }
    }
}
