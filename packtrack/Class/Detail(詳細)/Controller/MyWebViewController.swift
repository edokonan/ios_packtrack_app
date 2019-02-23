//
//  TrackWebViewController.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/14.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//
import UIKit
import GoogleMobileAds
import FirebaseAnalytics

class MyWebViewController: UIViewController, UIWebViewDelegate, GADBannerViewDelegate {
    

    var strTrackNo : String = ""
    var strTrackType : String = ""
    var strComment : String = ""
    var strCommentTitle : String = ""

    var trackMain : TrackMain?
    var webType : Int = 0 // 0
    
    var intFormView : Int = 0
    
    let comfunc = ComFunc()

    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController?.navigationBar
        nav?.isTranslucent = false
        nav?.barTintColor = UIColor(red: 80.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        //viewTitle.title = strTrackNo
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.title = strTrackNo
        
        let b = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(MyWebViewController.barMenu(_:)))
        self.navigationItem.rightBarButtonItem = b
        
        myWebView.delegate = self
        myWebView.scalesPageToFit=true
        onloadUrl()
    }
    
    func onloadUrl(){
        let url1 : String=ComFunc().getHomePage(trackMain!.trackNo, tracktype: trackMain!.trackType, type: webType)
        if let okurl = URL(string: url1){
            myWebView.loadRequest(URLRequest(url: okurl))
        }else{
            
        }
        let tracker: GAITracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEvent(withCategory: "WebView", action: strTrackType,
            label: strTrackNo, value: nil).build() as! [AnyHashable: Any])
        
        Analytics.logEvent("WebView_GetData_API", parameters: [
            "type": strTrackType,
            "label": strTrackNo
            ])
    }
    func barMenu(_ sender: UIBarButtonItem) {
        let alert = SCLAlertView()
        alert.addButton("Webブラウザを起動") {self.openWeb(2)}
        alert.addButton("再配達サイトへ") {self.openWeb(1)}
        alert.addButton("ホームサイトへ") {self.openWeb(0)}
        alert.addButton("追跡番号をコピー") {self.copyNo()}
        alert.showWait("メニュー", subTitle: "", closeButtonTitle:"キャンセル" )
        //colorStyle: UIColor.orangeColor() 0xFF9800,  colorStyle: UIColor.MKColor.Orange
    }
    func openWeb(_ type : Int){
        let url1 = comfunc.getHomePage(self.strTrackNo,tracktype: self.strTrackType , type: type)
        self.copyNo()
        if let okurl = URL(string: url1){
            UIApplication.shared.openURL( okurl )
        }else{
            
        }
        
        
    }
    
    func copyNo(){
        comfunc.copytoPasteBoard(self.strTrackNo)
        self.view.makeToast(message: "番号をコピーました")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        myActivityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        myActivityIndicator.stopAnimating()
        myActivityIndicator.isHidden = true
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    }
    
    @IBAction func refreshButtonTapped(_ sender: AnyObject) {
        myWebView.reload()
    }
}
