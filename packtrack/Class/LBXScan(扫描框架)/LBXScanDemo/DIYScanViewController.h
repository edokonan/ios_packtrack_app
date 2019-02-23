//
//  DIYScanViewController.h
//  LBXScanDemo
//
//  Created by lbxia on 2017/6/5.
//  Copyright © 2017年 lbx. All rights reserved.
//


#import "LBXScan/LBXScanViewController.h"
#import "PrefixHeader.pch"



@protocol MYScanDelegate <NSObject>

@optional
- (void)setScanRet: (LBXScanResult*)strResult;
@end


@interface DIYScanViewController : LBXScanViewController

/**
 delegateオブジェクト
*/
@property (weak, nonatomic) id <MYScanDelegate> delegate;
@end
