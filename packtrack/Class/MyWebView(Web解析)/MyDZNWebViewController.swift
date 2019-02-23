//
//  MyBaseWebview.swift
//  packtrack
//
//  Created by ksymac on 2018/8/24.
//  Copyright © 2018年 ZHUKUI. All rights reserved.
//

import Foundation
import TOWebViewController
import Kanna
import SVProgressHUD
import DZNWebViewController

class MyDZNWebViewController: DZNWebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action:  #selector(closeMe))
        self.hideBarsWithGestures = false
        self.hidesBottomBarWhenPushed = true
    }
    override func loadURL(_ URL: URL!) {
        self.webView.load(URLRequest.init(url: URL))
    }
    func closeMe() {
        self.dismiss(animated: true) {
        }
    }
}

