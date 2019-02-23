//
//  TrackDetailMainVC.swift
//  packtrack
//
//  Created by ksymac on 2017/03/24.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//
import UIKit
import GoogleMobileAds
import FirebaseAnalytics

protocol TrackDetailViewDelegate : NSObjectProtocol{
    func movetoEditView(_ bean:TrackMain)-> ()
}

class TrackDetailMainVC: BaseViewController,GADBannerViewDelegate {
    @IBOutlet weak var MainScrollView: UIScrollView!
    @IBOutlet weak var ADView: UIView!
    @IBOutlet weak var ADViewHeight: NSLayoutConstraint!
    
    var trackMain : TrackMain?
    var refresDataWithClickNotification : Bool?
    let webView = TrackDetailWebView.instanceFromNib()
    let tableView = TrackDetailTableView.instanceFromNib()
    var delegate: TrackDetailViewDelegate?
    
//    let trackMainModel = TrackMainModel.shared//model
//    let trackDetailModel = TrackDetailModel.shared//model
    
    var initFromEditView = false
    var admobView: GADBannerView = GADBannerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setBarItemUI()
        
        if let b =  refresDataWithClickNotification,
            b == true{
            self.tableView.getJsonData()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        MainScrollView.backgroundColor = UIColor.gray
        resizeUI()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if initFromEditView {
            self.tableView.getJsonData()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "DetailView")
        let params = GAIDictionaryBuilder.createScreenView().build() as! [AnyHashable: Any]
        tracker?.send(params)
        
        Analytics.setScreenName("DetailView", screenClass: FIRAnalytics_Screen_Class1)
    }
    
}

// MARK: - 设置视图
let screenWidth  = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
extension TrackDetailMainVC{
    func setupUI() {
        //设置滑动视图
        MainScrollView.contentSize = CGSize(width: screenWidth*2, height: screenHeight)
        MainScrollView.isPagingEnabled = true
        MainScrollView.showsHorizontalScrollIndicator=false
        MainScrollView.showsVerticalScrollIndicator=false
        MainScrollView.bounces=false
        MainScrollView.isScrollEnabled=false

        //插入表格视图
        MainScrollView.addSubview(tableView)
        tableView.trackMain = self.trackMain
        
        //插入网页视图
        MainScrollView.addSubview(webView)
        webView.trackMain = self.trackMain
        
        //插入导航栏中心控制视图
        let rightTitle = ComFunc.shared.getCompanyName((trackMain?.trackType)!) ?? "HomePage"
        let runkeeperSwitch = ComUI.SwitchView("MY宅配便", rightTitle: rightTitle)
        runkeeperSwitch.addTarget(self, action: #selector(self.switchValueDidChange(_:)),
                                  for: .valueChanged)
        navigationItem.titleView = runkeeperSwitch
        
        self.initADView()
    }

    func initADView(){
        #if FREE
        if MyUserDefaults.shared.getPurchased_ADClose(){
            ADViewHeight.constant=0
        }else{
            admobView = GADBannerView(adSize:kGADAdSizeBanner)
            admobView.frame.origin = CGPoint(x:0, y:0)
            admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
            admobView.adUnitID = AdMobID_DetailView
            admobView.delegate = self
            admobView.rootViewController = self
            let admobRequest:GADRequest = GADRequest()
            admobView.load(admobRequest)
            ADViewHeight.constant = admobView.frame.height
            self.ADView.addSubview(admobView)
        }
        #else
            ADViewHeight.constant=0
        #endif
    }
    func resizeUI() {
        tableView.frame=CGRect(x: 0, y: 0, width: screenWidth, height: MainScrollView.bounds.height)
        MainScrollView.addSubview(tableView)
        
        webView.frame=CGRect(x: screenWidth, y: 0, width: screenWidth, height: MainScrollView.bounds.height)
        MainScrollView.addSubview(webView)
    }
    
    // MARK: 切换视图
    func switchValueDidChange(_ sender: DGRunkeeperSwitch!) {
        if(sender.selectedIndex==0){
            MainScrollView.contentOffset = CGPoint(x: 0, y: 0)
        }else{
            MainScrollView.contentOffset = CGPoint(x: screenWidth, y: 0)
        }
    }
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        ADViewHeight.constant = bannerView.frame.height
//        self.ADView.addSubview(bannerView)
//    }
}
let comfunc = ComFunc.shared
// MARK: 菜单中的各个事件
extension TrackDetailMainVC{
    // 设置BarItemUI
    func setBarItemUI(){
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh,
                                            target: self, action: #selector(TrackMainViewController.refreshView(_:)))
        let menuButton = ComUI.getMenuButton()
        menuButton.addTarget(self, action: #selector(self.popMenu(_:)),
                             for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: menuButton),refreshButton,]
    }
    // TODO: 修改
    func popMenu(_ sender: AnyObject){
        let shareMenu = UIAlertController(title: nil, message: "メニュー", preferredStyle: .actionSheet)
        let action_edit = UIAlertAction(title: "編集", style: .default, handler: {(action:UIAlertAction) -> Void in
            self.movetoEditView(sender)
        })
        let action_copy = UIAlertAction(title: "番号をコピー", style: .default, handler: {(action:UIAlertAction) -> Void in
            self.copyNo()
        })

        let action_del = UIAlertAction(title: "削除", style: .default, handler: {(action:UIAlertAction) -> Void in
            self.delete()
        })
        let action_redelivery = UIAlertAction(title: "再配達へ", style: .default, handler: {(action:UIAlertAction) -> Void in
            self.moveToRedeliveryVC()
        })
//        let action_openBrowser = UIAlertAction(title: "Webブラウザ起動", style: .Default, handler: {(action:UIAlertAction) -> Void in
//            self.openBrowser(1)
//        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        //        shareMenu.addAction(action_renew)
        shareMenu.addAction(action_copy)
        if(!initFromEditView){shareMenu.addAction(action_edit)}
        shareMenu.addAction(action_del)
        shareMenu.addAction(action_redelivery)
//        shareMenu.addAction(action_openBrowser)
        shareMenu.addAction(cancelAction)

        shareMenu.modalPresentationStyle = .popover
        if let presentation = shareMenu.popoverPresentationController {
            presentation.barButtonItem = navigationItem.rightBarButtonItems?[0]
        }
        
        self.present(shareMenu, animated: true, completion: nil)
    }

    func copyNo(){
        comfunc.copytoPasteBoard((self.trackMain?.trackNo)!)
        self.view.makeToast(message: "番号をコピーました")
    }
    func movetoEditView(_ sender: AnyObject){
//        self.navigationController?.popViewControllerAnimated(false)
        self.navigationController?.popToRootViewController(animated: false)
        delegate?.movetoEditView(self.trackMain!)
    }
    func refreshView(_ sender: AnyObject) {
        self.tableView.getJsonData()
    }
    func delete(){
        if(self.trackMain!.status == -1){
//            trackMainModel.delete(trackMain!.rowID, trackno: trackMain!.trackNo)
//            trackDetailModel.deleteByTrackNo(trackMain!.trackNo)
            IceCreamMng.shared.deleteMainByTrackNo(trackMain!.trackNo)
            IceCreamMng.shared.deleteDetailsByTrackNo(trackMain!.trackNo)
        }else{
            trackMain!.status = -1
//            trackMainModel.update(trackMain!,onlyUpdateStatus: true)
            IceCreamMng.shared.updMainStatus(trackMain!)
        }
        self.navigationController?.popViewController(animated: true)
    }

    
    //　MARK: 显示再配達View
    func moveToRedeliveryVC(){
        let storyboard: UIStoryboard = UIStoryboard(name: "WebView", bundle: nil)
        let webViewController: RedeliveyWebVC = storyboard.instantiateViewController(withIdentifier: "RedeliveyWebVC") as! RedeliveyWebVC
        webViewController.hidesBottomBarWhenPushed = true
        webViewController.tracktype=TrackComType(rawValue: trackMain!.trackType)
        webViewController.trackMain=trackMain
        self.navigationController?.pushViewController(webViewController, animated:true)
    }
}
