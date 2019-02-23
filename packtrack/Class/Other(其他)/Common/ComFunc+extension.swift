//
//  ComFunc.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/14.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import UIKit

//公司类型
enum TrackComType: String {
    case Company_jppost = "1"
    case Company_yamato = "2"
    case Company_sagawa = "3"
    case Company_dhljp = "4"
    case Company_fedexjp = "5"
    case Company_seino = "6"
    case Company_nittsu = "7"
    case Company_usps = "8"
    case Company_tmg = "9"
    case Company_katlec = "11"
    case Company_fukutsu = "12"
}

// MARK: - 公司的网页
extension ComFunc {
    // MARK: 跟踪的网页
    // type 0主页，1再送，2查询
    func getTrackURL(_ trackno : String ,tracktype : String) -> URLRequest?{
        switch (tracktype) {
        case Company_jppost:
            let url1 : String=ComFunc().getHomePage(trackno,
                                                    tracktype: tracktype,
                                                    type: WebPageType.trackPage.rawValue)
            do {
                if let okurl = URL(string: url1){
                    return URLRequest(url: okurl)
                }else{
                    return URLRequest(url: URL(string:"http://www.post.japanpost.jp/smt/")!)
                }
            }catch let ErrorType {
                print(ErrorType)
                return URLRequest(url: URL(string:"http://www.post.japanpost.jp/smt/")!)
            }
        case Company_yamato:
            let url = URL(string: "http://smp.kuronekoyamato.co.jp/smp/tneko")
            let request = NSMutableURLRequest(url: url!)
            request.httpMethod = "POST"
            let bodyData: String = "number01="+trackno;
            request.httpBody = bodyData.data(using: String.Encoding.utf8)
            
            return request as URLRequest
        case Company_sagawa:
            let url = URL(string: "http://k2k.sagawa-exp.co.jp/p_smt/web/smtOkurijoSearch.do")
            let request = NSMutableURLRequest(url: url!)
            request.httpMethod = "POST"
            let bodyData: String = "okurijoNo="+trackno
            request.httpBody = bodyData.data(using: String.Encoding.utf8)
            return request as URLRequest
            
        case Company_seino:
            let url = URL(string: "http://track.seino.co.jp/kamotsu/KamotsuPrintServlet?ACTION=DETAIL&NUMBER=1&GNPNO1="+trackno)
            return URLRequest(url: url!)

        default:
            break;
        }
        return nil
    }
    // MARK: 再配達的网页
    // type 0主页，1再送，2查询
    func getRedeliveyURL(_ trackno : String ,tracktype : String) -> URLRequest?{
        switch (tracktype) {
        case Company_jppost:
            let url = URL(string: "https://trackings.post.japanpost.jp/delivery/sp/deli/")
            return URLRequest(url: url!)
        case Company_yamato:
            let url = URL(string: "https://smp-cmypage.kuronekoyamato.co.jp/smp_portal/s/loginpage")
            return URLRequest(url: url!)
        case Company_sagawa:
            let url = URL(string: "https://www.e-service.sagawa-exp.co.jp/e/f.d")
            return URLRequest(url: url!)
        case Company_tmg:
            let url = URL(string: "http://track-a.tmg-group.jp/cts/Redelivery.do?method_id=INIT")
            return URLRequest(url: url!)
        case Company_seino:
            let url = URL(string: "https://track.seino.co.jp/redeli/menuDelivery.do")
            return URLRequest(url: url!)
        case Company_katlec:
            let url = URL(string: "https://www6.katolec.com/deliver/")
            return URLRequest(url: url!)
        default:
            break;
        }
        return nil
    }
    
    
    
    
}
