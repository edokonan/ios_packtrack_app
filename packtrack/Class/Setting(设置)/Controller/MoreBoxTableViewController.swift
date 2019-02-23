//
//  MoreBoxTableViewController.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/10/03.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import UIKit
import MessageUI


class MoreBoxTableViewController: UITableViewController , MFMailComposeViewControllerDelegate{
    
    //@IBOutlet weak var tableView: UITableView!
    var SectionTexts = ["固定ボックス","追加ボックス"]
    //var section0_texts = ["追跡中","追跡完了","全て","ゴミ箱"];
    //var section1_texts = ["カテゴリ設定"];
//    let trackMainModel = TrackMainModel.shared//model
//    let trackStatusModel = TrackStatusModel.shared//model
    var section0list : Array<TrackStatus> = []
    var section1list : Array<TrackStatus> = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.tableView.layer.borderWidth = 1;
        self.tableView.allowsSelection = false;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //    tableView.delegate = self
        //    tableView.dataSource = self
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 80.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().barStyle = UIBarStyle.default
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        //UITabBar.appearance().barTintColor = UIColor(red: 80.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: "addBox:")
        self.navigationItem.rightBarButtonItem = addButton
        
//        section0list = trackStatusModel.getSection1List()
//        section1list = trackStatusModel.getSection2List()
        section0list = IceCreamMng.shared.getSection1List()
        section1list = IceCreamMng.shared.getSection2List()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SectionTexts.count;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return section0list.count;
        }
        else{
            return section1list.count;
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SectionTexts[section];
    }
    //row title
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "moreTableViewCell")
        
        if (indexPath.section == 0){
            cell.textLabel?.text = section0list[indexPath.row].statusname + " (" + String(section0list[indexPath.row].count) + ")";//件
        }else{
            cell.textLabel?.text = section1list[indexPath.row].statusname + " (" + String(section1list[indexPath.row].count) + ")";//件
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0){
            onClickStartMailerBtn()}
        else{
            popCategorySetting()
        }
    }
    func popCategorySetting(){
        
    }
    
    func onClickStartMailerBtn() {
       //self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addBox(_ sender: AnyObject) {
        #if FREE
            if section1list.count>0 {
                SCLAlertView().showError("ボックス追加制限", subTitle:"無料版の整理ボックスは最大一つを追加ですます。\n正式版またはオプションサービスをご購入ください", closeButtonTitle:"OK")
                return;
            }
        #else

        #endif
        
//        // Add a text field
//        let alert = SCLAlertView()
//        let txt = alert.addTextField("ご入力ください")
//        alert.addButton("追加") {
//            self.insertDb(txt.text!)
//        }
//        alert.showEdit("ボックス追加", subTitle: "ボックス名をご入力ください", closeButtonTitle:"キャンセル")
//
        showaddbox(flg: 0,indexPath: nil)
    }
    func editTable(_ indexPath: IndexPath) {
        //        // Add a text field
        //        let alert = SCLAlertView()
        //        let txt = alert.addTextField("ご入力ください")
        //        txt.text = self.section1list[indexPath.row].statusname
        //        alert.addButton("修正") {
        //            self.updateTable(indexPath,boxname : txt.text!)
        //        }
        //        alert.showEdit("ボックス名を変更", subTitle: "ボックス名をご入力ください")
        showaddbox(flg: 1,indexPath: indexPath)
    }
    func showaddbox(flg:Int,indexPath: IndexPath?){
        var tilte = "ボックス追加"
        if(flg==1){
            tilte = "ボックス名を変更"
        }
        let alert:UIAlertController = UIAlertController(title:tilte,
                                                            message: "ボックス名をご入力ください",
                                                            preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
                                                           style: UIAlertActionStyle.cancel,
                                                           handler:{
                                                            (action:UIAlertAction!) -> Void in
            })
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK",
                    style: UIAlertActionStyle.default,handler:{
                      (action:UIAlertAction!) -> Void in
                      let textFields:Array<UITextField>? =  alert.textFields as Array<UITextField>?
                      if textFields != nil {
                            guard let id = textFields?[0].text else{
                               return
                     }
                     if(flg==0){
                        self.insertDb(id)
                     }else{
                        self.updateTable(indexPath!,boxname : id)
                    }
                  }
            })
        alert.addTextField(configurationHandler: {(text:UITextField!) -> Void in
                text.placeholder = "ご入力してください"
                let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
                label.text = "名称"
                text.leftView = label
                text.leftViewMode = UITextFieldViewMode.always
            if(flg==1){
                text.text = self.section1list[indexPath!.row].statusname
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    //添加到数据库
    func insertDb(_ boxname :String){
        if(boxname.isEmpty){
            return
        }else{
            let trackstatus : TrackStatus = TrackStatus()
            //trackmain.status = trackStatusModel.getMaxNo()+1
            //trackmain.indexno = trackmain.status
            trackstatus.status = IceCreamMng.shared.getNextStatusBoxId()
            trackstatus.statusname = boxname
            trackstatus.indexno = self.section0list.count + 1
            //trackStatusModel.add(trackmain)
            //IceCreamMng.shared.addStatus(trackstatus)
            IceCreamMng.shared.addOrupdStatus(trackstatus)
            
            self.refreshView()
        }
    }
    func updateTable(_ indexPath : IndexPath,boxname :String){
        if(boxname.isEmpty){
            return
        }else{
            let trackstatus = self.section1list[indexPath.row]
            trackstatus.statusname = boxname
            //trackStatusModel.updateByID(trackstatus)
            IceCreamMng.shared.updateStatusBoxByID(trackstatus)
            self.refreshView()
        }
    }
    //削除
    func delTable(_ indexPath: IndexPath ){
        //let id = self.section1list[indexPath.row].rowID
        //trackStatusModel.delete(id)
        let statusid = self.section1list[indexPath.row].status
        IceCreamMng.shared.deleteByStatusId(statusid)
        self.refreshView()
    }

    func refreshView(){
        //section0list = trackStatusModel.getSection1List()
        //section1list = trackStatusModel.getSection2List()
        section0list = IceCreamMng.shared.getSection1List()
        section1list = IceCreamMng.shared.getSection2List()
        self.tableView.reloadData()
    }
    
    
    // 支持单元格编辑功能
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.section>0){
            return true
        }else{
           return false
        }
    
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.delTable(indexPath)
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if(indexPath.section>0){
            let DelAction = UITableViewRowAction(style: .default, title: "削除") {
                (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
                tableView.isEditing = false
                self.delTable(indexPath)
            }
            let EditAction = UITableViewRowAction(style: .default, title: "編集") {
                (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
                tableView.isEditing = false
                self.editTable(indexPath)
            }
            EditAction.backgroundColor = UIColor.blue
            
            return [DelAction,EditAction]
        }else{
            return nil
        }
    }
}
