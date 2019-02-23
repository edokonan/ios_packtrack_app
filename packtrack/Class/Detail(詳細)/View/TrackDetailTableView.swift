//
//  TrackDetailTableView.swift
//  packtrack
//
//  Created by ksymac on 2017/03/25.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
//import IJReachability
import GoogleMobileAds


class TrackDetailTableView: UIView , UITableViewDataSource, UITableViewDelegate,PZPullToRefreshDelegate{
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            setupUI()
        }
    }
    var refreshHeaderView: PZPullToRefreshView?
    
    var isWorking : Bool = false
    let titelcellId = "TrackDetailTableViewTitleCell"
    let cellId = "TrackDetailTableViewCell"
    
    var trackMain : TrackMain?
    var listTrackDetail : Array<TrackDetail> = []
//    let trackDetailModel = TrackDetailModel()//model
//    let trackMainModel = TrackMainModel()//model
    
    @IBOutlet weak var UIAdView: UIView!
    @IBOutlet weak var UIAdViewHeight: NSLayoutConstraint!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    class func instanceFromNib() -> TrackDetailTableView {
        let nibView = Bundle.main.loadNibNamed( "TrackDetailTableView",
            owner: nil,
            options: nil)?[0] as? TrackDetailTableView
        return nibView!
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.refreshViewByDB()
    }
}


// MARK: - Table处理设置
extension TrackDetailTableView{
    //返回某个节中的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTrackDetail.count + 1
    }
    //为表视图单元格提供数据
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row  {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: titelcellId, for: indexPath) as! TrackDetailTableViewTitleCell
            cell.setUI(self.trackMain!,isWorking: isWorking)
            cell.selectionStyle = .none
            return cell
        default:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TrackDetailTableViewCell
            let row = indexPath.row
            cell.setUI(listTrackDetail[row-1],first: (indexPath.row==1))
            cell.selectionStyle = .none
            return cell
        }
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if(indexPath.row==0){
////            return TrackDetailTableViewTitleCell.getHeight(data: self.trackMain)
//            return 90
//        }else{
//            return 90
//        }
//    }
}

// MARK: - 设置UI
extension TrackDetailTableView{
    func setupUI(){
        tableView.separatorStyle = .none
        tableView.backgroundColor = GlobalBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.separatorStyle = .none
        
        let nib = UINib(nibName: "TrackDetailTableViewTitleCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.register(nib, forCellReuseIdentifier: titelcellId)
        let nib2 = UINib(nibName: "TrackDetailTableViewCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.register(nib2, forCellReuseIdentifier: cellId)
        
        if refreshHeaderView == nil {
            refreshHeaderView = PZPullToRefreshView(frame: CGRect(x: 0, y: 0 - tableView.bounds.size.height, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            refreshHeaderView!.delegate = self
            self.tableView.addSubview(refreshHeaderView!)
            //view.isShowUpdatedTime = false
            //view.isLoading = true
        }
        
        tableView.estimatedRowHeight = 88.0;
        tableView.rowHeight=UITableViewAutomaticDimension;
        
        #if FREE
            UIAdViewHeight.constant = 0
//        self.initFiveADView()
//        if !MyUserDefaults.shared.getPurchased_ADClose(){
//            self.initFiveAD()
//        }
        #else
            UIAdViewHeight.constant = 0
        #endif
    }
    func initFiveADView(){
        self.UIAdView.backgroundColor = GlobalBackgroundColor
    }
}


// MARK: - 获取数据
extension TrackDetailTableView{
    func refreshViewByDB(){
        guard let trackno = self.trackMain?.trackNo else{
            return
        }
//        listTrackDetail = trackDetailModel.getAllByTrackNo(trackno)
//        trackMain = trackMainModel.getAllByTrackNo(trackno)!
        listTrackDetail = IceCreamMng.shared.getDetailsByTrackNo(trackno)
        trackMain = IceCreamMng.shared.getMainBeanByTrackNo(trackno)!

        self.tableView.reloadData()
        //showed
        if(trackMain!.haveUpdate){
//            trackMainModel.setReaded(trackno)
            IceCreamMng.shared.setReaded(trackno)
            trackMain!.haveUpdate = false
        }
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
        let urlString = ComFunc.shared.getAPIURL2((self.trackMain?.trackType)!,trackno: (trackMain?.trackNo)!)
        
//        Alamofire.request(.GET, urlString,
//            parameters: ["dev": "ios","type": (trackMain?.trackType)!,"no": (trackMain?.trackNo)!])
        Alamofire.request(urlString, method: .get,
                          parameters: ["dev": "ios","type": (trackMain?.trackType)!,"no": (trackMain?.trackNo)!])
            .responseJSON
            {response in
                switch response.result {
                case .success(let value):
                    //まずJSONデータをNSDictionary型に
                    let jsonDic = value as! NSDictionary
                    //辞書化したjsonDicからキー値"responseData"を取り出す
                    //let responseData = jsonDic["responseData"] as! NSDictionary
                    let json = JSON(jsonDic)
                    let newBean = ComFunc.shared.parseJson((self.trackMain?.trackType)!,json: json)
                    self.trackMain = ComFunc.shared.getNewTrackMain(self.trackMain!, newtrackmain: newBean)
                    //Add to DB
//                    self.trackDetailModel.deleteByTrackNo((self.trackMain?.trackNo)!)
                    IceCreamMng.shared.deleteDetailsByTrackNo((self.trackMain?.trackNo)!)
                    for z in self.trackMain!.detailList {
//                        self.trackDetailModel.add(z)
                        IceCreamMng.shared.AddOrUpdDetail(z)
                    }
//                    self.trackMainModel.update(self.trackMain!)
                    IceCreamMng.shared.UpdMainFromNet(self.trackMain!)
                    //subJson: JSON
                    //for  (i, v) in statusList {
                    //    println(subJson)
                    //}
                    self.isWorking = false
                    self.pullRefreshEnd()
                    self.refreshViewByDB()
                    self.makeToast(message: "データ取得済み")
                case .failure(let error):
                    // 通信のエラーハンドリングしたいなら
                    //print(error)
                    let tracker: GAITracker = GAI.sharedInstance().defaultTracker
//                    tracker.send(GAIDictionaryBuilder.createEventWithCategory("GetData_API_ERR",
//                                                                              action: urlString,
//                                                                              label: error.description,
//                        value: nil).build() as [AnyHashable: Any])
                }
        }
        let tracker: GAITracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEvent(withCategory: "GetData_API",
            action: self.trackMain?.trackType,
            label: self.trackMain?.trackNo,
            value: nil).build() as! [AnyHashable: Any])
    }
}
// MARK: - 下拉刷新
extension TrackDetailTableView{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshHeaderView?.refreshScrollViewDidScroll(scrollView)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshHeaderView?.refreshScrollViewDidEndDragging(scrollView)
    }
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
        self.refreshHeaderView?.isLoading = false
        self.refreshHeaderView?.refreshScrollViewDataSourceDidFinishedLoading(self.tableView)
    }
    func pullToRefreshLastUpdated(_ view: PZPullToRefreshView) -> Date {
        return Date()
    }
}

