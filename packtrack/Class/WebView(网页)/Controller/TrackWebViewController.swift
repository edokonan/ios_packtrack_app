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


class TrackWebViewController: UIViewController, UIWebViewDelegate, GADBannerViewDelegate {
    
    //let SimulatorTest:Bool = true
//    @IBOutlet weak var ADView: UIView!
    
    @IBOutlet weak var ADView: UIView!
    @IBOutlet weak var ADViewHeight: NSLayoutConstraint!
    
    //@IBOutlet weak var viewTitle: UINavigationItem!
    var strTrackNo : String = ""
    var strTrackType : String = ""
    var strComment : String = ""
    var strCommentTitle : String = ""
//    var intFormView : Int = 0
    
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
        

        let b = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(TrackWebViewController.sayHello(_:)))
        self.navigationItem.rightBarButtonItem = b
        
        myWebView.delegate = self
        myWebView.scalesPageToFit = true
        //1. Load web site into my web view
        //let myURL = NSURL(string: "http://www.swiftdeveloperblog.com");
        //let myURLRequest:NSURLRequest = NSURLRequest(URL: myURL!);
        //myWebView.loadRequest(myURLRequest);
        onloadUrl()
        #if FREE
        if MyUserDefaults.shared.getPurchased_ADClose(){
            ADViewHeight.constant = 0
        }else{
//            self.initADView()
//            self.loadFiveAD()
        }
            ADViewHeight.constant = 0
        #else
            ADViewHeight.constant = 0
        #endif
        
        
        let tracker: GAITracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEvent(withCategory: "TrackWebViewController",
                                                      action: strTrackType,
                                                      label: strTrackNo, value: nil).build() as! [AnyHashable: Any])
        Analytics.logEvent("TrackWebViewController", parameters: [
            "type": strTrackType,
            "no": strTrackNo])
    }
    
    func onloadUrl(){
        var url1 : String;
        //String postData ;
        switch (strTrackType) {
/**        case comfunc.Company_jppost:
            url1="http://tracking.post.japanpost.jp/services/sp/srv/search/?search=start&locale=ja&requestNo1=" + strTrackNo
            myWebView.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: url1)!))
            break
        case comfunc.Company_yamato:
            url1 = "http://smp.kuronekoyamato.co.jp/smp/tneko";
            break;
        case comfunc.Company_sagawa:
            url1 = "http://k2k.sagawa-exp.co.jp/p_smt/web/smtOkurijoSearch.do";
            break;
        case comfunc.Company_dhljp:
            url1="http://www.dhl.co.jp/ja/express/tracking.html?AWB=##mytrack_no##&brand=DHL";
            url1 = url1.stringByReplacingOccurrencesOfString("##mytrack_no##", withString: strTrackNo, options: nil, range: nil)
            myWebView.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: url1)!))
            break;
        case comfunc.Company_fedexjp:
            url1="https://www.fedex.com/apps/fedextrack/?atcion=track&cntry_code=jp&tracknumbers=##mytrack_no##";
            url1 = url1.stringByReplacingOccurrencesOfString("##mytrack_no##", withString: strTrackNo, options: nil, range: nil)
            myWebView.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: url1)!))
            break;
        case comfunc.Company_usps:
            url1="https://tools.usps.com/go/TrackConfirmAction.action?tRef=fullpage&tLc=1&text28777=&tLabels=##mytrack_no##";
            url1 = url1.stringByReplacingOccurrencesOfString("##mytrack_no##", withString: strTrackNo, options: nil, range: nil)
            myWebView.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: url1)!))
            break;
**/
        case comfunc.Company_seino:
            seino()
            break
        case comfunc.Company_nittsu:
            url1="https://lp-trace.nittsu.co.jp/web/webarpaa702.srv?LANG=JP&denpyoNo1=##mytrack_no##";
            url1 = url1.replacingOccurrences(of: "##mytrack_no##", with: strTrackNo, options: [], range: nil)
            if let okurl = URL(string: url1){
                myWebView.loadRequest(URLRequest(url: okurl))
            }
            break;
        case comfunc.Company_katlec:
            //url1="http://www6.katolec.com/tracking/amzn/tracking.aspx";
            katelc();
            break;
        case comfunc.Company_fukutsu:
            fukutsu();
            break;
        case comfunc.Company_tmg:
            tmg();
            break;
        default:
            break;
        }
        let tracker: GAITracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEvent(withCategory: "WebView", action: strTrackType,
            label: strTrackNo, value: nil).build() as! [AnyHashable: Any])
        
    }
    func seino(){
        var str : String
        str = "<form name='gempyoNoShokaiSpnListForm' method='POST' action='http://track.seino.co.jp/kamotsu/gempyoNoShokaiSpn.do' >";
        str += "<input type='hidden' name='GNPNO1' size='14' maxlength='12' class='GNPNO1' value='##mytrack_no##'/>";
        str += "<input type='hidden' name='action' value='InquirySpn' >";
        str += "</form>  <script type='text/javascript'>document.gempyoNoShokaiSpnListForm.submit();</script>";
        str = str.replacingOccurrences(of: "##mytrack_no##", with: strTrackNo, options: [], range: nil)
        myWebView.loadHTMLString(str, baseURL: nil)
    }
    func katelc(){
        var str : String
        str = "<form name='trackingForm' method='post' action='http://www6.katolec.com/tracking/amzn/tracking.aspx' id='trackingForm'><table class='postform' summary='Post Form'>";
        str += "<input type='hidden' name='__VIEWSTATE' id='__VIEWSTATE' value='/wEPDwULLTE0MTA3MzMzNThkGAEFDFRyYWNraW5nTGlzdA9nZAfIQFlgFqS7P/u5HUr8EfdrPiY8ocXxrjNbmjWJufAv' />";
        str += "<input type='hidden' name='__VIEWSTATEGENERATOR' id='__VIEWSTATEGENERATOR' value='CBF84120' />";
        str += "<input type='hidden' name='__EVENTVALIDATION' id='__EVENTVALIDATION' value='/wEdAAJCU6YYB/vm+W2qKMzAGyBei5jimmfuaC3y5dywSB+k6NXwEJKu1R11WIzSF6KCa/t/4512GrortmQTh3w3omUw' />";
        str += "<tr><td><input name='inputDenpyo' type='hidden' id='inputDenpyo' value='##mytrack_no##'/>" +
        "</td></tr></table>";//<input type='submit' class='submit post' id='comment-post' name='post' value=''/>
        str += "</form>  <script type='text/javascript'>document.trackingForm.submit();</script>";
        //str=str.replace("##mytrack_no##", str_trackno);
        str = str.replacingOccurrences(of: "##mytrack_no##", with: strTrackNo, options: [], range: nil)
        
        //document.body.innerHTML += "";
        myWebView.loadHTMLString(str, baseURL: nil)
        //String htmlDocument = str;
        //webview.loadDataWithBaseURL(null, htmlDocument, "text/HTML", "UTF-8", null);
    }
    
    func fukutsu(){
        var str : String
        str = "<FORM name='topForm' method='post' id='trackingForm' ACTION='http://corp.fukutsu.co.jp//situation/tracking_no_hunt'>";
        str += "<input name='data[TrackingNo][tracking_no]' type='hidden' id='tracking_no' value='##mytrack_no##'>";
        str += "<input type='hidden' value='rightMenuTrackNo' id='rightMenuTrackNo' name='data[TrackingNo][rightMenuTrackNo]'></form>";
        str += "<script type='text/javascript'>document.topForm.submit();</script>";
        str = str.replacingOccurrences(of: "##mytrack_no##", with: strTrackNo, options: [], range: nil)
        myWebView.loadHTMLString(str, baseURL: nil)
    }
    
    func tmg(){
        let url = NSURL (string: "http://track-a.tmg-group.jp/cts/TmgCargoSearchAction.do?method_id=INIT")
        let request = NSMutableURLRequest(url: url! as URL)
        myWebView.loadRequest(request as URLRequest)
    }
    
    
    
//search=%8F%C6%89%EF%82%B7%82%E9&inputData%5B0%5D.inq_no=551107061875&inputData%5B1%5D.inq_no=&inputData%5B2%5D.inq_no=&inputData%5B3%5D.inq_no=&inputData%5B4%5D.inq_no=&inputData%5B5%5D.inq_no=&inputData%5B6%5D.inq_no=&inputData%5B7%5D.inq_no=&inputData%5B8%5D.inq_no=&inputData%5B9%5D.inq_no=&method_id=POPUPSEA
//    search=照会する&inputData[0].inq_no=551107061875&inputData[1].inq_no=&inputData[2].inq_no=&inputData[3].inq_no=&inputData[4].inq_no=&inputData[5].inq_no=&inputData[6].inq_no=&inputData[7].inq_no=&inputData[8].inq_no=&inputData[9].inq_no=&method_id=POPUPSEA
//    dtl_show_btn=%8F%DA%8D%D7%8F%EE%95%F1%82%F0%95%5C%8E%A6%82%B7%82%E9&method_id=DTL_SHOW&tmp_mani_num=1651085008&tmp_trk_id=551107061875&tmp_item_num=1&tmp_cust_ord_num=FF1-1706624-4090070
//  dtl_show_btn=詳細情報を表示する&method_id=DTL_SHOW&tmp_mani_num=1651085008&tmp_trk_id=551107061875&tmp_item_num=1&tmp_cust_ord_num=FF1-1706624-4090070
    //                            <input type="submit" name="dtl_show_btn" value="詳細情報を表示する" onclick="setSubmitInfo(2,'1651085008','551107061875','1','FF1-1706624-4090070');" id="dtl_show_btn1">
    
    func sayHello(_ sender: UIBarButtonItem) {
        let alert = SCLAlertView()
        alert.addButton("Webブラウザを起動") {self.openWeb(2)}
        alert.addButton("再配達サイトへ") {self.openWeb(1)}
        alert.addButton("ホームサイトへ") {self.openWeb(0)}
        alert.addButton("追跡番号をコピー") {self.copyNo()}
        alert.showWait("メニュー", subTitle: "", closeButtonTitle:"キャンセル" )//, colorStyle: UIColor.orangeColor() 0xFF9800,  colorStyle: UIColor.MKColor.Orange
    }
    func openWeb(_ type : Int){
        let url1 = comfunc.getHomePage(self.strTrackNo,tracktype: self.strTrackType , type: type)
        self.copyNo()
        if let okurl = URL(string: url1){
            UIApplication.shared.openURL( okurl )
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
        //myActivityIndicator.hidden = false
    }

    let javascript_tmg_1 = "document.getElementsByName( 'inputData[0].inq_no' )[0].value = '%@';"//document.TmgCargoSearchForm.submit();
    let javascript_tmg_submit_1 = "document.TmgCargoSearchForm.search.click();"//document.TmgCargoSearchForm.submit();
    let javascript_tmg_submit_2 = "document.getElementsByName( 'dtl_show_btn' )[0].click();"//document.TmgCargoSearchForm.submit();
    var count = 0
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        myActivityIndicator.stopAnimating()
        myActivityIndicator.isHidden = true
        if strTrackType == comfunc.Company_tmg {
            if count == 0 {
                count += 1
                let javascript1 = getAutoInputString(trackType: strTrackType ,no: self.strTrackNo)
                print(javascript1)
                myWebView.stringByEvaluatingJavaScript(from: javascript1)
                myWebView.stringByEvaluatingJavaScript(from: javascript_tmg_submit_1)
            }
//            if count == 1 {
//                count += 1
                myWebView.stringByEvaluatingJavaScript(from: javascript_tmg_submit_2)
//            }
        }
    }
    
    func getAutoInputString(trackType:String, no:String)->String{
        if trackType == comfunc.Company_tmg {
            return String(format: javascript_tmg_1, arguments: [no])
        }
        return ""
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        //print(error)
    }
    
    @IBAction func refreshButtonTapped(_ sender: AnyObject) {
        myWebView.reload()
    }
}
