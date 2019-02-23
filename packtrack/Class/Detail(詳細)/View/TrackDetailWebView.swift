//
//  TrackDetailWebView.swift
//  packtrack
//
//  Created by ksymac on 2017/03/25.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit
import GoogleMobileAds

class TrackDetailWebView: UIView , UIWebViewDelegate{
    @IBOutlet weak var webView: UIWebView!{
        didSet {
             webView.delegate=self
        }
    }
    @IBOutlet weak var loadingView: UIActivityIndicatorView!{
        didSet {
            loadingView.startAnimating()
        }
    }
    var trackMain : TrackMain?{
        didSet {
            onloadUrl()
        }
    }
    @IBOutlet weak var ADView: UIView!
    @IBOutlet weak var ADViewHeight: NSLayoutConstraint!
//    var rootViewController:UIViewController?
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    class func instanceFromNib() -> TrackDetailWebView {
        if let x =  Bundle.main.loadNibNamed( "TrackDetailWebView", owner: nil, options: nil){
            let nibView = x[0] as! TrackDetailWebView
            return nibView
        }
        return TrackDetailWebView.init()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        webView.scalesPageToFit=true
    }
    
    override func layoutSubviews() {
//        print("-----webview--layoutSubviews-----")
    }
    //MARK : - 获取追踪画面
    func onloadUrl(){
        if trackMain == nil{
            return
        }
        
        
        switch (trackMain!.trackType) {
        case comfunc.Company_seino:
            seino();
            break;
        case comfunc.Company_tmg:
            tmg();
            break;
        default:
            guard let request = ComFunc.shared.getTrackURL(trackMain!.trackNo, tracktype: trackMain!.trackType) else{
                return
            }
            webView.loadRequest(request)
        }
        
        let tracker: GAITracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEvent(withCategory: "WebView", action: trackMain?.trackType,
            label: trackMain?.trackNo, value: nil).build() as! [AnyHashable: Any])
        
        self.initAdmobView()
    }
    
    
    
    func seino(){
        var str : String
        str = "<form name='gempyoNoShokaiSpnListForm' method='POST' action='http://track.seino.co.jp/kamotsu/gempyoNoShokaiSpn.do' >";
        str += "<input type='hidden' name='GNPNO1' size='14' maxlength='12' class='GNPNO1' value='##mytrack_no##'/>";
        str += "<input type='hidden' name='action' value='InquirySpn' >";
        str += "</form>  <script type='text/javascript'>document.gempyoNoShokaiSpnListForm.submit();</script>";
        str = str.replacingOccurrences(of: "##mytrack_no##", with: (trackMain?.trackNo)!, options: [], range: nil)
        webView.loadHTMLString(str, baseURL: nil)
    }
    func tmg(){
        let url = NSURL (string: "http://track-a.tmg-group.jp/cts/TmgCargoSearchAction.do?method_id=INIT")
        let request = NSMutableURLRequest(url: url! as URL)
        webView.loadRequest(request as URLRequest)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        loadingView.startAnimating()
    }
    
    
    let javascript_tmg_1 = "document.getElementsByName( 'inputData[0].inq_no' )[0].value = '%@';"//document.TmgCargoSearchForm.submit();
    let javascript_tmg_submit_1 = "document.TmgCargoSearchForm.search.click();"//document.TmgCargoSearchForm.submit();
    let javascript_tmg_submit_2 = "document.getElementsByName( 'dtl_show_btn' )[0].click();"//document.TmgCargoSearchForm.submit();
    var count = 0
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        if trackMain?.trackType == comfunc.Company_tmg {
            loadingView.stopAnimating()
            loadingView.isHidden = true
            if count == 0 {
                count += 1
                let javascript1 = getAutoInputString(trackType: (trackMain?.trackType)! ,no: (trackMain?.trackNo)!)
                print(javascript1)
                webView.stringByEvaluatingJavaScript(from: javascript1)
                webView.stringByEvaluatingJavaScript(from: javascript_tmg_submit_1)
            }
            
            webView.stringByEvaluatingJavaScript(from: javascript_tmg_submit_2)
            webView.scrollView.zoomScale = 1.2
        }else{
            
            loadingView.stopAnimating()
            loadingView.isHidden = true
        }
    }
    
    func getAutoInputString(trackType:String, no:String)->String{
        if trackType == comfunc.Company_tmg {
            return String(format: javascript_tmg_1, arguments: [no])
        }
        return ""
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
}

extension TrackDetailWebView:GADBannerViewDelegate{
    func initAdmobView(){
//        #if FREE
//            var admobView: GADBannerView = GADBannerView()
//            admobView = GADBannerView(adSize:kGADAdSizeBanner)
//            admobView.frame.origin = CGPoint(x:0, y:0)
//            admobView.frame.size = CGSize(width:self.frame.width, height:self.frame.height)
//            admobView.adUnitID = AdMobID_ADDView
//            admobView.delegate = self
//            admobView.rootViewController = self.rootViewController
//            let admobRequest:GADRequest = GADRequest()
//            admobView.load(admobRequest)
//            ADViewHeight.constant = admobView.frame.height
//            self.ADView.addSubview(admobView)
//        #else
//            self.ADViewHeight.constant=0
//        #endif
    }
    
    func addAdmobBannerView(bannerview :GADBannerView){
        ADViewHeight.constant = bannerview.frame.height
        self.ADView.addSubview(bannerview)
    }
}




