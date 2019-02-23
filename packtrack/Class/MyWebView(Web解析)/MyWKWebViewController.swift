//
//  MyWKWebViewController.swift
//  packtrack
//
//  Created by ksymac on 2018/8/27.
//  Copyright © 2018年 ZHUKUI. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

protocol MyWKWebViewControllerDelegate {
    func ShowView_DataView();
    func ShowView_WebView();
}

class MyWKWebViewController: UIViewController{
    
    @IBOutlet weak var MainScrollView: UIScrollView!
    let amazon_webview : AmazonOrderWebView = AmazonOrderWebView.instanceFromNib()
    override func viewDidLoad() {
        super.viewDidLoad()
        amazon_webview.delegate = self
        setupScrollViewUI()
    }
    func setupScrollViewUI() {
        //设置滑动视图
        MainScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width*2, height: MainScrollView.bounds.height)
        MainScrollView.isPagingEnabled = true
        MainScrollView.showsHorizontalScrollIndicator=false
        MainScrollView.showsVerticalScrollIndicator=false
        MainScrollView.bounces=false
        MainScrollView.isScrollEnabled=false
        MainScrollView.backgroundColor = UIColor.gray
//        MainScrollView.isUserInteractionEnabled = true
        resizeBaseScrollViewUI()
        //插入导航栏中心控制视图
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action:  #selector(closeMe))
        
//        let runkeeperSwitch = ComUI.SwitchView("web", rightTitle: "table")
//        runkeeperSwitch.addTarget(self, action: #selector(self.switchValueDidChange(_:)),
//                                  for: .valueChanged)
//        navigationItem.titleView = runkeeperSwitch
        
        navigationItem.title = "Amazon"
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        MainScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width*2, height: MainScrollView.bounds.height)
        resizeBaseScrollViewUI()
    }
    func resizeBaseScrollViewUI() {
        amazon_webview.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: MainScrollView.bounds.height)
        amazon_webview.backgroundColor = UIColor.red
//        amazon_webview.isUserInteractionEnabled = true
//        amazon_webview.autoresizesSubviews  = true
        MainScrollView.addSubview(amazon_webview)
        
        amazon_webview.tableview.frame=CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: MainScrollView.bounds.height)
        MainScrollView.addSubview(amazon_webview.tableview)
//        webView.frame = TView.bounds
//        webbaseview.layoutSubviews()
//        amazon_webview.layoutSubviews()
//        amazon_webview.setNeedsLayout()
//        amazon_webview.layoutIfNeeded()
    }
    // MARK: 切换视图
    func switchValueDidChange(_ sender: DGRunkeeperSwitch!) {
        if(sender.selectedIndex==0){
            MainScrollView.contentOffset = CGPoint(x: 0, y: 0)
        }else{
            MainScrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        }
    }
    
    func closeMe() {
        self.dismiss(animated: true) {
        }
    }
}

extension MyWKWebViewController:MyWKWebViewControllerDelegate{
    func ShowView_DataView() {
        MainScrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.width, y: 0)
    }
    
    func ShowView_WebView() {
        MainScrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
}



