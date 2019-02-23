//
//  TrackMainViewController.swift
//  Created by ZHUKUI on 2015/08/13.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
import UIKit
import Alamofire
import SwiftyJSON
//import IJReachability
import GoogleMobileAds
import FirebaseCore
import FirebaseAnalytics

class NewMainVC: BaseViewController,UITableViewDataSource, UITableViewDelegate,
    PZPullToRefreshDelegate ,GADBannerViewDelegate,TrackDetailViewDelegate {
    @IBOutlet weak var ADView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var listTrackMain : Array<TrackMain> = []
    
    let trackMainModel = TrackMainModel.shared//model
    let trackDetailModel = TrackDetailModel.shared//model
    let trackStatusModel = TrackStatusModel.shared//model
    
    var refreshHeaderView: PZPullToRefreshView?
    var isWorking : Bool = false
    let comfunc = ComFunc()
    var statuslist : Array<TrackStatus> = []
    var statusitems : Array<String> = ["追跡中", "追跡完了", "全ての","ゴミ箱"]
    var nowSelectedStatus : Int = 0
    
    // MARK: MenuViewController
    var menuVC : MenuViewController =  MenuViewController.instance()
    // MARK: 旧Menu
    var menuView : BTNavigationDropdownMenu?
    // MARK: menu的容器view
    var overlayView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 200))

    
    let adview_index = 3 //广告在list中显示的位置
    var adview_show = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        overlayView.backgroundColor = UIColor.clear
        overlayView.isHidden = true
        self.navigationController?.view.addSubview(overlayView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // MARK:加入广告
        #if FREE
        if MyUserDefaults.shared.getPurchased_ADClose(){
            self.ADView.frame.size = CGSize(width: self.ADView.frame.width, height: 0)
            self.ADView.removeFromSuperview()
        }else{
            var admobView: GADBannerView = GADBannerView()
            admobView = GADBannerView(adSize:kGADAdSizeBanner)
            //admobView.frame.origin = CGPointMake(0, self.view.frame.size.height - admobView.frame.height)
            admobView.frame.origin = CGPoint(x:0, y:0)
            admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
            admobView.adUnitID = AdMobID_Main
            admobView.delegate = self
            admobView.rootViewController = self
            
            let admobRequest:GADRequest = GADRequest()
            admobView.load(admobRequest)
            self.ADView.frame.size = CGSize(width: self.ADView.frame.width, height: admobView.frame.height)
            self.ADView.addSubview(admobView)
//            self.initFiveAD()
        }
        #else
            self.ADView.frame.size = CGSize(width: self.ADView.frame.width, height: 0)
            self.ADView.removeFromSuperview()
        #endif
        
        self.resetMenuView();
        
        //⬇️menu button
        setBarItem()

        //⬇️analytics
        self.edgesForExtendedLayout = UIRectEdge()
        // MARK:加入下拉刷新view
        if refreshHeaderView == nil {
            let view = PZPullToRefreshView(frame: CGRect(x: 0, y: 0 - tableView.bounds.size.height, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            view.delegate = self
            self.tableView.addSubview(view)
            //view.isShowUpdatedTime = false
            //view.isLoading = true
            refreshHeaderView = view
        }
        
        //set view
//        let appDelegate:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
//        appDelegate.mainViewController = self
        
        //⬇️analytics
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "MainView")
        let params = GAIDictionaryBuilder.createScreenView().build() as! [AnyHashable: Any]
        tracker?.send(params)
        
        //firebase analytics
//        FIRAnalytics.logEvent(AnalyticsEventSelectContent, parameters: [
//            AnalyticsParameterItemID: "id1" as NSObject,
//            AnalyticsParameterItemName: "22",
//            AnalyticsParameterContentType: "cont" as NSObject
//            ])
        Analytics.setScreenName("MainView", screenClass: FIRAnalytics_Screen_Class1)
        //设置左右滑动手势
        self.setSwipe()
        self.setDoubleTapTab()
        
        self.tableView.estimatedRowHeight = 90.0;
        self.tableView.rowHeight=UITableViewAutomaticDimension;
        
        // add notification observers
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        // when click fcm msg
//        if let trackno = appDelegate.gcmClickTrackNo {
//            self.movetoDetailViewWithClickNotification(trackNo: trackno)
//            appDelegate.gcmClickTrackNo = nil
//        }
    }
    override func viewDidAppear(_ animated: Bool) {
        //重启绘制Menu数据
        resetMenuView()
        refreshByNewDBData()
    }
    //MARK:确定启动时，一定执行一次
    @objc func didBecomeActive() {
        print("did become active")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MyUserDefaults.shared.checkShareExtension()
        init_auto_refresh()
        
        if MyUserDefaults.shared.getPurchased_ADClose(){
            self.ADView.frame.size = CGSize(width: self.ADView.frame.width, height: 0)
            self.ADView.removeFromSuperview()
        }
    }
    @objc func willEnterForeground() {
        print("will enter foreground")
        if MyUserDefaults.shared.checkShareExtension(){
            self.refreshByNewDBData()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.overlayView.frame = self.tableView.frame
    }

    func init_auto_refresh(){
        //
        #if FREE
        #else
            if let i: Bool = UserDefaults.standard.bool(forKey: "pro_view_auto_refresh"){
                if(i == true){
                    UserDefaults.standard.set(false, forKey: "pro_view_auto_refresh")
                    if let pre_date: Date =  UserDefaults.standard.object(forKey: "pro_view_auto_refresh_date") as! Date? {
                        // 開始時間と現時間の差分を取る
                        //let currentTime = NSDate()
                        let diffTime: TimeInterval = Date().timeIntervalSince(pre_date)
                        if(diffTime > 3600){
                            refreshView(self)
                            UserDefaults.standard.set(Date(), forKey:"pro_view_auto_refresh_date")
                        }
                    }else{
                        refreshView(self)
                        UserDefaults.standard.set(Date(), forKey:"pro_view_auto_refresh_date")
                    }
                }else{
                    //print("false")
                }
            }else{
                //print("viewWillAppear")
            }
        #endif
    }
    
    // MARK: 点击通知弹出详细画面，
    func movetoDetailViewWithClickNotification(trackNo:String){
//        if let main = IceCreamMng.shared.getMainBeanByTrackNo(trackNo){
        if let main = trackMainModel.getAllByTrackNo(trackNo){
            let detailViewController: TrackDetailMainVC = self.storyboard?.instantiateViewController(withIdentifier: "TrackDetailMainVC") as! TrackDetailMainVC
            detailViewController.delegate = self
            detailViewController.trackMain = main
            detailViewController.refresDataWithClickNotification = true
            detailViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailViewController, animated:true)
//            present(detailViewController, animated: true) {}
        }
    }
    
    
    
    // MARK: 重新绘制菜单 也需要重新绘制无数据视图
    func resetMenuView(){
//        statuslist = IceCreamMng.shared.getAllStatusList();
//        statusitems = IceCreamMng.shared.getAllStatusStrItems()
        statuslist = trackStatusModel.getAllList()
        statusitems = trackStatusModel.getAllItems()
        var iselect = 0
        for i in 0 ..< statuslist.count {
            let bean  = statuslist[i]
            if(bean.status == self.nowSelectedStatus){
                iselect = i
            }
        }
        if(iselect == 0){
            self.nowSelectedStatus = ComFunc.TrackList_doing
        }
        
        menuVC.items = statusitems as [AnyObject]
        menuVC.iSelected = iselect
        
        if menuView == nil{
            menuView = BTNavigationDropdownMenu(frame: CGRect(x: 0.0, y: 0.0, width: 300, height: 44),
                                                title: statusitems[iselect],
                                                items: statusitems as [AnyObject],
                                                containerView: self.view)
            //        menuView.title = statusitems[iselect]
            menuView!.cellHeight = 50
            menuView!.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
            menuView!.cellSelectionColor = UIColor(red: 0.0/255.0, green:180.0/255.0, blue:195.0/255.0, alpha: 1.0)
            menuView!.cellTextLabelColor = UIColor.white
            menuView!.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 18)
            menuView!.arrowPadding = 15
            menuView!.animationDuration = 0.5
            menuView!.maskBackgroundColor = UIColor.black
            menuView!.maskBackgroundOpacity = 0.3
            menuView!.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
                self.nowSelectedStatus = self.statuslist[indexPath].status
                self.refreshByNewDBData()
            }
            menuView?.delegate = self
            self.navigationItem.titleView = menuView
        }
        //重置显示的标题
        menuView?.setMenuTitle1(statusitems[iselect])

        resetFooterView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //关闭菜单
        if menuView!.isShown == true {
            menuView!.isShown = false
//            menuView!.hideMenu()
            menuView!.delegate?.hideDropdownMenu()
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    // MARK: 获得最新数据
    func refreshByNewDBData() {
        if(nowSelectedStatus < -1){
            listTrackMain = trackMainModel.getAll()
        }else{
            listTrackMain = trackMainModel.getAllByStatus(self.nowSelectedStatus)
        }
//        listTrackMain = IceCreamMng.shared.getAllMainBeansByStatus(self.nowSelectedStatus)
        self.resetListTrackMainWithAdBean()
        self.tableView.reloadData()
        resetFooterView()
    }
    // MARK: add Bean with AD
    func resetListTrackMainWithAdBean(){
        #if FREE
        for (i,bean) in listTrackMain.enumerated(){
            if bean.isADView{
                listTrackMain.remove(at: i)
            }
        }
        if MyUserDefaults.shared.getPurchased_ADClose(){
            return
        }
        if (adWcustom_mainview?.state == kFADStateLoaded) &&
            (listTrackMain.count >= adview_index) &&
            !adWcustom_mainview_Through {
            let bean = TrackMain.init()
            bean.isADView = true
            listTrackMain.insert(bean, at: adview_index)
        }
        #else

        #endif
    }
    
    // MARK: 设置无数据视图    
    let nodataview = NoDataView.instanceFromNib()
    func resetFooterView(){
        if self.listTrackMain.count == 0{
            nodataview.frame = CGRect.init(x: 0, y: 0, width: self.overlayView.bounds.width, height: self.overlayView.bounds.height-300)
//            nodataview.backgroundColor = UIColor.green
            self.tableView.tableFooterView = nodataview
            self.tableView.isScrollEnabled=false
        }else{
            self.tableView.tableFooterView = nil
            self.tableView.isScrollEnabled=true
        }
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTrackMain.count
    }
    // let inFeedCellId = "InFeedCell"
    // 为表视图单元格提供数据，该方法是必须实现的方法
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        #if FREE
        if (listTrackMain[row].isADView == true){
            let cell = MainCardCdCell.CreateCellWithNib(table: self.tableView)
            if (adWcustom_mainview?.state == kFADStateLoaded) {
                cell.addADView(adview: adWcustom_mainview!)
            }
            return cell
        }
        #else
        #endif
        let cell = MainCardCell.CreateCellWithNib(table: self.tableView, maindata: listTrackMain[row], celldelegate: self)
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        //return 100;
//        return MainCardCell.getHeight(maindata: listTrackMain[indexPath.row])
//    }
    // 支持单元格编辑功能
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (listTrackMain[indexPath.row].isADView == true){
            return false
        }
        return true
    }
    // Override to support editing the table view.
    // for ios 8.0
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            self.delTable(indexPath)
//            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
        print("tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle")
    }
    //　MARK: 各行的Action
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print("tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath)")
        let DelAction = UITableViewRowAction(style: .default, title: "削除") {
            (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            tableView.isEditing = false
            self.delTable(indexPath)
        }
        
        let MoveAction = UITableViewRowAction(style: .default, title: "移動") {
            (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            tableView.isEditing = false
            self.moveTable(indexPath)
        }
        MoveAction.backgroundColor = UIColor.orange
        
        let EditAction = UITableViewRowAction(style: .default, title: "編集") {
            (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            tableView.isEditing = false
            
            self.movetoEditView(self.listTrackMain[indexPath.row])
        }
        EditAction.backgroundColor = UIColor.blue
        
        // 分享项
        let shareAction = UITableViewRowAction(style: .default, title: "More") { (action, indexPath) -> Void in
            // 选择分享目标
            let shareMenu = UIAlertController(title: nil, message: "メニュー", preferredStyle: .actionSheet)
            let twitterAction = UIAlertAction(title: "番号をコピー", style: .default, handler: {
                (action:UIAlertAction) -> Void in
                self.copyNo(indexPath)
            })
//            let openWebAction = UIAlertAction(title: "Webブラウザ起動", style: .Default, handler: {
//                (action:UIAlertAction) -> Void in
//                self.copyNo(indexPath)
//                self.moveToHomePage(indexPath,type: 0)//2
//            })
            let reDeliveyAction = UIAlertAction(title: "再配達サイトへ", style: .default, handler: {
                (action:UIAlertAction) -> Void in
//                self.moveToHomePage(indexPath,type: 1)
                self.moveToRedeliveryVC(indexPath,type: 1)
            })
            let openWebAction = UIAlertAction(title: "ホームサイトへ(Webブラウザ)", style: .default, handler: {
                (action:UIAlertAction) -> Void in
                self.copyNo(indexPath)
                self.moveToHomePage(indexPath,type:2)
            })
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            shareMenu.addAction(twitterAction)
            shareMenu.addAction(reDeliveyAction)
            shareMenu.addAction(openWebAction)
//            shareMenu.addAction(facebookAction2)
            //shareMenu.addAction(emailAction)
            shareMenu.addAction(cancelAction)
            
            shareMenu.popoverPresentationController?.sourceView = self.view;
            if let cell = tableView.cellForRow(at: indexPath){
                shareMenu.popoverPresentationController?.sourceRect = CGRect.init(x: 0,
                                                                                  y: cell.frame.origin.y,
                                                                                  width: cell.frame.width/2,
                                                                                  height: cell.frame.height);
            }

            self.present(shareMenu, animated: true, completion: nil)
        }
        shareAction.backgroundColor = UIColor.lightGray/** **/
        return [DelAction, MoveAction, EditAction , shareAction]
    }
    
    //　MARK: 拷贝番号
    func copyNo(_ indexPath: IndexPath){
        comfunc.copytoPasteBoard(self.listTrackMain[indexPath.row].trackNo)
        self.view.makeToast(message: "番号をコピーました")
    }
    //　MARK: WebView显示
    //type 0 homepage 1 redi 2 tracksite
    func moveToHomePage(_ indexPath: IndexPath,type : Int){
        copyNo(indexPath)
        let trackno =  self.listTrackMain[indexPath.row].trackNo
        let tracktype =  self.listTrackMain[indexPath.row].trackType
        let url = comfunc.getHomePage(trackno,tracktype : tracktype ,type: type)
        if let okurl = URL(string: url){
            UIApplication.shared.openURL( okurl )
        }else{
            
        }
    }
    //　MARK: 显示再配達View
    func moveToRedeliveryVC(_ indexPath: IndexPath,type : Int){
        
        let storyboard: UIStoryboard = UIStoryboard(name: "WebView", bundle: nil)
        let webViewController: RedeliveyWebVC = storyboard.instantiateViewController(withIdentifier: "RedeliveyWebVC") as! RedeliveyWebVC
        webViewController.hidesBottomBarWhenPushed = true
        webViewController.tracktype=TrackComType(rawValue: self.listTrackMain[indexPath.row].trackType)
        webViewController.trackMain=self.listTrackMain[indexPath.row]
        self.navigationController?.pushViewController(webViewController, animated:true)
    }
    
    
    // move to edit view
    func movetoEditView(_ bean:TrackMain  ){
        //let rowIndex = indexPath.row
        let editViewController: TrackNoAddViewController = self.storyboard?.instantiateViewController(withIdentifier: "TrackAddNoView") as! TrackNoAddViewController
        editViewController.strTrackNo = bean.trackNo
        editViewController.oldstrTrackNo = bean.trackNo
        editViewController.strTrackType = bean.trackType
        editViewController.strComment = bean.comment
        editViewController.strCommentTitle = bean.commentTitle
        editViewController.hidesBottomBarWhenPushed = true
        editViewController.intFormHomeView = 1 //editview
//        editViewController.homeViewController=self
        self.navigationController?.pushViewController(editViewController, animated:true)
            //self.navigationController?.showDetailViewController(detailViewController, sender:self)
    }
    
    
    //↓　削除
    func delTable(_ indexPath: IndexPath ){
        let rowIndex = indexPath.row
        //var rowDict : NSDictionary = listTrackNo.objectAtIndex(rowIndex) as! NSDictionary
        let ID : Int = listTrackMain[rowIndex].rowID
        let trackno : String = listTrackMain[rowIndex].trackNo
        let status : Int = listTrackMain[rowIndex].status
        
        if(status == -1){
            trackMainModel.delete(ID,trackno:trackno)
            trackDetailModel.deleteByTrackNo(trackno)
//            IceCreamMng.shared.deleteMainByTrackNo(trackno)
//            IceCreamMng.shared.deleteDetailsByTrackNo(trackno)
        }else{
            let bean = self.listTrackMain[rowIndex]
            bean.status = -1
            trackMainModel.update(bean,onlyUpdateStatus: true)
//            IceCreamMng.shared.updMainStatus(bean)
        }
        listTrackMain.remove(at: rowIndex)
        tableView.deleteRows(at: [indexPath], with: .fade)
        resetMenuView()
    }
    func moveTable(_ indexPath: IndexPath ){
        let rowIndex = indexPath.row
        let status : Int = listTrackMain[rowIndex].status

        // 选择分享目标
        let shareMenu = UIAlertController(title: nil, message: "他のボックスに移動する", preferredStyle: .actionSheet)
        for i in 0 ..< statuslist.count {
            let bean  = statuslist[i]
            if(statuslist[i].status != ComFunc.TrackList_all){
                if(bean.status != status){
                    let twitterAction = UIAlertAction(title: statusitems[i], style: .default, handler: {
                        (action:UIAlertAction) -> Void in
                        self.moveToStatus(indexPath,status: bean.status)
                    })
                    shareMenu.addAction(twitterAction)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        shareMenu.addAction(cancelAction)
        
        
        shareMenu.popoverPresentationController?.sourceView = self.view;
        if let cell = tableView.cellForRow(at: indexPath){
            shareMenu.popoverPresentationController?.sourceRect = CGRect.init(x: 0,
                                                                              y: cell.frame.origin.y,
                                                                              width: cell.frame.width/2,
                                                                              height: cell.frame.height);
        }
        
        self.present(shareMenu, animated: true, completion: nil)
    }
    func moveToStatus(_ indexPath: IndexPath, status : Int){
        let rowIndex = indexPath.row
        let bean = self.listTrackMain[rowIndex]
        bean.status = status
        trackMainModel.update(bean,onlyUpdateStatus:true)
//        IceCreamMng.shared.updMainStatus(bean)
        self.refreshByNewDBData()
        resetMenuView()
    }
    // MARK: click cell and move to detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if comfunc.isOnlyWeb(self.listTrackMain[indexPath.row].trackType) {
            let webViewController: TrackWebViewController = self.storyboard?.instantiateViewController(withIdentifier: "trackWebView") as! TrackWebViewController
            webViewController.strTrackNo = self.listTrackMain[indexPath.row].trackNo
            webViewController.strTrackType = self.listTrackMain[indexPath.row].trackType
            webViewController.strComment = self.listTrackMain[indexPath.row].comment
            webViewController.strCommentTitle = self.listTrackMain[indexPath.row].commentTitle
//            webViewController.intFormView = 1 //editview
            webViewController.hidesBottomBarWhenPushed = true
            //let rootViewController = self.navigationController!.viewControllers.first
            self.navigationController?.pushViewController(webViewController, animated:true)
        }else{
            moveToTrackDetailVC(self.listTrackMain[indexPath.row])
        }
    }
    func moveToTrackDetailVC(_ trackmain:TrackMain){
        let detailViewController: TrackDetailMainVC = self.storyboard?.instantiateViewController(withIdentifier: "TrackDetailMainVC") as! TrackDetailMainVC
        detailViewController.delegate = self
        detailViewController.trackMain=trackmain
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated:true)
    }
    //pulltorefresh
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshHeaderView?.refreshScrollViewDidScroll(scrollView)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshHeaderView?.refreshScrollViewDidEndDragging(scrollView)
    }
    // MARK:PZPullToRefreshDelegate
    func pullToRefreshDidTrigger(_ view: PZPullToRefreshView) -> () {
        //net check
        if !IJReachability.isConnectedToNetwork() {
            UIAlertView(title: "接続失敗", message: "オフラインの為接続できませんでした。",
                delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
            self.pullRefreshEnd()
            return
        }
        self.getNewNetData()
    }
    // Optional method
    func pullToRefreshLastUpdated(_ view: PZPullToRefreshView) -> Date {
        return Date()
    }
    func pullRefreshEnd(){
        //println("Complete loading!")
        self.refreshHeaderView?.isLoading = false
        self.refreshHeaderView?.refreshScrollViewDataSourceDidFinishedLoading(self.tableView)
    }
    
    func getNewNetData(){
        refreshHeaderView?.isLoading = true
        self.isWorking = true
        var did : Bool = false
        for i in 0  ..< listTrackMain.count{
            if ((!comfunc.isOnlyWeb(self.listTrackMain[i].trackType)) &&
                (!comfunc.isDeliveryOver(self.listTrackMain[i])))
            {
                getJsonData(i)
                did = true
            }
        }
        
        self.isWorking = false
        let delay = 2 * Double(NSEC_PER_SEC)
        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            self.pullRefreshEnd()
        })
        if(did){
            let delay1 = 3 * Double(NSEC_PER_SEC)
            let time1  = DispatchTime.now() + Double(Int64(delay1)) / Double(NSEC_PER_SEC)
//            DispatchQueue.main.asyncAfter(deadline: time1, execute: {
//                iRate.sharedInstance().logEvent(false)
//                //print(iRate.sharedInstance().eventCount)
//            })
        }
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    func getJsonData(_ rowIndex : Int){
        let trackMain = listTrackMain[rowIndex]
        listTrackMain[rowIndex].networking = true
        self.tableView.reloadData()
        
        let urlString = comfunc.getAPIURL2(listTrackMain[rowIndex].trackType, trackno: listTrackMain[rowIndex].trackNo)
        //Alamofire.request(Alamofire.Method.GET, urlString, parameters: ["dev": "ios"])
        
//        Alamofire.request(.GET, urlString, parameters: ["dev": "ios","type": listTrackMain[rowIndex].trackType,"no": listTrackMain[rowIndex].trackNo])
         Alamofire.request(urlString, method: .get, parameters: ["dev": "ios","type": listTrackMain[rowIndex].trackType,"no": listTrackMain[rowIndex].trackNo])
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    //print(response.request)  // original URL request
                    //print(response.response) // URL response
                    //print(response.data)     // server data
                    //print(response.result)   // result of response serialization
                    //if let JSON = response.result.value {
                        //print("JSON: \(JSON)")
                    //}
                    //まずJSONデータをNSDictionary型に
                    let jsonDic = value as! NSDictionary
                    
                    //辞書化したjsonDicからキー値"responseData"を取り出す
                    //let responseData = jsonDic["responseData"] as! NSDictionary
                    let json = JSON(jsonDic)
                    //print("json: \(json)")
                    let newBean = self.comfunc.parseJson(trackMain.trackType,json: json)
                    let oldBean = self.comfunc.getNewTrackMain(trackMain, newtrackmain: newBean)
                    
                    //Add to DB
//                    IceCreamMng.shared.deleteDetailsByTrackNo(oldBean.trackNo)
                    self.trackDetailModel.deleteByTrackNo(oldBean.trackNo)
                    for z in oldBean.detailList {
//                        IceCreamMng.shared.addDetail(z)
                        self.trackDetailModel.add(z)
                    }
                    oldBean.networking = false
                    self.trackMainModel.update(oldBean)
//                    IceCreamMng.shared.UpdMainFromNet(oldBean)
                    self.listTrackMain[rowIndex] = oldBean
                    self.refreshByNewDBData()
                case .failure(let error):
                    // 通信のエラーハンドリングしたいなら
                    //print(error)
                    let tracker: GAITracker = GAI.sharedInstance().defaultTracker
                    tracker.send(GAIDictionaryBuilder.createEvent(withCategory: "GetData_API_ERR", action: urlString, label: error.localizedDescription,
                        value: nil).build() as! [AnyHashable: Any])
                }
            //if response.result.isSuccess {}
        }
        
        let tracker: GAITracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEvent(withCategory: "GetData_API", action: listTrackMain[rowIndex].trackType,
            label: listTrackMain[rowIndex].trackNo,
            value: nil).build() as! [AnyHashable: Any])

        
        Analytics.logEvent("GetData_API", parameters: [
            "type": listTrackMain[rowIndex].trackType,
            "label": listTrackMain[rowIndex].trackNo
            ])
    }
}

// MARK: bar menu
/*　BAR　Menu　*/
extension NewMainVC{
    func setBarItem(){
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh,
                                            target: self, action: #selector(TrackMainViewController.refreshView(_:)))
        self.navigationItem.leftBarButtonItems = []

        let menuButton = ComUI.getMenuButton()
        menuButton.addTarget(self, action: #selector(TrackMainViewController.popMenu(_:)),
                             for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: menuButton),refreshButton,]
        
        let leftmenuButton = ComUI.getLeftMenuButton()
        leftmenuButton.addTarget(self, action: #selector(TrackMainViewController.onSlideMenuButtonPressed(_:)),
                             for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: leftmenuButton),]
        
        addSlideMenuButton()
    }
    func popMenu(_ sender: AnyObject){
        let shareMenu = UIAlertController(title: nil, message: "メニュー", preferredStyle: .actionSheet)
        let updateAllAction = UIAlertAction(title: "一括更新", style: .default, handler: {
            (action:UIAlertAction) -> Void in
            self.refreshView(sender)
        })
        let twitterAction = UIAlertAction(title: "全てを削除", style: .default, handler: {
            (action:UIAlertAction) -> Void in
            self.deleteAll(sender)
        })
        let facebookAction = UIAlertAction(title: "追跡完了へ自動振り分け", style: .default, handler: {
            (action:UIAlertAction) -> Void in
            self.moveAllOverItem()
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        shareMenu.addAction(updateAllAction)
        shareMenu.addAction(twitterAction)
        shareMenu.addAction(facebookAction)
        shareMenu.addAction(cancelAction)
        
        shareMenu.modalPresentationStyle = .popover
        if let presentation = shareMenu.popoverPresentationController {
            presentation.barButtonItem = navigationItem.rightBarButtonItems?[0]
        }
        
        self.present(shareMenu, animated: true, completion: nil)
    }
    func refreshView(_ sender: AnyObject) {
        //net check
        if !IJReachability.isConnectedToNetwork() {
            UIAlertView(title: "接続失敗", message: "オフラインの為接続できませんでした。",
                        delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
            return
        }
        self.getNewNetData()
    }
    func deleteAll(_ sender: AnyObject){
        let refreshAlert = UIAlertController(title: "全て削除", message: "履歴をすべて削除しますか？", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "削除", style: .default, handler: { (action: UIAlertAction!) in
//            for var i = (self.listTrackMain.count-1); i >= 0; i -= 1{
            for i in stride(from: self.listTrackMain.count-1, through: 0, by: -1) {
                let index = IndexPath(row: i, section: 0);
                self.delTable(index);
            }
        }))
        refreshAlert.addAction(UIAlertAction(title: "キャンセル", style: .default, handler: { (action: UIAlertAction!) in
        }))
        
        refreshAlert.modalPresentationStyle = .popover
        if let presentation = refreshAlert.popoverPresentationController {
            presentation.barButtonItem = navigationItem.rightBarButtonItems?[0]
        }
        
        present(refreshAlert, animated: true, completion: nil)
    }
    func moveAllOverItem(){
        for i in stride(from: self.listTrackMain.count-1, through: 0, by: -1) {
            let bean = self.listTrackMain[i]
            if comfunc.isDeliveryOver(bean){
                bean.status = ComFunc.TrackList_over
                trackMainModel.update(bean,onlyUpdateStatus:true)
                //IceCreamMng.shared.updMainStatus(bean)
            }
        }
        self.refreshByNewDBData()
        resetMenuView()
    }
}

