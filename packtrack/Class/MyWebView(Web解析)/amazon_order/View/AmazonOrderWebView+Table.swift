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

extension AmazonOrderWebView:UITableViewDataSource,UITableViewDelegate {

    func setTableUI(){
        self.tableview.separatorStyle = .none
        tableview.backgroundColor = GlobalBackgroundColor
        tableview.delegate = self
        tableview.dataSource = self
        
        let nib = UINib(nibName: titelcellId, bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableview.register(nib, forCellReuseIdentifier: titelcellId)
        
        tableview.estimatedRowHeight = 120;
        tableview.rowHeight=UITableViewAutomaticDimension;
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action:  #selector(closeMe))
    }
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{return amazonOrderParser.model.order0_list.count ?? 0 }
        if section == 1{return amazonOrderParser.model.order1_list.count ?? 0 }
        if section == 2{return amazonOrderParser.model.order2_list.count ?? 0 }
        if section == 3{return amazonOrderParser.model.order3_list.count ?? 0 }
        return 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{return "発送済み" }
        if section == 1{return "未発送" }
        if section == 2{return "配達完了"}
        if section == 3{return "Kindle電子書籍等" }
        return ""
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: titelcellId, for: indexPath) as! AmazonOrderCell
        if indexPath.section == 0{
            cell.setUI(amazonOrderParser.model.order0_list[indexPath.row])
        }else if indexPath.section == 1{
            cell.setUI(amazonOrderParser.model.order1_list[indexPath.row])
        }else if indexPath.section == 2{
            cell.setUI(amazonOrderParser.model.order2_list[indexPath.row])
        }else{
            cell.setUI(amazonOrderParser.model.order3_list[indexPath.row])
        }
        cell.selectionStyle = .none
        return cell
    }
}




