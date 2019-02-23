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



class CompanyViewController: BaseViewController {
    fileprivate var headView: CompanyHeadView!
    fileprivate var tableView: LFBTableView!
    fileprivate var headViewHeight: CGFloat = 100
    fileprivate var tableHeadView: MineTabeHeadView!
    fileprivate var couponNum: Int = 0
    
    // MARK: Flag
    
    var tracktype:TrackComType?
    convenience init(tracktype:TrackComType) {
        self.init()
        self.tracktype = tracktype
    }
    
    
    //MARK: - 设置行数据
    fileprivate lazy var mines: [MineCellModel] = {
        let mines = MineCellModel.loadMineCellModels()
        return mines
        }()
    var MySectionS = [MineSectionType]()
    
    
    // MARK:- view life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = true
        buildUI()
        //根据用户的情况需要再次设置View
        setupSections()
    }
    
    // MARK: Build UI
    fileprivate func buildUI() {
        weak var tmpSelf = self
        //添加会员头部
        headView =  CompanyHeadView.init(frame: CGRect(x: 0, y: 0 , width: ScreenWidth, height: headViewHeight),tracktype:self.tracktype!)
        view.addSubview(headView)
        //添加表格头部
        buildTableHeadView()
    }
    override func viewWillLayoutSubviews() {
        self.tableView.frame = CGRect(x: 0, y: headViewHeight , width: ScreenWidth,
               height: self.view.height - headViewHeight)
        super.viewWillLayoutSubviews()
    }
    
    // MARK: buildTableView
    fileprivate func buildTableHeadView() {
        tableView = LFBTableView(frame: CGRect(x: 0, y: headViewHeight , width: ScreenWidth,
                                               height: self.view.height - headViewHeight), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 46
        view.addSubview(tableView)
        weak var tmpSelf = self
        tableHeadView = MineTabeHeadView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 70))
        // 点击headView回调
        tableHeadView.mineHeadViewClick = { (type) -> () in
            switch type {
            case .order:
                //生成备份文件
                break
            case .coupon:
                //生成备份文件
                break
            case .message:
                //生成备份文件
                break
            }
        }
//        tableView.tableHeaderView = tableHeadView
    }
}

// MARK:- UITableViewDataSource UITableViewDelegate
extension CompanyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MineCell.cellFor(tableView)
        cell.mineModel = MySectionS[indexPath.section].rows[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return MySectionS.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MySectionS[section].rows.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let block = MySectionS[indexPath.section].rows[indexPath.row].complete {
            block()
        }
    }
}
