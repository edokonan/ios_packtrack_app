//
//  MoreTableViewController.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/13.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class RowType:NSObject{
    var title:String?
    var complete: (()->())?
    convenience init(title:String,complete:@escaping ()->()) {
        self.init()
        self.title=title
        self.complete=complete
    }
    override init(){
        super.init()
    }
}
class SectionType:NSObject{
    var title:String?
    var rows:[RowType]=[]
    convenience init(title:String) {
        self.init()
        self.title=title
    }
    override init(){
        super.init()
    }
}

class MoreTableViewController: UITableViewController , MFMailComposeViewControllerDelegate{
    
    
    var SectionS : [SectionType] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 80.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().barStyle = UIBarStyle.default
        //UITabBar.appearance().barTintColor = UIColor(red: 80.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        
        setupSections();
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
extension MoreTableViewController{
    func setupSections(){
        SectionS=[]
        let section1 = SectionType(title: "フィードバック")
        section1.rows.append(RowType(title: "ご意見とお問い合わせ", complete: {
                self.onClickStartMailerBtn();
            }))
        SectionS.append(section1)
        
        let section2 = SectionType(title: "設定")
        section2.rows.append(RowType(title: "整理ボックス追加", complete: {
            self.popBoxSetting();
        }))
        SectionS.append(section2)
        
        #if FREE
//            let section3 = SectionType(title: "正式版またはオプションサービス")
//            section3.rows.append(RowType(title: "正式版を購入", complete: {
//                self.onClickStartMailerBtn();
//            }))
//            SectionS.append(section3)
            let section3 = SectionType(title: "ad")
            section3.rows.append(RowType(title: "ad", complete: {
                            self.showAD();
                        }))
//            section3.rows.append(RowType(title: "register", complete: {
//                CloudUser().register();
//            }))
//            section3.rows.append(RowType(title: "login", complete: {
//                CloudUser().login();
//            }))
//            section3.rows.append(RowType(title: "saveData", complete: {
//
//            }))
//            section3.rows.append(RowType(title: "getData", complete: {
//                CloudDBRef().getData();
//            }))
            SectionS.append(section3)
        #else
        #endif
        
        
        let section4 = SectionType(title: "再配達サイト")
        section4.rows.append(RowType(title: "日本郵便", complete: {
            self.movetoHomePage(TrackComType.Company_jppost);
        }))
        section4.rows.append(RowType(title: "ヤマト運輸", complete: {
            self.movetoHomePage(TrackComType.Company_yamato);
        }))
        section4.rows.append(RowType(title: "佐川急便", complete: {
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
    
    // MARK:ご意見とお問い合わせ
    func onClickStartMailerBtn() {
        //メールを送信できるかチェック
        if MFMailComposeViewController.canSendMail()==false {
            print("Email Send Failed")
            return
        }
        
        let mailViewController = MFMailComposeViewController()
        let toRecipients = ["svalbard.k@gmail.com"]
        //var CcRecipients = ["cc@1gmail.com","Cc2@1gmail.com"]
        //var BccRecipients = ["Bcc@1gmail.com","Bcc2@1gmail.com"]
        mailViewController.mailComposeDelegate = self
        mailViewController.setSubject("IOS版荷物追跡アプリについて")
        mailViewController.setToRecipients(toRecipients) //宛先メールアドレスの表示
        //mailViewController.setCcRecipients(CcRecipients)
        //mailViewController.setBccRecipients(BccRecipients)
        mailViewController.setMessageBody("", isHTML: false)
        
        self.present(mailViewController, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Email Send Cancelled")
            break
        case MFMailComposeResult.saved.rawValue:
            print("Email Saved as a Draft")
            break
        case MFMailComposeResult.sent.rawValue:
            print("Email Sent Successfully")
            break
        case MFMailComposeResult.failed.rawValue:
            print("Email Send Failed")
            break
        default:
            break
        }
        
        self.dismiss(animated: true, completion: nil)
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
    
}
extension MoreTableViewController: GADRewardBasedVideoAdDelegate{
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
    }
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
    }
}
