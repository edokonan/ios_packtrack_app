//
//  TrackWebViewController.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/14.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//
import UIKit
import Firebase
import SVProgressHUD

class CompanySectionType:NSObject{
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
extension CompanyViewController {

    func setupSections(){
        guard let type = self.tracktype else{
            return
        }
        switch type {
        case TrackComType.Company_jppost:
            setupSections_jppost()
        case TrackComType.Company_yamato:
            setupSections_yamato()
        case TrackComType.Company_sagawa:
            setupSections_sagawa()
        case TrackComType.Company_tmg:
            setupSections_tmg()
        case TrackComType.Company_nittsu:
            setupSections_nittsu()
        case TrackComType.Company_katlec:
            setupSections_katlec()
        case TrackComType.Company_seino:
            setupSections_seino()
        default:
            return
        }
    }
    // MARK: 日本郵便
    func setupSections_jppost(){
        MySectionS = []
        weak var weak_self = self
        let section1 = MineSectionType(title: "電話")
        section1.rows.append(MineCellModel(title: "24時間自動受付:0800-997-7000(無料)",
                                           iconName: "icons8onlinesupport-1", complete: {
                    self.callTelWithNo("0800-997-7000")
        }))
        section1.rows.append(MineCellModel(title: "携帯電話から:0570-046-645 (有料)",
                                           iconName:"icons8onlinesupport-1", complete: {
                    self.callTelWithNo("0570-046-645")
        }))
        section1.rows.append(MineCellModel(title: "集荷申込み:0800-0800-111(無料)",
                                           iconName: "icons8onlinesupport-1", complete: {
                    self.callTelWithNo("0800-0800-111")
        }))
        MySectionS.append(section1)
        
        let section2 = MineSectionType(title: "再配達")
        section2.rows.append(MineCellModel(title: "再配達の依頼",
                                           iconName: "icons8info", complete: {
//                    self.popWebPage("https://trackings.post.japanpost.jp/delivery/sp/deli/")
                self.movetoHomePage(TrackComType.Company_jppost);
        }))
//        section2.rows.append(MineCellModel(title: "集荷のお申込み",
//                                           iconName: "icons8info", complete: {
//                    self.popWebPage("mgr.post.japanpost.jp/C20P02Action.do?ssoparam=0&termtype=0")
//        }))
        section2.rows.append(MineCellModel(title: "郵便局、ATM等を検索",
                                           iconName: "icons8info", complete: {
                self.popWebPage("https://map.japanpost.jp/smt/search/")
        }))
        section2.rows.append(MineCellModel(title: "ホームページ",
                                           iconName: "icons8info", complete: {
                self.popWebPage("www.post.japanpost.jp/")
        }))
        
        MySectionS.append(section2)
    }
    // MARK: クロネコヤマト
    func setupSections_yamato(){
        MySectionS = []
        weak var weak_self = self
        let section1 = MineSectionType(title: "電話")
        section1.rows.append(MineCellModel(title: "0120-01-9625(フリー、8:00-21:00)",
                                           iconName:"icons8onlinesupport-1", complete: {
              self.callTelWithNo("0120-01-9625")
        }))
        section1.rows.append(MineCellModel(title: "050-3786-3333(050IP電話から)",
                                           iconName: "icons8onlinesupport-1", complete: {
                                            self.callTelWithNo("050-3786-3333")
        }))
        MySectionS.append(section1)
        section1.rows.append(MineCellModel(title: "0570-200-000",
                                           iconName: "icons8onlinesupport-1", complete: {
              self.callTelWithNo("0570-200-000")
        }))
        
        let section2 = MineSectionType(title: "再配達")
        section2.rows.append(MineCellModel(title: "お受け取り日時場所の変更受付登録",
                                           iconName: "icons8info", complete: {
               self.popWebPage("https://uketori.kuronekoyamato.co.jp/ukehenko/SLIPNOINPUT")
        }))
        
        section2.rows.append(MineCellModel(title: "再配達受付",
                                           iconName: "icons8info", complete: {
               self.movetoHomePage(TrackComType.Company_yamato);
//               self.popWebPage("https://cmypage.kuronekoyamato.co.jp/portal/loginpage?serviceId=S033")
        }))
        section2.rows.append(MineCellModel(title: "最寄りのサービスセンターまでお問い合わせ",
                                           iconName: "icons8info", complete: {
                self.popWebPage("http://www.kuronekoyamato.co.jp/ytc/center/servicecenter_list.html")
        }))
        
        section2.rows.append(MineCellModel(title: "ホームページ",
                                           iconName: "icons8info", complete: {
                self.popWebPage("http://www.kuronekoyamato.co.jp/")
        }))
        
        MySectionS.append(section2)
    }
    // MARK: 佐川
    func setupSections_sagawa(){
        MySectionS = []
        weak var weak_self = self
//        let section1 = MineSectionType(title: "フィードバック")
//        section1.rows.append(MineCellModel(title: "電話:0120-130-661(フリー、9:00-21:00)",
//                                           iconName:"icons8onlinesupport-1", complete: {
//            self.callTelWithNo("0120-130-661")
//        }))
//        section1.rows.append(MineCellModel(title: "自動電話受付:050-5525-7445(24時間)",
//                                           iconName: "icons8onlinesupport-1", complete: {
//            self.callTelWithNo("050-5525-7445")
//        }))
//        MySectionS.append(section1)
//
        let section2 = MineSectionType(title: "再配達")
        section2.rows.append(MineCellModel(title: "再配達",
                                           iconName: "icons8info", complete: {
//            self.popWebPage("https://www.e-service.sagawa-exp.co.jp/e/f.d")
            self.movetoHomePage(TrackComType.Company_sagawa);
        }))
        section2.rows.append(MineCellModel(title: "担当営業所検索",
                                           iconName: "icons8info", complete: {
            self.popWebPage("http://www.sagawa-exp.co.jp/send/branch_search/tanto/")
        }))
        MySectionS.append(section2)
    }
    
    // MARK: T.M.G
    func setupSections_tmg(){
        MySectionS = []
        weak var weak_self = self
        let section1 = MineSectionType(title: "電話")
        section1.rows.append(MineCellModel(title: "電話:0120-130-661(フリー、9:00-21:00)",
                                           iconName:"icons8onlinesupport-1", complete: {
            self.callTelWithNo("0120-130-661")
        }))
        section1.rows.append(MineCellModel(title: "自動電話受付:050-5525-7445(24時間)",
                                           iconName: "icons8onlinesupport-1", complete: {
            self.callTelWithNo("050-5525-7445")
        }))
        MySectionS.append(section1)

        let section2 = MineSectionType(title: "再配達")
        section2.rows.append(MineCellModel(title: "Amazonの再配達・配達前の日時変更",
                                           iconName: "icons8info", complete: {
             self.popWebPage("http://track-a.tmg-group.jp/cts/Redelivery.do?method_id=INIT")
        }))
        section2.rows.append(MineCellModel(title: "T.M.Gの再配達・配達前の日時変更",
                                           iconName: "icons8info", complete: {
              self.popWebPage("http://track.tmg-group.jp/cts/Redelivery.do?method_id=INIT")
        }))
        MySectionS.append(section2)
    }
    
    // MARK: nittsu
    func setupSections_nittsu(){
        MySectionS = []
        weak var weak_self = self
        let section1 = MineSectionType(title: "電話")
        section1.rows.append(MineCellModel(title: "電話:0120-130-661(フリー、9:00-21:00)",
                                           iconName:"icons8onlinesupport-1", complete: {
                                            self.callTelWithNo("0120-130-661")
        }))
        section1.rows.append(MineCellModel(title: "自動電話受付:050-5525-7445(24時間)",
                                           iconName: "icons8onlinesupport-1", complete: {
                                            self.callTelWithNo("050-5525-7445")
        }))
        MySectionS.append(section1)
        
        let section2 = MineSectionType(title: "再配達")
        section2.rows.append(MineCellModel(title: "Amazonの再配達・配達前の日時変更",
                                           iconName: "icons8info", complete: {
                                            self.popWebPage("http://track-a.tmg-group.jp/cts/Redelivery.do?method_id=INIT")
        }))
        section2.rows.append(MineCellModel(title: "T.M.Gの再配達・配達前の日時変更",
                                           iconName: "icons8info", complete: {
                                            self.popWebPage("http://track.tmg-group.jp/cts/Redelivery.do?method_id=INIT")
        }))
        MySectionS.append(section2)
    }
    // MARK: katlec
    func setupSections_katlec(){
        MySectionS = []
        weak var weak_self = self
        let section1 = MineSectionType(title: "電話")
        section1.rows.append(MineCellModel(title: "電話:043-424-3000(9:00-20:00)",
                                           iconName:"icons8onlinesupport-1", complete: {
                                            self.callTelWithNo("043-424-3000")
        }))
        MySectionS.append(section1)
        
        let section2 = MineSectionType(title: "再配達")
        section2.rows.append(MineCellModel(title: "再配達",
                                           iconName: "icons8info", complete: {
               self.popWebPage("https://www6.katolec.com/deliver/")
        }))
        section2.rows.append(MineCellModel(title: "集荷依頼",
                                           iconName: "icons8info", complete: {
            self.popWebPage("https://www6.katolec.com/deliver/")
        }))
        MySectionS.append(section2)
    }
    // MARK: 西濃
    func setupSections_seino(){
        MySectionS = []
        weak var weak_self = self
        let section1 = MineSectionType(title: "電話")
        section1.rows.append(MineCellModel(title: "電話:0120-945-880(フリーダイヤル、24時間)",
                                           iconName:"icons8onlinesupport-1", complete: {
                                            self.callTelWithNo("0120-945-880")
        }))
        MySectionS.append(section1)
        
        let section2 = MineSectionType(title: "再配達")
        section2.rows.append(MineCellModel(title: "再配達",
                                           iconName: "icons8info", complete: {
                self.popWebPage("https://track.seino.co.jp/kamotsu/GempyoNoShokai.do")
        }))
        section2.rows.append(MineCellModel(title: "集荷依頼",
                                           iconName: "icons8info", complete: {
                self.popWebPage("https://track.seino.co.jp/CallCenterPlusOpen/PickupOpen.do")
        }))
        MySectionS.append(section2)
    }
    
    // MARK: 電話
    func callTelWithNo(_ telno: String) {
        let urlString = "tel://" + telno
        if let url = URL(string: urlString) {
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    // MARK: Webを表示
    func popWebPage(_ url:String){
        let tabvc: MyTabBarController = self.tabBarController as! MyTabBarController
        tabvc.popWebView(url: url)
    }
    // MARK: 再配達ページへ遷移
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
