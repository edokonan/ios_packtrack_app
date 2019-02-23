//
//  TrackDetailViewController1.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/13.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//import IJReachability
import GoogleMobileAds
import FirebaseAnalytics

#if FREE
//import iAd
#else
#endif

class TrackDetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,
            PZPullToRefreshDelegate , GADBannerViewDelegate {// ADBannerViewDelegate,
    //@IBOutlet weak var ViewTitle: UINavigationItem!
    @IBOutlet var tableView: UITableView!
    var refreshHeaderView: PZPullToRefreshView?
    var strTrackNo : String = ""
    var strTrackType : String = ""
    var strComment : String = ""
    var strCommentTitle : String = ""
    var intFormView : Int = 0
    var trackMain : TrackMain = TrackMain()
    var listTrackDetail : Array<TrackDetail> = []
    let trackMainModel = TrackMainModel.shared//model
    let trackDetailModel = TrackDetailModel.shared//model
    var isWorking : Bool = false
    let comfunc = ComFunc()
    var delegate: TrackDetailViewDelegate?
    
    @IBOutlet weak var ADView: UIView!
        
    //var bannerView: ADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        nav?.isTranslucent = false
        nav?.barTintColor = UIColor(red: 80.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        nav?.tintColor = UIColor.white
        //viewTitle.title = strTrackNo
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.title = strTrackNo
        
        //var bundle = NSBundle.mainBundle()
        tableView.dataSource = self
        tableView.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //下面这段话是设置左边编辑，右边添加item
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        setBarItemUI()

        
        #if FREE
        if MyUserDefaults.shared.getPurchased_ADClose(){
            self.ADView.frame.size = CGSize(width: self.ADView.frame.width, height: 0)
            self.ADView.removeFromSuperview()
        }else{
            var admobView: GADBannerView = GADBannerView()
            admobView = GADBannerView(adSize:kGADAdSizeBanner)
            admobView.frame.origin = CGPoint(x:0, y:0)
            admobView.frame.size = CGSize(width: self.view.frame.width, height:admobView.frame.height)
            admobView.adUnitID = AdMobID_DetailView
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
        /**
        #if FREE
            bannerView = ADBannerView(adType: .Banner)
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            bannerView.delegate = self
            bannerView.hidden = true
            ADView.addSubview(bannerView)
            
            let viewsDictionary = ["bannerView": bannerView]
            ADView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bannerView]|", options: [], metrics: nil, views: viewsDictionary))
            ADView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bannerView]|", options: [], metrics: nil, views: viewsDictionary))
        #else
            self.ADView.frame.size = CGSizeMake(self.ADView.frame.width, 0)
            self.ADView.removeFromSuperview()
        #endif

        self.ADView.frame.size = CGSizeMake(self.ADView.frame.width, 0)
        self.ADView.removeFromSuperview()
        **/
        if(intFormView == 0 ) //listview
        {}
        else{ //addview
            getJsonData()
        }
        
        self.edgesForExtendedLayout = UIRectEdge()
        if refreshHeaderView == nil {
            let view = PZPullToRefreshView(frame: CGRect(x: 0, y: 0 - tableView.bounds.size.height, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            view.delegate = self
            self.tableView.addSubview(view)
            //view.isShowUpdatedTime = false
            //view.isLoading = true
            refreshHeaderView = view
        }

        #if FREE
            //self.canDisplayBannerAds = true
        #endif
    }
    /**
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        bannerView.hidden = false
    }
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        bannerView.hidden = true
    }**/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "DetailView")
        let params = GAIDictionaryBuilder.createScreenView().build() as! [AnyHashable: Any]
        tracker?.send(params)
        
        
        FIRAnalytics.setScreenName("DetailView", screenClass: FIRAnalytics_Screen_Class1)
        refreshViewByDB()
    }
    override func viewDidAppear(_ animated: Bool) {
        //refreshViewByDB()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Table view data source
    //返回节的个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //返回某个节中的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return listTrackDetail.count + 1
    }
    //为表视图单元格提供数据，该方法是必须实现的方法
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row  {
        case 0:
            let cellIdentifier : String = "detailViewTitleCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TrackDetailViewTitleCell
            //var row = indexPath.row
            
            cell.labelTrackNo.text = trackMain.trackNo
            let str = trackMain.typeName.removeWhitespace()
            //var newString = str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            cell.labelTrackName.text = str
            //自动折行设置
            //cell.labelTrackName.lineBreakMode = UILineBreakModeWordWrap;
            //cell.labelTrackName.numberOfLines = 0;
            if(trackMain.commentTitle.isEmpty){
                cell.labelComment.text = trackMain.comment}
            else{
                cell.labelComment.text = trackMain.commentTitle + " " + trackMain.comment}
            
            cell.companyImg.image = comfunc.getCompanyImg(trackMain.trackType)
            
            if( self.isWorking){
                cell.isWorking.startAnimating()
                cell.isWorking.isHidden = false
            }else{
                cell.isWorking.stopAnimating()
                cell.isWorking.isHidden = true
            }
            
            return cell
        case 1:
            let cellIdentifier : String = "detailViewFirstCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TrackDetailViewCell
            let row = indexPath.row
            cell.timelineLabel.backgroundColor = UIColor.orange
            cell.labelDate.textColor = UIColor.orange
            cell.labelTitle.textColor = UIColor.orange
            cell.labelSubTitle.textColor = UIColor.orange
            cell.labelDate.text = listTrackDetail[row-1].date
            cell.labelTitle.text = listTrackDetail[row-1].status
            cell.labelSubTitle.text = listTrackDetail[row-1].detail
            return cell
        default:
            let cellIdentifier : String = "detailViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TrackDetailViewCell
            let row = indexPath.row
            
            cell.labelDate.text = listTrackDetail[row-1].date
            cell.labelTitle.text = listTrackDetail[row-1].status
            cell.labelSubTitle.text = listTrackDetail[row-1].detail
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row==0){
            return 110
        }else{
            return 90
        }
    }
    
    // 支持单元格编辑功能
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return false
    }
    
    // Override to support conditional rearranging of the table view.
    //在编辑状态，可以拖动设置item位置
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    func getJsonData(){
        //net check
        if !IJReachability.isConnectedToNetwork() {
            let av = UIAlertView(title: "接続失敗", message: "オフラインの為接続できませんでした。", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
            av.show()
            return
        }
        
        self.isWorking = true
        self.tableView.reloadData()
        
        let urlString = comfunc.getAPIURL2(strTrackType,trackno: strTrackNo)
//        Alamofire.request(<#T##url: URLConvertible##URLConvertible#>, method: <#T##HTTPMethod#>, parameters: <#T##Parameters?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##HTTPHeaders?#>)
//        Alamofire.request(url: urlString, method: .get,
//                          parameters: ["dev": "ios","type": strTrackType,"no": strTrackNo])
        Alamofire.request(urlString, method: .get,
                          parameters: ["dev": "ios","type": strTrackType,"no": strTrackNo])
            .responseJSON
            {response in
                switch response.result {
                case .success(let value):
                    //まずJSONデータをNSDictionary型に
                    let jsonDic = value as! NSDictionary
                    //辞書化したjsonDicからキー値"responseData"を取り出す
                    //let responseData = jsonDic["responseData"] as! NSDictionary
                    let json = JSON(jsonDic)
                    //print("json: \(json)")
                    let newBean = self.comfunc.parseJson(self.strTrackType,json: json)
                    self.trackMain = self.comfunc.getNewTrackMain(self.trackMain, newtrackmain: newBean)
                    //Add to DB
                    self.trackDetailModel.deleteByTrackNo(self.strTrackNo)
                    for z in self.trackMain.detailList {
                        self.trackDetailModel.add(z)
                    }
                    self.trackMainModel.update(self.trackMain)
                    //subJson: JSON
                    //for  (i, v) in statusList {
                    //    println(subJson)
                    //}
                    self.isWorking = false
                    self.pullRefreshEnd()
                    self.refreshViewByDB()
                    self.view.makeToast(message: "データ取得済み")
                    let delay = 1.5 * Double(NSEC_PER_SEC)
                case .failure(let error):
                    let tracker: GAITracker = GAI.sharedInstance().defaultTracker
//                    tracker.send(GAIDictionaryBuilder.createEventWithCategory("GetData_API_ERR", action: urlString, label: error.description,
//                        value: nil).build() as [AnyHashable: Any])
                }
            }
        let tracker: GAITracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEvent(withCategory: "GetData_API", action: strTrackType, label: strTrackNo,
            value: nil).build() as! [AnyHashable: Any])
        
        FIRAnalytics.logEvent(withName: "GetData_API", parameters: [
            "type": strTrackType,
            "label": strTrackNo
            ])
    }

    func refreshViewByDB(){
        trackMain = trackMainModel.getAllByTrackNo(strTrackNo)!
        listTrackDetail = trackDetailModel.getAllByTrackNo(strTrackNo)
        self.tableView.reloadData()
        //showed
        if(trackMain.haveUpdate ){
            trackMainModel.setReaded(strTrackNo)
            trackMain.haveUpdate = false
        }
    }
    
    //　↓↓↓↓↓　pulltoRefresh
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
            let av = UIAlertView(title: "接続失敗", message: "オフラインの為接続できませんでした。",
                delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
            av.show()
            self.pullRefreshEnd()
            return
        }
        
        refreshHeaderView?.isLoading = true
        //get new data
        self.getJsonData()
        
        let delay = 3.0 * Double(NSEC_PER_SEC)
        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            self.pullRefreshEnd()
        })
    }
    func pullRefreshEnd(){
        //print("Complete loading!")
        self.refreshHeaderView?.isLoading = false
        self.refreshHeaderView?.refreshScrollViewDataSourceDidFinishedLoading(self.tableView)
    }
    // Optional method
    func pullToRefreshLastUpdated(_ view: PZPullToRefreshView) -> Date {
        return Date()
    }
    //　↑↑↑↑↑　pulltoRefresh
    
}

protocol TrackDetailViewDelegate : NSObjectProtocol{
    func movetoEditView(_ bean:TrackMain)-> ()
}


// MARK: 菜单中的各个事件
extension TrackDetailViewController{
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
        let action_edit = UIAlertAction(title: "情報を編集", style: .default, handler: {(action:UIAlertAction) -> Void in
            self.movetoEditView(sender)
        })
        let action_copy = UIAlertAction(title: "番号をコピー", style: .default, handler: {(action:UIAlertAction) -> Void in
            self.copyNo()
        })
        let action_renew = UIAlertAction(title: "最新情報を更新", style: .default, handler: {(action:UIAlertAction) -> Void in
            self.refreshView(sender)
        })
        let action_del = UIAlertAction(title: "削除", style: .default, handler: {(action:UIAlertAction) -> Void in
            self.delete()
        })
        let action_redelivery = UIAlertAction(title: "再配達サイトへ", style: .default, handler: {(action:UIAlertAction) -> Void in
            self.moveToWebView(WebPageType.trackPage)
        })
        let action_openBrowser = UIAlertAction(title: "Webブラウザ起動", style: .default, handler: {(action:UIAlertAction) -> Void in
            self.openBrowser(1)
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        shareMenu.addAction(action_edit)
        shareMenu.addAction(action_copy)
        shareMenu.addAction(action_renew)
        shareMenu.addAction(action_del)
        shareMenu.addAction(action_redelivery)
        shareMenu.addAction(action_openBrowser)
        shareMenu.addAction(cancelAction)
        shareMenu.modalPresentationStyle = .popover
        if let presentation = shareMenu.popoverPresentationController {
            presentation.barButtonItem = navigationItem.rightBarButtonItems?[0]
        }
        self.present(shareMenu, animated: true, completion: nil)
    }
    func copyNo(){
        comfunc.copytoPasteBoard(self.strTrackNo)
        self.view.makeToast(message: "番号をコピーました")
    }
    func movetoEditView(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: false)
        delegate?.movetoEditView(self.trackMain)
    }
    func refreshView(_ sender: AnyObject) {
        self.getJsonData()
    }
    func delete(){
        if(trackMain.status == -1){
            trackMainModel.delete(trackMain.rowID)
            trackDetailModel.deleteByTrackNo(trackMain.trackNo)
        }else{
            trackMain.status = -1
            trackMainModel.update(trackMain,onlyUpdateStatus:true)
        }
        self.navigationController?.popViewController(animated: true)
    }
    //type 0 homepage 1 redi 2 tracksite
    func moveToWebView(_ webType: WebPageType){
        let storyboard: UIStoryboard = UIStoryboard(name: "WebView", bundle: nil)
        let webViewController: MyWebViewController = storyboard.instantiateViewController(withIdentifier: "MyWebViewController") as! MyWebViewController
        webViewController.strTrackNo = trackMain.trackNo
        webViewController.strTrackType = trackMain.trackType
        webViewController.strComment = trackMain.comment
        webViewController.strCommentTitle = trackMain.commentTitle
        webViewController.intFormView = 1 //editview
        
        webViewController.trackMain=trackMain
        webViewController.webType=webType.rawValue
        webViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webViewController, animated:true)
    }
    func openBrowser(_ webType: Int){
        copyNo()
        let trackno =  trackMain.trackNo
        let tracktype =  trackMain.trackType
        let url1 = comfunc.getHomePage(trackno,tracktype : tracktype ,type: webType)
        if let okurl = URL(string: url1){
            UIApplication.shared.openURL( okurl )
        }else{
            
        }
    }
    
}

