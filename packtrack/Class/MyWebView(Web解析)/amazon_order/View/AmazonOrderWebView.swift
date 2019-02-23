//
//  AmazonOrderWebView.swift
//  packtrack
//
//  Created by ksymac on 2018/8/29.
//  Copyright © 2018年 ZHUKUI. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
import FirebaseAnalytics

class AmazonOrderWebView: UIView {
    
    var a_user:String?
    var a_psd:String?
    var a_status:Int?
    var delegate:MyWKWebViewControllerDelegate?
    
    let amazonOrderParser = AmazonOrderParser()
    var status:AmazonOrderParser.StatusType? = nil
    @IBOutlet weak var webbaseview: UIView!
    let tableview: UITableView = UITableView()
    let titelcellId = "AmazonOrderCell"
    
    @IBOutlet weak var BView: UIView!
    @IBOutlet weak var NoticeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var TView: UIView!
//    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var webView: WKWebView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    class func instanceFromNib() -> AmazonOrderWebView {
        if let x =  Bundle.main.loadNibNamed( "AmazonOrderWebView", owner: nil, options: nil){
            let nibView = x[0] as! AmazonOrderWebView
            nibView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,
                                            height: UIScreen.main.bounds.height)
            return nibView
        }
        return AmazonOrderWebView.init()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initWebView()
        setTableUI()
        Analytics.setScreenName("AmazonWebView", screenClass: FIRAnalytics_Screen_Class1)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        webView.frame = self.bounds
//        webbaseview.setNeedsLayout()
//        webbaseview.layoutIfNeeded()
    }
    func initWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width,
                                    height: UIScreen.main.bounds.height)
        webView.uiDelegate = self
        TView.addSubview(webView)
        setInfoView(mode: 0)
        webView.navigationDelegate = self
        let urlRequest = URLRequest(url:URL(string:"https://www.amazon.co.jp/gp/your-account/order-history/ref=aw_ya_hp_oh_aui")!)
        webView.load(urlRequest)
    }
    func setInfoView(mode:Int){
        if mode == 1{
            self.BView.isHidden = false
            statusLabel.text = " \"ログインしたままにする\"をチェックしてください、次回から自動ログインできます。"
            UIView.animate(withDuration: 1.5,delay: 0.0, options: .autoreverse, animations: {
                self.NoticeViewHeight.constant = 150
            }, completion: { (b) in
                self.NoticeViewHeight.constant = 150
            })
//            indicator.stopAnimating()
        }
        if mode != 1{
            self.NoticeViewHeight.constant = 0
            self.BView.isHidden = true
//            indicator.stopAnimating()
        }
//        statusLabel.text = "over"
    }
}

extension AmazonOrderWebView: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //        webView.evaluateJavaScript("document.getElementById('ap_email').value",
        let activeUrl: URL? = self.webView.url
        let url = activeUrl?.absoluteString
//        print("----------------commit------------")
//        print(url)
        //document.getElementById("ap_email").value
        //document.getElementById("ap_password").value
        //document.getElementById("auth-show-password-checkbox").checked=false;
    }
    //MARK: - 根据网址做不同的处理
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //        webView.evaluateJavaScript("document.getElementById('ap_email').value",
        //        webView.evaluateJavaScript("document.getElementById('ap_password').value",
        let activeUrl: URL? = self.webView.url
//        print(url)
        status = amazonOrderParser.parseWebStatus(url: activeUrl)
        SVProgressHUD.dismiss()
        switch status! {
        case AmazonOrderParser.StatusType.loginhtml:
            setInfoView(mode: 1)
            self.delegate?.ShowView_WebView()
        case AmazonOrderParser.StatusType.Logined,AmazonOrderParser.StatusType.LoginedOrderHistory:
            setInfoView(mode: 0)
            self.delegate?.ShowView_DataView()
            Analytics.logEvent("AmazonWebView", parameters:[
                "viewpage": "LoginedOrderHistory",])
            if let user = a_user,let psd = a_psd{
                MyUserDefaults.shared.setAmazonUserData(user: user, psd: psd)
                PringManager.shared.updateAmazonDataToFCM(user: user, pass: psd, status: 1)
            }
        case AmazonOrderParser.StatusType.Checking,AmazonOrderParser.StatusType.CheckingShipTrack, AmazonOrderParser.StatusType.Checkover:
            setInfoView(mode: 0)
            self.delegate?.ShowView_DataView()
        default:
            setInfoView(mode: 0)
            self.delegate?.ShowView_WebView()
        }
        if let strurl = activeUrl{
            let str = strurl.absoluteString
            if str.elementsEqual("https://www.amazon.co.jp/"){
                loadOrderURL()
            }else if str.range(of: "www.amazon.co.jp/gp/your-account/order-history") != nil{
                //解析订单一览画面，获取各个订单的值
                webView.evaluateJavaScript("document.documentElement.outerHTML",
                                           completionHandler: { (html: Any?, error: Error?) in
                                            if let doc = html as? String {
                                                self.amazonOrderParser.parseOrdersHtml(html: doc)
                                                self.loadShipHtml()
                                            }
                }
                )
            }else if str.range(of: "https://www.amazon.co.jp/gp/your-account/ship-track") != nil{
                //解析具体画面，获取各个订单的运单号
                if let para = activeUrl?.queryParameters,
                    let shipmentId = para["shipmentId"],
                    let orderId = para["orderId"]{
                    print(para)
                    sleep(2)
                    webView.evaluateJavaScript("document.documentElement.outerHTML",
                                               completionHandler: { (html: Any?, error: Error?) in
                                                if let doc = html as? String {
                                                    self.amazonOrderParser.parseShipHtml(html: doc, orderId: orderId, shipmentId: shipmentId)
                                                    self.loadShipHtml()
                                                }
                    }
                    )
                }
            }else if str.range(of: "www.amazon.co.jp/progress-tracker/package") != nil{
                //https://www.amazon.co.jp/progress-tracker/package/ref=ya_st_track_details_link?_encoding=UTF8&from=gp&itemId=&orderId=249-5031109-9452602&packageIndex=0&shipmentId=10048635964303
                //解析具体画面，获取各个订单的运单号
                if let para = activeUrl?.queryParameters,
                    let shipmentId = para["shipmentId"],
                    let orderId = para["orderId"]{
                    print(para)
                    sleep(1)
                    webView.evaluateJavaScript("document.documentElement.outerHTML",
                                               completionHandler: { (html: Any?, error: Error?) in
                                                if let doc = html as? String {
                                                    self.amazonOrderParser.parseShipHtml(html: doc, orderId: orderId, shipmentId: shipmentId)
                                                    self.loadShipHtml()
                                                }
                    }
                    )
                }
            }else{
                
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString {
            //urlStr is what you want
            print("----------------decidePolicyFor navigationAction------------")
            print(urlStr)
            if urlStr.contains("https://www.amazon.co.jp/ap/signin"){
                webView.evaluateJavaScript("document.getElementById('ap_email').value",
                                           completionHandler: { (html: Any?, error: Error?) in
                                            if let html = html as? String {
                                                print(html)
                                                self.a_user = html
                                            }
                }
                )
                webView.evaluateJavaScript("document.getElementById('ap_password').value",
                                           completionHandler: { (html: Any?, error: Error?) in
                                            if let html = html as? String {
                                                print(html)
                                                self.a_psd = html
                                            }
                }
                )
            }
            if urlStr.range(of: "www.amazon.co.jp/gp/your-account/order-history") != nil{
                SVProgressHUD.show()
            }
        }
        
        decisionHandler(.allow)
    }
    
    func loadOrderURL(){
        self.webView.load(URLRequest.init(url: URL.init(string: "https://www.amazon.co.jp/gp/your-account/order-history/ref=aw_ya_hp_oh_aui")!))
    }
    //发送的详细 div.a-row:nth-child(18) > div:nth-child(1) > label:nth-child(1) > i:nth-child(2)
    func loadShipHtml(){
        amazonOrderParser.model.printInfo()
        if let url = amazonOrderParser.model.getNextOrder(){
//            statusLabel.text = url.absoluteString
            self.webView.load(
                URLRequest.init(url: url)
            )
        }else{
//            SVProgressHUD.dismiss(withDelay: 0.3)
            status = AmazonOrderParser.StatusType.Checkover
            SVProgressHUD.showSuccess(withStatus: amazonOrderParser.checkoverstr)
            SVProgressHUD.dismiss(withDelay: 2)
            //            statusLabel.text = "over"
            //            indicator.stopAnimating()
            //            if vc == nil{
            //                vc = AmazonOrderTableVC()
            //                vc?.model = amazonOrderParser.model
            //                let nav = MyUINavigationController.init(rootViewController: vc!)
            //                self.present(nav, animated: true, completion: {})
            //            }
            //            self.webbaseview.isHidden = true
        }
        self.tableview.reloadData()
    }
}


extension AmazonOrderWebView: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

