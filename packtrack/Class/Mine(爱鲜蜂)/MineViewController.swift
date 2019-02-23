//
//  MineViewController.swift
//  LoveFreshBee
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit
import Firebase
import SVProgressHUD
import StoreKit
//// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
//// Consider refactoring the code to use the non-optional operators.
//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}
//// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
//// Consider refactoring the code to use the non-optional operators.
//fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l > r
//  default:
//    return rhs < lhs
//  }
//}

class MineSectionType:NSObject{
    var title:String?
    var rows:[MineCellModel]=[]
    convenience init(title:String) {
        self.init()
        self.title=title
    }
    override init(){
        super.init()
    }
}


class MineViewController: BaseViewController {
    fileprivate var headView: MineHeadView!
    var tableView: LFBTableView!
    fileprivate var headViewHeight: CGFloat = 130
    fileprivate var tableHeadView: MineTabeHeadView!
    fileprivate var couponNum: Int = 0
//    fileprivate let shareActionSheet: LFBActionSheet = LFBActionSheet()
    // MARK: Flag
    var iderVCSendIderSuccess = false
    
    //MARK: - 设置CM后的活动
    var RewardCompetion : (()->())?
    //是否获得CM奖励
    var getCMReward = false
    

    let common_svprogresshud_dismiss_time = 3
    
    //MARK: - 设置行数据
    fileprivate lazy var mines: [MineCellModel] = {
        let mines = MineCellModel.loadMineCellModels()
        return mines
        }()
    var MySectionS = [MineSectionType]()
    
    //MARK: 初始时，显示购买广告
    var show_ad_close = true
    
    func setupSections(){
        MySectionS = []
        weak var weak_self = self
        
        var islogin = false
        if Auth.auth().currentUser?.uid != nil {
            let section0 = MineSectionType(title: "datafile")
            let backup_cell = MineCellModel()
            if let datafile = packtrack_user?.packtrack_backupFileUrl,
                let time = packtrack_user?.getPacktrackBackupTime() {
//                var attrText = NSMutableAttributedString(string: "バックアップデータ")
                let tempstr = String(format: "バックアップデータ(%@)", arguments: [time])
                var attrText = NSMutableAttributedString(string: tempstr)
                attrText.addAttributes([NSForegroundColorAttributeName: UIColor.blue],
                                           range: NSMakeRange(9, tempstr.characters.count-9))
                attrText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12)], range: NSMakeRange(9, tempstr.characters.count-9))
//                attrText.addAttributes([NSBackgroundColorAttributeName: GSSettings.unreadNotificationColor()], range: NSMakeRange(1, 4))
                backup_cell.attrTitle = attrText
                backup_cell.title = nil
                backup_cell.iconName = "icons8-cloud-storage"
                section0.rows.append(backup_cell)
                section0.rows.append(MineCellModel(title: "バックアップデータを削除", iconName: "icons8-file-delete", complete: {
                    weak_self?.DelBakFilewithUser()
                }))
            }else{
                backup_cell.title = "バックアップデータ　無し"
                backup_cell.iconName = "icons8-cloud-storage"
                section0.rows.append(backup_cell)
            }
            MySectionS.append(section0)
            
            islogin = true
        }
        
        if show_ad_close {
            #if FREE
            let section_ad = MineSectionType(title: "広告非表示")
            if  MyUserDefaults.shared.getPurchased_ADClose(){
                section_ad.rows.append(MineCellModel(title: "広告非表示を購入(購入済)", iconName: "icons8-buy", complete: {
//weak_self?.verifyReceipt()
//weak_self?.verifyPurchase("ok")
//MyUserDefaults.shared.setPurchased_ADClose(!MyUserDefaults.shared.getPurchased_ADClose())
                }))
            }else{
                section_ad.rows.append(MineCellModel(title: "広告非表示を購入", iconName: "icons8-buy", complete: {
                    guard let user = packtrack_user else {
                        weak_self?.popLoginVC()
                        return
                    }
                    weak_self?.purchaseProduct()
                }))
            }
            MySectionS.append(section_ad)
            #else
            
            #endif
        }
        
        
        let section1 = MineSectionType(title: "フィードバック")
        
        var str = "荷物最新状態プッシュ通知(ON)"
        if enableRemoteNotification == true{
        }else{
            str = "荷物最新状態プッシュ通知(OFF)"
        }
        
        section1.rows.append(MineCellModel(title: str, iconName: "icons8-remotemsg", complete: {
            weak_self?.openSettingMsgView()
        }))
        
        section1.rows.append(MineCellModel(title: "アプリを評価する", iconName: "icons8-review", complete: {
            weak_self?.requestReview()
        }))
        
        section1.rows.append(MineCellModel(title: "ローカルデータを削除", iconName: "icons8-file-delete", complete: {
            weak_self?.clearDB()
        }))
        section1.rows.append(MineCellModel(title: "整理ボックス追加", iconName: "icons8-folder", complete: {
            weak_self?.popBoxSetting()
        }))

        section1.rows.append(MineCellModel(title: "ご意見とお問い合わせ", iconName: "icons8-mail", complete: {
            weak_self?.onClickStartMailerBtn()
        }))
        section1.rows.append(MineCellModel(title: "アプリをシェアする", iconName: "icons8-share", complete: {
            weak_self?.shareMyAPPLICATION()
        }))
        
//        section1.rows.append(MineCellModel(title: "test db", iconName: "icons8-share", complete: {
//            weak_self?.importDataformOldDB()
//        }))
        
        MySectionS.append(section1)
        
        if islogin{
            let section4 = MineSectionType(title: "logout")
            section4.rows.append(MineCellModel(title: "ログアウト", iconName: "icons8-exit", complete: {
                weak_self?.logout()
            }))
            MySectionS.append(section4)
        }
    }
    
    @objc func importDataformOldDB() {
        IceCreamMng.shared.deleteAllDataForTest()
        IceCreamMng.shared.startImportToIceCreamFromOldDB()
        print("-----------------------")
        let list1:Array<TrackStatus> = IceCreamMng.shared.getAllStatusList();
        for bean in list1{
            print(bean.status)
            print(bean.statusname)
        }
        print("-----------------------")
        let list:[RMTrackMain] = IceCreamMng.shared.getTrackMainlist();
        for bean in list{
            print("------")
            print(bean.trackNo)
            let list2: Array<TrackDetail> = IceCreamMng.shared.getDetailsByTrackNo(bean.trackNo)
            for bean2 in list2{
                print(bean2.status)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
//        Mine.loadMineData { (data, error) -> Void in
//            if error == nil {
////                if data?.data?.availble_coupon_num > 0 {
////                    tmpSelf!.couponNum = data!.data!.availble_coupon_num
////                    tmpSelf!.tableHeadView.setCouponNumer(data!.data!.availble_coupon_num)
////                } else {
////                    tmpSelf!.tableHeadView.setCouponNumer(0)
////                }
//            }
//        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if iderVCSendIderSuccess {
            //ProgressHUDManager.showSuccessWithStatus("已经收到你的意见了,我们会刚正面的,放心吧~~")
            iderVCSendIderSuccess = false
        }
    }
    // MARK:- view life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = true
        buildUI()
        //根据用户的情况需要再次设置View
        setupSections()
        //获取云端用户数据
        refreshDataWithCloud()
        if let uid = Auth.auth().currentUser?.uid {
            startObserveUser(uid: uid)
        }
        
        //关于购买关闭广告
        #if FREE
        if MyUserDefaults.shared.getPurchased_ADClose() == false{
            self.checkShow_Adcolose_enable()
            self.getProductsInfo()
            //            self.verifyReceipt()
            //验证是否购买了。
//            self.verifyPurchase("ok")
        }
        #else
        #endif
        
        // add notification observers
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    //MARK:确定启动时，一定执行一次
    @objc func didBecomeActive() {
        print("did become active")
        let appDelegate:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
        appDelegate.checkRegisteredForRemoteNotifications()
        //根据用户的情况需要再次设置View
        setupSections()
        self.tableView.reloadData()
    }

//    fileprivate func reloadCloudData() {
//        refreshDataWithCloud()
//    }
    //MARK:- 判断当前有无用户数据，有的话重新获取云端数据然后刷新，没有的话再刷新一下视图
    //MARK:获取云端用户数据
    func refreshDataWithCloud(){
//       checkIfUserIsLoggedIn()
        if let uid = Auth.auth().currentUser?.uid {
            self.showLoadDialog()
            fetchUserAndSetupView(uid: uid)
        } else {
//       perform(#selector(handleLogout), with: nil, afterDelay: 0)
            packtrack_user = nil
            resetView_with_LocalUserInfo()
        }
    }
//    func checkIfUserIsLoggedIn() {
//        if FIRAuth.auth()?.currentUser?.uid == nil {
////            perform(#selector(handleLogout), with: nil, afterDelay: 0)
//            packtrack_user = nil
//            resetView_with_LocalUserInfo()
//        } else {
//            fetchUserAndSetupView()
//        }
//    }
    //MARK: 根据云端数据刷新View
    func fetchUserAndSetupView(uid:String) {
//        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
//            return
//        }
        weak var weak_self = self
        Database.database().reference().child(CloudDB_UserTable).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //                self.navigationItem.title = dictionary["name"] as? String
                //                self.setupNavBarWithUser(user)
                packtrack_user = MyUser(dictionary: dictionary)
                weak_self?.resetView_with_LocalUserInfo()
                self.dismissLoadDialog()
            }else{
                packtrack_user = nil
                weak_self?.resetView_with_LocalUserInfo()
                self.dismissLoadDialog()
            }
        }, withCancel: nil)
    }
    //MARK: observeUser
    func startObserveUser(uid:String){
        weak var weak_self = self
        Database.database().reference().child(CloudDB_UserTable).child(uid).observe(.childChanged, with: {
            (snapshot) in
            //print(snapshot.value)
            weak_self?.fetchUserAndSetupView(uid: uid)
        })
    }
    //MARK:- 根据当前用户数据刷新View
    func reloadViewWithUserData() {
        self.resetView_with_LocalUserInfo()
    }
    //MARK:根据获取的用户信息来显示到view
    func resetView_with_LocalUserInfo(){
        self.dismissLoadDialog()
        if let user = packtrack_user{
//            headView.iconView.nameBtn.setTitle(user.email, for: UIControlState())
            headView.setLoginedView()
        }else{
//            headView.iconView.nameBtn.setTitle("click to login", for: UIControlState())
            headView.setLogoutView()
        }
        self.setupSections()
        self.tableView.reloadData()
    }
    // MARK: Build UI
    fileprivate func buildUI() {
        weak var tmpSelf = self
        //添加会员头部
        headView =  MineHeadView(frame: CGRect(x: 0, y: 0 , width: ScreenWidth, height: headViewHeight),
                                 loginButtonClick: {() -> Void in
                                        tmpSelf?.popLoginVC()
                                    },
                                 CmButtonClick: {() -> Void in
                                        tmpSelf?.seeCM()
                                    }
        )
        view.addSubview(headView)
        //添加表格头部
        buildTableHeadView()
        //添加刷新按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh,
                                                                 target: self,
                                                                 action:  #selector(refreshDataWithCloud))
    }
    override func viewWillLayoutSubviews() {
        self.tableView.frame = CGRect(x: 0, y: headViewHeight , width: ScreenWidth,
               height: self.view.height - headViewHeight)
        super.viewWillLayoutSubviews()
    }
    
    // MARK: buildTableView
    fileprivate func buildTableHeadView() {
//        print(self.view.height)
//        print(ScreenHeight)
        tableView = LFBTableView(frame: CGRect(x: 0, y: headViewHeight , width: ScreenWidth,
                                               height: self.view.height - headViewHeight), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 46
//        tableView.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0 ,
//                                                              width: ScreenWidth,
//                                                              height: 100))
        view.addSubview(tableView)
        weak var tmpSelf = self
        tableHeadView = MineTabeHeadView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 70))
        // 点击headView回调
        tableHeadView.mineHeadViewClick = { (type) -> () in
            switch type {
            case .order:
                //生成备份文件
                tmpSelf?.createBakupFile();
                break
            case .coupon:
                //生成备份文件
//                let couponVC = CouponViewController()
//                tmpSelf!.navigationController!.pushViewController(couponVC, animated: true)
                tmpSelf?.restoreData();
                break
            case .message:
                //生成备份文件
//                let message = MessageViewController()
//                tmpSelf!.navigationController?.pushViewController(message, animated: true)
//                tmpSelf?.createBakupFile();
                tmpSelf?.moveToRedeliveySite();
                break
            }
        }
        tableView.tableHeaderView = tableHeadView
    }
    func showLoadDialog(){
        SVProgressHUD.resetOffsetFromCenter()
        SVProgressHUD.show()
    }
    func dismissLoadDialog(){
        SVProgressHUD.dismiss()
    }
    func requestReview(){
        MyReviewManager.requestReview(vc: self)
    }
}


extension MineViewController{
// MARK: 弹出login窗口
    // TODO: login後获取数据
    func popLoginVC(){
        //        let orderVc = LoginController()
        let storyboard = UIStoryboard(name: "gamesofchats", bundle:nil)
        let loginvc = storyboard.instantiateViewController(withIdentifier:
            "LoginController") as! LoginController
        loginvc.successCompletionHandle = {
            //            self.refreshDataWithCloud()
            //            self.startObserveUser()
            self.loginEventBlock()
        }
        let nv = UINavigationController.init(rootViewController: loginvc)
        self.present(nv, animated: true, completion: nil)
    }
    func loginEventBlock(){
        if let uid = Auth.auth().currentUser?.uid {
            self.fetchUserAndSetupView(uid: uid)
            self.startObserveUser(uid: uid)
        }
    }
//MARK:- Logout
    func logout(){
        let alert: UIAlertController = UIAlertController(title: "ログアウト", message: "ログアウトしてもいいですか？", preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "ログアウト", style: UIAlertActionStyle.default, handler:{
                (action: UIAlertAction!) -> Void in
            self.logoutEventBlock()
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{(action: UIAlertAction!) -> Void in })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }

    func logoutEventBlock(){
        self.showLoadDialog()
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        Database.database().reference().removeAllObservers()
        if let uid = Auth.auth().currentUser?.uid {
//            fetchUserAndSetupView(uid: uid)
            SVProgressHUD.showError(withStatus: "ログアウト失敗、もう一度試してください")
            SVProgressHUD.dismiss(withDelay: 3)
        } else {
            packtrack_user = nil
            resetView_with_LocalUserInfo()
            self.dismissLoadDialog()
        }
    }
}

// MARK:- UITableViewDataSource UITableViewDelegate
extension MineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MineCell.cellFor(tableView)
        cell.mineModel = MySectionS[indexPath.section].rows[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return MySectionS.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MySectionS[section].rows.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let block = MySectionS[indexPath.section].rows[indexPath.row].complete {
            block()
        }
    }
}


//    func requestDialog(){
//        let alert: UIAlertController = UIAlertController(title: "データをリストア", message: "既存デートを削除してもいいですか？", preferredStyle:  UIAlertControllerStyle.alert)
//        let defaultAction: UIAlertAction = UIAlertAction(title: "削除してリストア", style: UIAlertActionStyle.default, handler:{
//            (action: UIAlertAction!) -> Void in
//            myCloudDB.clearDB()
//        })
//        // キャンセルボタン
//        let cancel2Action: UIAlertAction = UIAlertAction(title: "そのままリストア", style: UIAlertActionStyle.default, handler:{
//            (action: UIAlertAction!) -> Void in
//            myCloudDB.clearDB()
//        })
//
//        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
//            (action: UIAlertAction!) -> Void in
//            print("Cancel")
//        })
//
//        alert.addAction(cancelAction)
//        alert.addAction(cancel2Action)
//        alert.addAction(defaultAction)
//        present(alert, animated: true, completion: nil)
//    }
