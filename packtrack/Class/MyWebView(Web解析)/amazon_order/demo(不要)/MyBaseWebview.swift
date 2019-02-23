//
//  MyBaseWebview.swift
//  packtrack
//
//  Created by ksymac on 2018/8/24.
//  Copyright © 2018年 ZHUKUI. All rights reserved.
//

import Foundation
import TOWebViewController
import Kanna
import SVProgressHUD


//import Fuzi
class MyBaseWebview: TOWebViewController {
    
    let amazonOrderParser = AmazonOrderParser()
    var status:AmazonOrderParser.StatusType? = nil
    var vc:AmazonOrderTableVC? = nil
    //login:https://www.amazon.co.jp/ap/signin?_encoding=UTF8&openid.assoc_handle=anywhere_v2_jp&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.mode=checkid_setup&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&openid.ns.pape=http%3A%2F%2Fspecs.openid.net%2Fextensions%2Fpape%2F1.0&openid.pape.max_auth_age=0&openid.return_to=https%3A%2F%2Fwww.amazon.co.jp%2Fgp%2Faw%2Fpsi.html%3Fie%3DUTF8%26cartID%3D358-5744558-0679014%26destinationURL%3D%252Fgp%252Faw%252Fya%26packedQuery%3Dref_%257Cnavm_hdr_profile&pageId=anywhere_jp
    //order his: https://www.amazon.co.jp/gp/your-account/order-history/ref=aw_ya_hp_oh_aui
    //order his: https://www.amazon.co.jp/gp/your-account/order-history/ref=aw_ya_hp_oh_aui
    //https://www.amazon.co.jp/your-orders/pop/ref=oh_aui_i_d_rec_o0?_encoding=UTF8&gen=canonical&lineItemId=lhsilxklsnnptw&orderId=250-7126951-6699051&packageId=1&returnSummaryId=&returnUnitIndices=&shipmentId=Dv9sJgcSH
    //https://www.amazon.co.jp/
    //https://www.amazon.co.jp/gp/your-account/ship-track?itemId=lhsilxklsnnpt&ref=yo_pop_mb_tp&packageIndex=0&orderId=250-7126951-6699051&shipmentId=Dv9sJgcSH
    override func webViewDidFinishLoad(_ webView: UIWebView) {
        super.webViewDidFinishLoad(webView)
//        print(self.url)
//        print(self.webView.request?.mainDocumentURL)
//        print(self.webView.request?.url)
//        print(self.webView.request)
//        print(self.webView)
//        let html = webView.stringByEvaluatingJavaScript(from: "document.body.innerHTML")
//        print(html)
        status = amazonOrderParser.parseWebStatus(url: self.webView.request?.url)
        switch status! {
        case AmazonOrderParser.StatusType.Logined:
            SVProgressHUD.showInfo(withStatus: "Start Working")
            SVProgressHUD.show()
        case AmazonOrderParser.StatusType.Checkover:
            SVProgressHUD.showSuccess(withStatus: "over")
        default:
            print(status)
        }
        if let strurl = self.webView.request?.url{
            let str = strurl.absoluteString
            if str.elementsEqual("https://www.amazon.co.jp/"){
                loadOrderURL()
            }else if str.range(of: "www.amazon.co.jp/gp/your-account/order-history/ref=aw_ya_hp_oh_aui") != nil{
                if let doc = webView.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML"){
                    amazonOrderParser.parseOrdersHtml(html: doc)
                    loadShipHtml()
                }
            }else if str.range(of: "https://www.amazon.co.jp/gp/your-account/ship-track") != nil{
                let url = URL.init(string:  str)!
                if let para = url.queryParameters,
                    let shipmentId = para["shipmentId"],
                    let orderId = para["orderId"],
                    let doc = webView.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML"){
                    print(para)
                    
                    amazonOrderParser.parseShipHtml(html: doc, orderId: orderId, shipmentId: shipmentId)
                    loadShipHtml()
                }
            }else{

            }
        }
    }
    override func webViewDidStartLoad(_ webView: UIWebView) {
        super.webViewDidStartLoad(webView)
//        print(self.url)
//        print(self.webView.request?.mainDocumentURL)
//        print(self.webView.request?.url)
//        print(self.webView.request)
//        if let strurl = self.webView.request?.url{
//            let str = strurl.absoluteString
//            if str.range(of: "www.amazon.co.jp/ap/signin") != nil{
//                //document.getElementById("ap_email").value
//                //document.getElementById("ap_password").value
//                //document.getElementById("auth-show-password-checkbox").checked=false;
//                let javascript_1 = "document.getElementsByName('rememberMe').checked=true;"//
//                webview.stringByEvaluatingJavaScript(from: javascript_1)
//                return StatusType.notLogin
//            }
//        }
    }

    func loadOrderURL(){
        self.webView.loadRequest(URLRequest.init(url: URL.init(string: "https://www.amazon.co.jp/gp/your-account/order-history/ref=aw_ya_hp_oh_aui")!))
    }
    //发送的详细 div.a-row:nth-child(18) > div:nth-child(1) > label:nth-child(1) > i:nth-child(2)
    func loadShipHtml(){
        amazonOrderParser.model.printInfo()
        if let url = amazonOrderParser.model.getNextOrder(){
            self.webView.loadRequest(
                URLRequest.init(url: url)
            )
        }else{
            SVProgressHUD.dismiss(withDelay: 0.3)
            status = AmazonOrderParser.StatusType.Checkover

            if vc == nil{
                vc = AmazonOrderTableVC()
                vc?.model = amazonOrderParser.model
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
//        let item = amazonOrderParser.model.Orders_Amazon[0]
////        let urlstr =  String(format: "https://www.amazon.co.jp/gp/your-account/ship-track?orderId=%@&shipmentId=%@",
////                             arguments: [item.orderId!, item.shipmentId!])
//        let urlstr =  String(format: "https://www.amazon.co.jp/gp/your-account/ship-track/event-list/ref=ya_st_track_details_link?ie=UTF8&orderId=%@&shipmentId=%@",  arguments: [item.orderId!, item.shipmentId!])
//        print(urlstr)
//        self.webView.loadRequest(
//            URLRequest.init(url: URL.init(string: urlstr)!)
//        )
    }

    
    
    
    
//    https://www.amazon.co.jp/gp/your-account/ship-track/event-list/ref=ya_st_track_details_link?ie=UTF8&orderId=250-7126951-6699051&shipmentId=Dv9sJgcSH
    //https://www.amazon.co.jp/your-orders/pop/ref=oh_aui_i_d_rec_o0?gen=canonical&lineItemId=lhsilxklsnnptw&orderId=250-7126951-6699051&_encoding=UTF8&shipmentId=Dv9sJgcSH&packageId=1&returnSummaryId=&returnUnitIndices=&
    //https://www.amazon.co.jp/gp/your-account/ship-track?itemId=lhsilxklsnnpt&ref=yo_pop_mb_tp&packageIndex=0&orderId=250-7126951-6699051&shipmentId=Dv9sJgcSH

    //https://www.amazon.co.jp/gp/your-account/ship-track?ie=UTF8&itemId=lhsilxklsnnpt&orderId=250-7126951-6699051&ref=yo_pop_mb_tp&shipmentId=Dv9sJgcSH&

    //https://www.amazon.co.jp/gp/your-account/ship-track?orderId=250-7126951-6699051&shipmentId=Dv9sJgcSH
    //https://www.amazon.co.jp/gp/your-account/ship-track/event-list/ref=ya_st_track_details_link?ie=UTF8&orderId=250-7126951-6699051&shipmentId=Dv9sJgcSH
}
