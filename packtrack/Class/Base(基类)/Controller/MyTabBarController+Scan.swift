//
//  MyTabBarController.swift
//  packtrack
//
//  Created by ksymac on 2017/10/30.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit
import LBXScan
import TOWebViewController

// MARK: - 设置统一弹出画面，设置全局扫描窗口和变量
// 扫描根窗口
var ScanNabvc:UINavigationController?
// Web根窗口
var WebNabvc:UINavigationController?
// MARK: 统一弹出画面，弹出公司画面
//var companyNabvc:MyUINavigationController?
var ScanVC:DIYScanViewController? = nil
//var barcodeScanVC:DIYScanViewController? = DIYScanViewController.init()
extension MyTabBarController:MYScanDelegate{
    func dismissAllPop() {
        ScanNabvc?.dismiss(animated: false) {}
        WebNabvc?.dismiss(animated: false) {}
        
        ScanVC?.dismiss(animated: false, completion: nil)
//        barcodeScanVC?.dismiss(animated: false, completion: nil)
//        WebNabvc?.dismiss(animated: false, completion: nil)
    }
    // MARK: - 不在票スキャン
    func scanUndeliverableItemNotice(in_style : LBXScanViewStyle){
        if(ScanVC == nil){
            ScanVC = DIYScanViewController.init()
        }
        ScanVC?.isOpenInterestRect = true
        //myScanVC.style = StyleDIY.notSquare()
        //ScanVC?.style = StyleDIY.zhiFuBaoStyle()
        ScanVC?.style = in_style
        ScanVC?.libraryType = SCANLIBRARYTYPE.SLT_ZXing
        ScanVC?.scanCodeType = SCANCODETYPE.SCT_BarCode93;
        ScanVC?.delegate = self
//        ScanVC?.loadViewIfNeeded()
//        ScanVC?.reStartDevice()
        ScanNabvc = UINavigationController.init(rootViewController: ScanVC!)
        if let vc = ScanNabvc{
            self.present(vc, animated: true) {
            }
        }
    }
    
    func setScanRet(_ strResult: LBXScanResult!) {
            let strScan = strResult.strScanned;
//            print(strScan)
            ScanNabvc?.dismiss(animated: false) {
                self.popWebView(url: strScan)
            }
    }
    // MARK: 扫描结果打开网页
    func popWebView(url:String?){
        guard let urlstr = url else {
                return
        }
        let webvc: TOWebViewController = TOWebViewController.init(urlString: urlstr)
        WebNabvc = MyUINavigationController.init(rootViewController: webvc)
        if let vc = WebNabvc{
            self.present(vc, animated: true) {
            }
        }
    }
}
