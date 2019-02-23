//
//  ComFunc.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/14.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import UIKit

//0主页，1再送，2查询
enum WebPageType: Int {
    case homePage = 0
    case deliveryPage = 1
    case trackPage = 2
}
class ComFunc {
    static let shared = ComFunc()

    static var ver_free : Bool = false
    static let TrackList_doing = 0
    static let TrackList_over = 1
    static let TrackList_all = -9999
    static let TrackList_del = -1
    static let TrackList_startstatus = 100
    static let InitStatus = [TrackList_doing, TrackList_over, TrackList_all, TrackList_del]
    static let InitStatusName = ["追跡中", "追跡完了", "全ての","ゴミ箱"]
    
    let Company_jppost = "1"
    let Company_yamato = "2"
    let Company_sagawa = "3"
    let Company_dhljp = "4"
    let Company_fedexjp = "5"
    let Company_seino = "6"
    let Company_nittsu = "7"
    let Company_usps = "8"
    let Company_tmg = "9"
    let Company_katlec = "11"
    let Company_fukutsu = "12"
    
    func getCompanyImg(_ packtype : String) -> UIImage{
        switch packtype {
        case Company_jppost:        return UIImage(named: "ic_list_jppost")!
        case Company_yamato:        return UIImage(named: "ic_list_yamato.png")!
        case Company_sagawa:        return UIImage(named: "ic_list_sagawa.png")!
        case Company_dhljp:         return UIImage(named: "ic_list_dhl.png")!
        case Company_fedexjp:       return UIImage(named: "ic_list_fedex.png")!
        case Company_seino:         return UIImage(named: "ic_list_seino.png")!
        case Company_nittsu:        return UIImage(named: "ic_list_nittsu.png")!
        case Company_usps:          return UIImage(named: "ic_list_usps.png")!
        case Company_tmg:          return UIImage(named: "ic_list_tmg.png")!
        case Company_katlec:        return UIImage(named: "ic_list_ka.png")!
        case Company_fukutsu:       return UIImage(named: "ic_list_fukuyama.png")!
        default:
            return UIImage.init()
        }
    }
    
    func getCompanyName(_ packtype : String) -> String{
        switch packtype {
        case Company_jppost:        return "日本郵便"
        case Company_yamato:        return "ヤマト運輸"
        case Company_sagawa:        return "佐川急便"
        case Company_dhljp:         return "DHL"
        case Company_fedexjp:       return "FEDEX"
        case Company_seino:         return "西濃運輸"
        case Company_nittsu:        return "日本通運"
        case Company_usps:          return "USPS"
        case Company_tmg:           return "デリバリープロバイダ(TMG)"
        case Company_katlec:        return "カトーレック"
        case Company_fukutsu:       return "福山通運"
        default:
            return ""
        }
    }
    func getCompanyImgName(_ packtype : String) -> String{
        switch packtype {
        case Company_jppost:        return "ic_list_jppost"
        case Company_yamato:        return "ic_list_yamato"
        case Company_sagawa:        return "ic_list_sagawa"
        case Company_dhljp:         return "ic_list_dhljp"
        case Company_fedexjp:       return "ic_list_fedexjp"
        case Company_seino:         return "ic_list_seino"
        case Company_nittsu:        return "ic_list_nittsu"
        case Company_usps:          return "ic_list_usps"
        case Company_tmg:           return "ic_list_tmg"
        case Company_katlec:        return "ic_list_katlec"
        case Company_fukutsu:       return "ic_list_fukutsu"
        default:
            return ""
        }
    }
    
    
    func isOnlyWeb(_ packtype : String) -> Bool{
        switch packtype {
        case Company_jppost:            return false
        case Company_yamato:            return false
        case Company_sagawa:            return false
        case Company_tmg:               return false
        case Company_seino:             return false
            
        case Company_dhljp:             return true
        case Company_fedexjp:           return true
        case Company_nittsu:            return true
        case Company_usps:              return true
        case Company_katlec:            return true
        case Company_fukutsu:           return true
        default:
            return true
        }
    }
    func getAPIURL2(_ packtype : String,trackno:String) -> String{
        return "http://1-dot-firetest-ac228.appspot.com/trackapi"
//        switch packtype {
//        case Company_jppost:
//        case Company_yamato:
//        case Company_sagawa:
//        case Company_tmg:
//        case Company_seino:
//        default:
//            return ""
//        }
    }
    
    func getNewTrackMain(_ oldtrackmain : TrackMain,newtrackmain : TrackMain) -> TrackMain{
    
        oldtrackmain.typeName  = newtrackmain.typeName
        oldtrackmain.errorCode = newtrackmain.errorCode
        oldtrackmain.errorMsg = newtrackmain.errorMsg
        
        if ((oldtrackmain.latestDate == newtrackmain.latestDate ) &&
            (oldtrackmain.latestStatus == newtrackmain.latestStatus) &&
            (oldtrackmain.latestStore == newtrackmain.latestStore) &&
            (oldtrackmain.latestDetail == newtrackmain.latestDetail) &&
            (oldtrackmain.latestDetailNo == newtrackmain.latestDetailNo) &&
            (oldtrackmain.typeName  == newtrackmain.typeName) &&
            (oldtrackmain.strStatus == newtrackmain.strStatus)){
                
            //oldtrackmain.haveUpdate = false
        
        }else{
            oldtrackmain.haveUpdate = true
            
            oldtrackmain.strStatus = newtrackmain.strStatus
            oldtrackmain.latestDate = newtrackmain.latestDate
            oldtrackmain.latestStatus = newtrackmain.latestStatus
            oldtrackmain.latestStore = newtrackmain.latestStore
            oldtrackmain.latestDetail = newtrackmain.latestDetail
            oldtrackmain.latestDetailNo = newtrackmain.latestDetailNo
        }
        
        oldtrackmain.detailList = newtrackmain.detailList
        
        return oldtrackmain
    }
    
    func copytoPasteBoard( _ str: String){
        let generalPasteboard: UIPasteboard = UIPasteboard.general
        generalPasteboard.string = str;
    }
    // MARK:  公司的网页
    // type 0主页，1再送，2查询
    func getHomePage(_ trackno : String = "",tracktype : String , type : Int) -> String{
        var URL : String = ""
        switch (tracktype) {
        case Company_jppost:
            if(type == 0){ URL = "http://www.post.japanpost.jp/smt/";}
            if(type == 1){ URL = "https://trackings.post.japanpost.jp/delivery/sp/deli/";}
            if(type == 2){ URL = "http://tracking.post.japanpost.jp/services/sp/srv/search/?search=start&locale=ja&requestNo1=##mytrack_no##"}
            break
        case Company_yamato:
            if(type == 0){ URL = "http://www.kuronekoyamato.co.jp/smp/index.html";}
            if(type == 1){ URL = "http://www.kuronekoyamato.co.jp/smp/index.html";}
            if(type == 2){ URL = "http://www.kuronekoyamato.co.jp/smp/index.html";}
            break
        case Company_sagawa:
            if(type == 0){ URL = "http://www.sagawa-exp.co.jp/";}
            if(type == 1){ URL = "http://www.sagawa-exp.co.jp/send/redeliver.html";}
            if(type == 2){ URL = "http://www.sagawa-exp.co.jp/";}
            break
            /**        
        case Company_dhljp:
            if(type == 0) URL="http://www.dhl.co.jp/ja/express/tracking.html?AWB=##mytrack_no##&brand=DHL";
            if(type == 1) URL="http://www.dhl.co.jp/ja/express/tracking.html?AWB=##mytrack_no##&brand=DHL";
            if(type == 2) URL="http://www.dhl.co.jp/ja/express/tracking.html?AWB=##mytrack_no##&brand=DHL";
            
            break
        case Company_fedexjp:
            if(type == 0) URL="https://www.fedex.com/apps/fedextrack/?atcion=track&cntry_code=jp&tracknumbers=##mytrack_no##";
            if(type == 1) URL="https://www.fedex.com/apps/fedextrack/?atcion=track&cntry_code=jp&tracknumbers=##mytrack_no##";
            if(type == 2) URL="https://www.fedex.com/apps/fedextrack/?atcion=track&cntry_code=jp&tracknumbers=##mytrack_no##";
            break
        case Company_usps:
            if(type == 0) URL="https://tools.usps.com/go/TrackConfirmAction.action?tRef=fullpage&tLc=1&text28777=&tLabels=##mytrack_no##";
            if(type == 1) URL="https://tools.usps.com/go/TrackConfirmAction.action?tRef=fullpage&tLc=1&text28777=&tLabels=##mytrack_no##";
            if(type == 2) URL="https://tools.usps.com/go/TrackConfirmAction.action?tRef=fullpage&tLc=1&text28777=&tLabels=##mytrack_no##";
            break
            **/
            
        case Company_seino:
            if(type == 0){ URL="http://www.seino.co.jp/seino/spn/";}
            if(type == 1){ URL="https://track.seino.co.jp/redeli/menuDelivery4SPN.do";}
            if(type == 2){ URL="https://track.seino.co.jp/kamotsu/gempyoNoShokaiSpn.do";}
            break
        case Company_nittsu:
            if(type == 0){ URL="https://lp-trace.nittsu.co.jp/web/webarpaa702.srv?LANG=JP&denpyoNo1=##mytrack_no##";}
            if(type == 1){ URL="https://lp-trace.nittsu.co.jp/web/webarpaa702.srv?LANG=JP&denpyoNo1=##mytrack_no##";}
            if(type == 2){ URL="https://lp-trace.nittsu.co.jp/web/webarpaa702.srv?LANG=JP&denpyoNo1=##mytrack_no##";}
            break;
        case Company_katlec:
            if(type == 0){ URL="http://www6.katolec.com/tracking/amzn/tracking.aspx";}
            if(type == 1){ URL="https://www6.katolec.com/deliver/";}
            //https://www6.katolec.com/mobile/main.aspx?
            if(type == 2){ URL="http://www6.katolec.com/tracking/amzn/tracking.aspx";}
            break;
        case Company_fukutsu:
            if(type == 0){ URL="http://corp.fukutsu.co.jp/";}
            if(type == 1){ URL="http://corp.fukutsu.co.jp/";}
            if(type == 2){ URL="http://www.fukutsu.co.jp/i/searchi.html";}
            break;
        default:
            break;
        }
        
        URL = URL.replacingOccurrences(of: "##mytrack_no##", with: trackno, options: [], range: nil)
        return URL
    }
    
    func getNowDateStr() -> String{
        let dateFormatter = DateFormatter()                                   // フォーマットの取得
        dateFormatter.locale = Locale(identifier: "ja_JP")  // JPロケール
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"         // フォーマットの指定
        return dateFormatter.string(from: Date())
        //println("i="+listTrackMain[rowIndex].trackNo  + ",start" + dateFormatter.stringFromDate(NSDate()))                // 現在日時
    }
    
    func getTimeInterval(_ oldstr : String) -> String{
        //var ret : String = ""
        let dateFormatter = DateFormatter()                                   // フォーマットの取得
        dateFormatter.locale = Locale(identifier: "ja_JP")  // JPロケール
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"         // フォーマットの指定
        if let oldtime = dateFormatter.date(from: oldstr){
            let second = Date().timeIntervalSince(oldtime)
            if(second < 60){ return "1分未満前に"}
            if(second < 300){ return "5分未満前に"}
            if(second < 1800){ return "30分未満前に"}
            if(second < 3600){ return "1時間未満前に"}
            if(second < (3600 * 2)){ return "2時間未満前に"}
            if(second < (3600 * 5)){ return "5時間未満前に"}
            if(second < (3600 * 10)){ return "10時間未満前に"}
            if(second < (3600 * 12)){ return "12時間未満前に"}
            if(second < (3600 * 24)){ return "1日未満前に"}
            if(second < (3600 * 48)){ return "2日未満前に"}
            //        return DateUtils.StrFormateWithYear(instr: oldstr) + "に"
            return oldstr + "に"
        }else{
            return ""
        }
    }
    
    //配達完了のチェック
    let DeliveryOverStrList=["お届け済み","配達完了","配達は終了","投函完了","完了","窓口でお渡し","配達しました","配達済み"]
    func getDeliveryOverStr(_ instr : String) -> NSMutableAttributedString{
        let attrText = NSMutableAttributedString(string: instr)
        for substr in DeliveryOverStrList{
            if NSString(string: instr).contains(substr) {
                return searchSubString(instr,substr: substr)
            }
        }
        return attrText
    }
    func isDeliveryOver(_ instr : String) -> Bool {
        for substr in DeliveryOverStrList{
            if NSString(string: instr).contains(substr) {
                return true
            }
        }
        return false
    }
    
    //No errのチェック
    let ErrNoStrList=["誤り","をお確かめ","見つかりません","未登録","登録されておりません"]
    func isErrNo(_ instr : String) -> Bool {
        for substr in ErrNoStrList{
            if NSString(string: instr).contains(substr) {
                return true
            }
        }
        return false
    }
    
    
    func searchSubString(_ instr:String,substr:String)-> NSMutableAttributedString{
        let attrText = NSMutableAttributedString(string: instr)
        let subRange = (instr as NSString).range(of: substr)   //子范围
        let range = NSMakeRange(subRange.location, subRange.length)
        attrText.addAttribute(NSForegroundColorAttributeName,value: UIColor.red,range: range)
        return attrText
    }
    func isDeliveryOver(_ bean : TrackMain) -> Bool {
        var strTemp = bean.latestDate  + bean.latestStatus + bean.latestDetail
        if(strTemp.isEmpty){
            strTemp = bean.typeName
        }else{
            
        }
        return isDeliveryOver(strTemp)
    }
    func isErrNo(_ bean : TrackMain) -> Bool {
        var strTemp = bean.latestDate  + bean.latestStatus + bean.latestDetail
        if(strTemp.isEmpty){
            strTemp = bean.typeName
        }else{
            
        }
        return isErrNo(strTemp)
    }
    
    init() {
        
    }
}

extension String{
 /**   func escapeSpaceTillCahractor()->String{
        return self.stringEscapeHeadTail(strs:["\r", " ", "\n"])
    }
    func escapeHeadStr(str:String)->(String, Bool){
        var result = self as NSString
        var findAtleastOne = false
        while( true ){
            var range = result.rangeOfString(str)
            if range.location == 0 && range.length == 1 {
                result = result.substringFromIndex(range.length)
                findAtleastOne = true
            }else{
                break
            }
        }
        return (result as String, findAtleastOne)
    }
    func escapeSpaceTillCahractor(#strs:[String])->String{
        var result = self
        while( true ){
            var findAtleastOne = false
            for str in strs {
                var found:Bool = false
                (result, found) = result.escapeHeadStr(str)
                if found {
                    findAtleastOne = true
                    break  //for循环
                }
            }
            if findAtleastOne == false {
                break
            }
        }
        return result as String
    }
    func reverse()->String{
        var inReverse = ""
        for letter in self {
            println(letter)
            inReverse = "\(letter)" + inReverse
        }
        return inReverse
    }
    func escapeHeadTailSpace()->String{
        return self.escapeSpaceTillCahractor().reverse().escapeSpaceTillCahractor().reverse()
    }
    func stringEscapeHeadTail(#strs:[String])->String{
        return self.escapeSpaceTillCahractor(strs:strs).reverse().escapeSpaceTillCahractor(strs:strs).reverse()
    }
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }**/
    
    func removeWhitespace() -> String {
        //let str = self.replace(" ", replacement: "")
        //let str1 = self.replace("   ", replacement: "")
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    func removeWhitespace2() -> String {
        return self.replacingOccurrences(of: "　", with: "", options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeAllWhitespace() -> String {
        var str1 =  self.replacingOccurrences(of: "　", with: "", options: NSString.CompareOptions.literal, range: nil)
        var str2 =  str1.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        return str2
    }
}
