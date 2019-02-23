//
//  MoreTableViewController.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/13.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import UIKit
//import MessageUI
import Firebase
import TOWebViewController
import DZNWebViewController

class ToolBoxTableViewController: UITableViewController  , GADBannerViewDelegate {
    var myScanVC = DIYScanViewController.init()
    
    @IBOutlet weak var ADView: UIView!
//    @IBOutlet weak var ADViewHeight: NSLayoutConstraint!
    
    
    var SectionS : [SectionType] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 80.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().barStyle = UIBarStyle.default

        
        let appDelegate:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
        appDelegate.toolBoxTableViewController = self
        
        setupSections();
        
        self.initADView()
    }
    func initADView(){
        #if FREE
        if MyUserDefaults.shared.getPurchased_ADClose(){
            self.ADView.frame.size = CGSize(width: self.ADView.frame.width, height: 0)
            self.ADView.removeFromSuperview()
        }else{
            var admobView: GADBannerView = GADBannerView()
            admobView = GADBannerView(adSize:kGADAdSizeBanner)
            admobView.frame.origin = CGPoint(x:0, y:0)
            admobView.frame.size = CGSize(width: self.view.frame.width, height:admobView.frame.height)
            admobView.adUnitID = AdMobID_RedeliveryView
            admobView.delegate = self
            admobView.rootViewController = self
            
            let admobRequest:GADRequest = GADRequest()
            admobView.load(admobRequest)
            
            self.ADView.frame.size = CGSize(width: self.ADView.frame.width, height: admobView.frame.height)
            self.ADView.addSubview(admobView)
        }
        #else
        self.ADView.frame.size = CGSize(width: self.ADView.frame.width, height: 0)
        self.ADView.removeFromSuperview()
        #endif
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SectionS.count;
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SectionS[section].rows.count;
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SectionS[section].title;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "moreTableViewCell")
        cell.textLabel?.text = SectionS[indexPath.section].rows[indexPath.row].title
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SectionS[indexPath.section].rows[indexPath.row].complete!()
    }
}

// MARK: - ACTION的处理
extension ToolBoxTableViewController{
    func setupSections(){
        SectionS=[]
        let section1 = SectionType(title: "不在連絡票")
        section1.rows.append(RowType(title: "ご不在連絡票をスキャン", complete: {
            Analytics.logEvent("ご不在連絡票をスキャン", parameters: nil)
            self.scanUndeliverableItemNotice();
        }))
        SectionS.append(section1)
        
        let section2 = SectionType(title: "ECサイト")
        section2.rows.append(RowType(title: "Amazon", complete: {
            let url = URL.init(string: "https://www.amazon.co.jp")
            let WVC = MyDZNWebViewController.init(url: url)
            WVC?.supportedWebNavigationTools = DZNWebNavigationTools.all
            WVC?.supportedWebActions = DZNsupportedWebActions.DZNWebActionAll
            WVC?.showLoadingProgress = true
            WVC?.allowHistory = true
            WVC?.hideBarsWithGestures = true
            let nav = MyUINavigationController.init(rootViewController: WVC!)
            self.present(nav, animated: true, completion: nil)
//            self.navigationController?.pushViewController(WVC!, animated: true)
        }))
//        section2.rows.append(RowType(title: "送料調査", complete: {
//            let vc = TOWebViewController.init(url: URL.init(string: "https://www.shipping.jp/"))
//            let nav = UINavigationController.init(rootViewController: vc!)
//            self.present(nav, animated: true, completion: {
//            })
//        }))
        SectionS.append(section2)
//        #if FREE
//            let section3 = SectionType(title: "ad")
//            section3.rows.append(RowType(title: "ad", complete: {
//                            self.showAD();
//                        }))
//            SectionS.append(section3)
//        #else
//        #endif
        let section5 = SectionType(title: "宅配業者")
        section5.rows.append(RowType(title: "日本郵便", complete: {
            Analytics.logEvent("宅配業者", parameters: [
                "type": "日本郵便",])
            self.movetoCompanyPage(TrackComType.Company_jppost)
        }))
        section5.rows.append(RowType(title: "ヤマト運輸", complete: {
            Analytics.logEvent("宅配業者", parameters: [
                "type": "ヤマト運輸",])
            self.movetoCompanyPage(TrackComType.Company_yamato)
            
        }))
        section5.rows.append(RowType(title: "佐川急便", complete: {
            Analytics.logEvent("宅配業者", parameters: [
                "type": "佐川急便",])
            self.movetoCompanyPage(TrackComType.Company_sagawa)
            
        }))
        section5.rows.append(RowType(title: comfunc.getCompanyName(TrackComType.Company_seino.rawValue), complete: {
            Analytics.logEvent("宅配業者", parameters: [
                "type": "Company_seino",])
            self.movetoCompanyPage(TrackComType.Company_seino)
        }))

        section5.rows.append(RowType(title: "デリバリープロバイダ(T.M.G)", complete: {
            Analytics.logEvent("宅配業者", parameters: [
                "type": "TMG",])
            self.movetoCompanyPage(TrackComType.Company_tmg)
        }))
        section5.rows.append(RowType(title: comfunc.getCompanyName(TrackComType.Company_katlec.rawValue), complete: {
            Analytics.logEvent("宅配業者", parameters: [
                "type": "Company_katlec",])
            self.movetoCompanyPage(TrackComType.Company_katlec)
        }))
        SectionS.append(section5)
        
        let section4 = SectionType(title: "再配達サイト")
        section4.rows.append(RowType(title: "日本郵便", complete: {
            Analytics.logEvent("再配達サイト", parameters: [
                "type": "日本郵便",])
            self.movetoHomePage(TrackComType.Company_jppost);
        }))
        section4.rows.append(RowType(title: "ヤマト運輸", complete: {
            Analytics.logEvent("再配達サイト", parameters: [
                "type": "ヤマト運輸",])
            self.movetoHomePage(TrackComType.Company_yamato);
        }))
        section4.rows.append(RowType(title: "佐川急便", complete: {
            Analytics.logEvent("再配達サイト", parameters: [
                "type": "佐川急便",])
            self.movetoHomePage(TrackComType.Company_sagawa);
        }))
        SectionS.append(section4)
    }
    
    // MARK:整理ボックス追加
    func popBoxSetting(){
        // 遷移するViewを定義する.このas!はswift1.2では as?だったかと。
        let detailViewController: MoreBoxTableViewController =
        self.storyboard?.instantiateViewController(withIdentifier: "moreboxtableview") as! MoreBoxTableViewController
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated:true)
    }
    
    // MARK:正式版を購入
    func movetoprostare(){
        let url  = URL(string: "itms-apps://itunes.apple.com/app/id1048459282")//free id1031589055
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.openURL(url!)
        }
    }
    // MARK:ホームページへ遷移
    func movetoHomePage(_ tracktype:TrackComType){
        //　MARK: 显示再配達View
        let storyboard: UIStoryboard = UIStoryboard(name: "WebView", bundle: nil)
        let webViewController: RedeliveyWebVC = storyboard.instantiateViewController(withIdentifier: "RedeliveyWebVC") as! RedeliveyWebVC
        webViewController.hidesBottomBarWhenPushed = true//
        webViewController.trackMain=nil
        webViewController.tracktype=tracktype
        self.navigationController?.pushViewController(webViewController, animated:true)
    }
    
    func showAD(){
        GADRewardBasedVideoAd.sharedInstance().delegate = self as! GADRewardBasedVideoAdDelegate
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: "ca-app-pub-5780207203103146/3444835581")
        
    }
    
    // MARK:運送業者HomePageへ遷移
    func movetoCompanyPage(_ tracktype:TrackComType){
        let comHomePageVC:CompanyViewController =  CompanyViewController(tracktype:tracktype)
        self.navigationController?.pushViewController(comHomePageVC, animated:true)
    }
    
    
}

