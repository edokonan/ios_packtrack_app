//
//  DIYScanViewController.m
//  LBXScanDemo
//
//  Created by lbxia on 2017/6/5.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import "DIYScanViewController.h"
#import "LBXAlertAction.h"
#import "ScanResultViewController.h"


@interface DIYScanViewController ()

@end

@implementation DIYScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // @"起動中";//"相机启动中"
    self.cameraInvokeMsg = @"起動中";
    //NSLocalizedString(@"MYSCAN_cameraInvokeMsg", comment: "");

    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
        target:self action:@selector(cancleMe:)];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = searchButton;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.isTranslucent = false;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(80/255.0) green:(180/255.0) blue:(220/255.0) alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    UINavigationBar.appearance().barStyle = UIBarStyle.default
    //    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    self.title = @"スキャナー";
}
    
    
#pragma mark -实现类继承该方法，作出对应处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (!array ||  array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        return;
    }
    
    //经测试，可以ZXing同时识别2个二维码，不能同时识别二维码和条形码
    //    for (LBXScanResult *result in array) {
    //
    //        NSLog(@"scanResult:%@",result.strScanned);
    //    }
    
    LBXScanResult *scanResult = array[0];
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        [self popAlertMsgWithScanResult:nil];
        return;
    }
    
    //TODO: 这里可以根据需要自行添加震动或播放声音提示相关代码
    //...
    //[self showNextVCWithScanResult:scanResult];
    
    //TODO: 设置返回调用的画面
    [self returnScanRet:scanResult];
    
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        strResult = @"失敗しました";//识别失败
    }
    __weak __typeof(self) weakSelf = self;
    //"扫码内容"
    //"知道了"
    [LBXAlertAction showAlertWithTitle:@"内容"
                    msg:strResult buttonsStatement:@[@"了解です"]
                    chooseBlock:^(NSInteger buttonIdx) {
        [weakSelf reStartDevice];
    }];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    ScanResultViewController *vc = [ScanResultViewController new];
    vc.imgScan = strResult.imgScanned;
    vc.strScan = strResult.strScanned;
    vc.strCodeType = strResult.strBarCodeType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)returnScanRet:(LBXScanResult*)strResult
{
    if ([self.delegate respondsToSelector:@selector(setScanRet:)]) {
        [self.delegate setScanRet:strResult];
    }
}
    
- (IBAction)cancleMe:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end


