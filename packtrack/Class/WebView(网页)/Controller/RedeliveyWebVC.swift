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
//
class RedeliveyWebVC: BaseViewController, UIWebViewDelegate, GADBannerViewDelegate {
    
    var tracktype:TrackComType?
    let comfunc = ComFunc.shared
    var trackMain:TrackMain?{
        didSet{
            if trackMain != nil{
                tracktype=TrackComType(rawValue: (trackMain?.trackType)!)
            }
        }
    }
    
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var btnForward: UIBarButtonItem!
    @IBOutlet weak var btnRefresh: UIBarButtonItem!
    @IBOutlet weak var btnAutoInput: UIBarButtonItem!
    
    
    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title=comfunc.getCompanyName(tracktype?.rawValue ?? "1")
        
        setupUI()
        setupBarItem()
        onloadUrl()
    }
    
    //MARK : - 获取追踪画面
    func onloadUrl(){
        guard let request = ComFunc.shared.getRedeliveyURL("", tracktype: (tracktype?.rawValue)!) else{
            return
        }
        myWebView.loadRequest(request)

        let tracker: GAITracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEvent(withCategory: "Redelivery_WebView",
            action: trackMain?.trackType,
            label: trackMain?.trackNo, value: nil).build() as! [AnyHashable: Any])
        
        Analytics.logEvent("Redelivery_WebView", parameters:[
            "type": trackMain?.trackType,
            "label": trackMain?.trackNo])
        
    }
}

// MARK: - UI
extension RedeliveyWebVC{
    func setupUI(){
//        self.title = comfunc.getCompanyName(tracktype?.rawValue ?? "1")

        myWebView.delegate = self
        myWebView.backgroundColor=UIColor.gray
        myWebView.scalesPageToFit=true
        
        resetBtnUI()
 
        btnBack.action = #selector(self.gotoBack(_:))
        btnForward.action = #selector(self.gotoForward(_:))
        btnRefresh.action = #selector(self.refreshButtonTapped(_:))
        btnAutoInput.action = #selector(self.autoInput(_:))
    }
    func resetBtnUI(){
        btnBack.isEnabled = myWebView.canGoBack
        btnForward.isEnabled = myWebView.canGoForward
        btnAutoInput.isEnabled=checkAutoInputEnable()
        btnRefresh.isEnabled = true
    }
    
    func setupBarItem(){
        let menuButton = ComUI.getMenuButton()
        menuButton.addTarget(self, action: #selector(self.showMenu(_:)),
                             for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: menuButton),]
    }
    
    func showMenu(_ sender: UIBarButtonItem) {
        let menu_title = comfunc.getCompanyName(tracktype?.rawValue ?? "1")
        let shareMenu = UIAlertController(title: nil, message: menu_title, preferredStyle: .actionSheet)
        let action_edit = UIAlertAction(title: "アカウント情報を修正", style: .default, handler: {(action:UIAlertAction) -> Void in
            self.reinputAccount(self.tracktype!)
        })
        let action_del = UIAlertAction(title: "アカウント情報を削除", style: .default, handler: {(action:UIAlertAction) -> Void in
            self.clearAccount(self.tracktype!)
        })
        let action_openBrowse = UIAlertAction(title: "Webブラウザを起動", style: .default, handler: {(action:UIAlertAction) -> Void in
            self.openWeb(2)
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        if (self.tracktype! ==  TrackComType.Company_yamato
            ||  self.tracktype! == TrackComType.Company_sagawa){
            shareMenu.addAction(action_edit)
            shareMenu.addAction(action_del)
        }
        shareMenu.addAction(action_openBrowse)
        shareMenu.addAction(cancelAction)
        
        shareMenu.modalPresentationStyle = .popover
        if let presentation = shareMenu.popoverPresentationController {
            presentation.barButtonItem = navigationItem.rightBarButtonItems?[0]
        }
        
        self.present(shareMenu, animated: true, completion: nil)
    }
    // 打开Web浏览器
    func openWeb(_ type : Int){
        let url1 = comfunc.getHomePage("",tracktype: self.tracktype?.rawValue ?? "1", type: type)
        if let okurl = URL(string: url1){
            UIApplication.shared.openURL( okurl )
        }
    }
//    func copyNo(){
//        comfunc.copytoPasteBoard(self.strTrackNo)
//        self.view.makeToast(message: "番号をコピーました")
//    }
    func refreshButtonTapped(_ sender: AnyObject) {
        myWebView.reload()
//        resetBtnUI()
    }
    func gotoBack(_ sender: AnyObject) {
        myWebView.goBack()
//        resetBtnUI()
    }
    func gotoForward(_ sender: AnyObject) {
        myWebView.goForward()
//        resetBtnUI()
    }
    func autoInput(_ sender: AnyObject) {
        print(getAutoInputString(tracktype!))
        myWebView.stringByEvaluatingJavaScript(from: getAutoInputString(tracktype!))
    }
}

// MARK: - NetWork
extension RedeliveyWebVC{
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        myActivityIndicator.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        myActivityIndicator.stopAnimating()
        myActivityIndicator.isHidden = true
        resetBtnUI()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    }
}

// MARK: Web自动处理
extension RedeliveyWebVC{
    func checkAutoInputEnable()->Bool{
        guard let url = myWebView.request?.url?.absoluteString else{
            return false
        }
        print(myWebView.request?.url?.absoluteString)
        if self.tracktype == TrackComType.Company_yamato {
            if url.contains(yamato_login_url){
                return true
            }
            if url.contains(yamato_input_trackno){
                guard (trackMain != nil) else{
                    return false
                }
                return true
            }
        }
        if self.tracktype == TrackComType.Company_sagawa {
            if url.contains(sagawa_login_url){
                return true
            }
            if url.contains(sagawa_input_trackno){
                guard (trackMain != nil) else{
                    return false
                }
                return true
            }
        }
        return false
    }
    func getAutoInputString(_ trackType:TrackComType)->String{
        var id = ""
        var pass = ""
        if !haveAccount(trackType){
            popAccountDialog(trackType)
            return ""
        }
        (id,pass)=getAccount(trackType)
        
        guard let url = myWebView.request?.url?.absoluteString else{
            return ""
        }
        if self.tracktype == TrackComType.Company_yamato {
            if url.contains(yamato_login_url){
                return String(format: autoinput_yamato_login, arguments: [id,pass])
            }
            if url.contains(yamato_input_trackno){
                guard let no = trackMain?.trackNo else{
                    return ""
                }
                return String(format: autoinput_yamato_trackno, arguments: [no])
            }
        }
        if self.tracktype == TrackComType.Company_sagawa {
            if url.contains(sagawa_login_url){
                return String(format: autoinput_sagawa_login, arguments: [id,pass])
            }
            if url.contains(sagawa_input_trackno){
                guard let no = trackMain?.trackNo else{
                    return ""
                }
                return String(format: autoinput_sagawa_trackno, arguments: [no])
            }
        }
        return ""
    }
    // MARK: 用户名密码框
    func popAccountDialog(_ trackType:TrackComType){
        let (id,pass) = getAccount(self.tracktype!)
        
        let alert:UIAlertController = UIAlertController(title:"自動ログインのため",
                                                        message: "アカウント情報をローカルに保存する",
                                                        preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
                                                       style: UIAlertActionStyle.cancel,
                                                       handler:{
                                                        (action:UIAlertAction!) -> Void in
        })
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK",
               style: UIAlertActionStyle.default,handler:{
                       (action:UIAlertAction!) -> Void in
                    let textFields:Array<UITextField>? =  alert.textFields as Array<UITextField>?
                    if textFields != nil {
//                           for textField:UITextField in textFields! {print(textField.text)}
                        guard let id = textFields?[0].text,
                            let pass = textFields?[1].text
                        else{
                            return
                        }
                        if self.saveAccount(trackType, id: id, pass: pass){
                            self.autoInput(NSObject())
                        }
                    }
        })
        alert.addTextField(configurationHandler: {(text:UITextField!) -> Void in
            text.placeholder = "IDを入力してください"
            let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
            label.text = "ID"
            text.leftView = label
            text.leftViewMode = UITextFieldViewMode.always
            text.text=id
        })
        alert.addTextField(configurationHandler: {(text:UITextField!) -> Void in
            text.placeholder = "パスワードを入力してください"
            let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
            label.text = "PASS"
            text.leftView = label
            text.leftViewMode = UITextFieldViewMode.always
            text.isSecureTextEntry=true
            text.text=pass
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    func haveAccount(_ trackType:TrackComType)->Bool{
        if trackType == TrackComType.Company_yamato{
            guard let ret =  UserDefaults.standard.value(forKey: key_yamato_account) as? Bool else{
                return false
            }
            return ret
        }
        if trackType == TrackComType.Company_sagawa{
            guard let ret =  UserDefaults.standard.value(forKey: key_sagawa_account) as? Bool else{
                return false
            }
            return ret
        }
        return false
    }
    func getAccount(_ trackType:TrackComType)->(String,String){
        if trackType == TrackComType.Company_yamato{
            let user = UserDefaults.standard.value(forKey: key_yamato_account_id) as? String ?? ""
            let pass = UserDefaults.standard.value(forKey: key_yamato_account_pass) as? String ?? ""
            return (user,pass)
        }
        if trackType == TrackComType.Company_sagawa{
            let user = UserDefaults.standard.value(forKey: key_sagawa_account_id) as? String ?? ""
            let pass = UserDefaults.standard.value(forKey: key_sagawa_account_pass) as? String ?? ""
            return (user,pass)
        }
        return("","")
    }
    func saveAccount(_ trackType:TrackComType,id:String,pass:String)->Bool{
//        print(trackType)
//        print(id)
//        print(pass)
        if(id.characters.count==0 || pass.characters.count==0){
            self.view.makeToast(message: "アカウント情報保存失敗")
            return false
        }
        if trackType == TrackComType.Company_yamato{
            UserDefaults.standard.set(id, forKey: key_yamato_account_id)
            UserDefaults.standard.set(pass, forKey: key_yamato_account_pass)
            UserDefaults.standard.set(true, forKey: key_yamato_account)
            UserDefaults.standard.synchronize()
            self.view.makeToast(message: "アカウント情報保存済み")
            return true
        }
        if trackType == TrackComType.Company_sagawa{
            UserDefaults.standard.set(id, forKey: key_sagawa_account_id)
            UserDefaults.standard.set(pass, forKey: key_sagawa_account_pass)
            UserDefaults.standard.set(true, forKey: key_sagawa_account)
            UserDefaults.standard.synchronize()
            self.view.makeToast(message: "アカウント情報保存済み")
            return true
        }
        return false
    }
    func clearAccount(_ trackType:TrackComType){
        if trackType == TrackComType.Company_yamato{
            UserDefaults.standard.set("", forKey: key_yamato_account_id)
            UserDefaults.standard.set("", forKey: key_yamato_account_pass)
            UserDefaults.standard.set(false, forKey: key_yamato_account)
            UserDefaults.standard.synchronize()
            self.view.makeToast(message: "アカウント情報削除しました")
        }
        if trackType == TrackComType.Company_sagawa{
            UserDefaults.standard.set("", forKey: key_sagawa_account_id)
            UserDefaults.standard.set("", forKey: key_sagawa_account_pass)
            UserDefaults.standard.set(false, forKey: key_sagawa_account)
            UserDefaults.standard.synchronize()
            self.view.makeToast(message: "アカウント情報削除しました")
        }
    }
    func reinputAccount(_ trackType:TrackComType){
        popAccountDialog(trackType)
    }
}




