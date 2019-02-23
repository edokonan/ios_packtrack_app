//
//  new.swift
//  packtrack
//
//  Created by ksymac on 2017/12/13.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit
import LBXScan

extension TrackNoAddViewController:MYScanDelegate{

    //扫描
    @IBAction func actionScan(_ sender: AnyObject) {
        
        
        //StyleDIY.zhiFuBaoStyle()
        //|| ScanVC?.style != StyleDIY.notSquare()
        if(ScanVC == nil ){
            ScanVC = DIYScanViewController.init()
        }
        ScanVC?.isOpenInterestRect = true
//        ScanVC?.style = StyleDIY.notSquare()
        ScanVC?.style = StyleDIY.zhiFuBaoStyle()
        ScanVC?.libraryType = SCANLIBRARYTYPE.SLT_ZXing
        ScanVC?.scanCodeType = SCANCODETYPE.SCT_BarCode93;
        ScanVC?.delegate = self//        ScanVC?.reStartDevice()
        var nabvc = UINavigationController.init(rootViewController: ScanVC!)
        //        ScanVC?.loadViewIfNeeded()
        self.present(nabvc, animated: true) {
           
        }
    }
    func setScanRet(_ strResult: LBXScanResult!) {
//        vc.imgScan = strResult.imgScanned;
//        vc.strScan = strResult.strScanned;
//        vc.strCodeType = strResult.strBarCodeType;

        let strScan = strResult.strScanned;
        let retStr = getParseStr(strScan!)
        self.textTrackNo.text = retStr
        ScanVC?.dismiss(animated: true) {
        
        }
    }
    
//    - (void)openScanVCWithStyle:(LBXScanViewStyle*)style
//    {
//    DIYScanViewController *vc = [DIYScanViewController new];
//    vc.style = style;
//    vc.isOpenInterestRect = YES;
//    vc.libraryType = [Global sharedManager].libraryType;
//    vc.scanCodeType = [Global sharedManager].scanCodeType;
//
//    [self.navigationController pushViewController:vc animated:YES];
//    }
}