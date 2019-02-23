//
//  ViewController.swift
//  packtrack
//
//  Created by ksymac on 2017/11/26.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

extension MineViewController:MFMailComposeViewControllerDelegate {
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
    
    //MARK:- ご意見とお問い合わせ
    func shareMyAPPLICATION(){
        
        let text = "MY宅配便は、宅配荷物を管理するアプリです。　#MY宅配便 "
//        let text = "sample text"
        let sampleUrl = NSURL(string: "https://itunes.apple.com/jp/app/id1031589055")!
        let image = UIImage(named: "icon72")!
        let items = [text,sampleUrl,image] as [Any]
        
        // UIActivityViewControllerをインスタンス化
        let activityVc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        activityVc.popoverPresentationController?.sourceView = self.view;
        activityVc.popoverPresentationController?.sourceRect = CGRect.init(x: 0,
                                                                          y: self.view.frame.height/2,
                                                                          width: self.view.frame.width,
                                                                          height: self.view.frame.height);
        // UIAcitivityViewControllerを表示
        self.present(activityVc, animated: true, completion: nil)
    }
    
    //MARK:- 再配達サイト
    func moveToRedeliveySite(){
        // styleをActionSheetに設定
        let alertSheet = UIAlertController(title: "再配達サイト", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        //日本郵便 (ご不在連絡票情報入力)
        let action1 = UIAlertAction(title: "日本郵便", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            self.movetoHomePage(TrackComType.Company_jppost);
        })
        let action2 = UIAlertAction(title: "ヤマト運輸", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            self.movetoHomePage(TrackComType.Company_yamato);
        })
        let action3 = UIAlertAction(title: "佐川急便", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            self.movetoHomePage(TrackComType.Company_sagawa);
        })
        let action5 = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        // アクションを追加
        alertSheet.addAction(action1)
        alertSheet.addAction(action2)
        alertSheet.addAction(action3)
        alertSheet.addAction(action5)
        self.present(alertSheet, animated: true, completion: nil)
    }
    func movetoHomePage(_ tracktype:TrackComType){
        //　MARK: 显示再配達View
        let storyboard: UIStoryboard = UIStoryboard(name: "WebView", bundle: nil)
        let webViewController: RedeliveyWebVC = storyboard.instantiateViewController(withIdentifier: "RedeliveyWebVC") as! RedeliveyWebVC
        webViewController.hidesBottomBarWhenPushed = true//
        webViewController.trackMain=nil
        webViewController.tracktype=tracktype
        self.navigationController?.pushViewController(webViewController, animated:true)
    }
}

