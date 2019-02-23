//
//  MainCardCell.swift
//  packtrack
//
//  Created by ksymac on 2017/12/16.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit

protocol MainCardCellDelegate {
    func MainCardCellBtnClick1(_ bean : TrackMain?);
    func MainCardCellBtnClick2(_ bean : TrackMain?);
    func MainCardCellBtnClick3(_ bean : TrackMain?);
}


class MainCardCell: UITableViewCell {
    
    
    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var LeftView: UIView!
    @IBOutlet weak var RightView: UIView!
    
    @IBOutlet weak var companyImg: UIImageView!
    @IBOutlet weak var haveUpdateImg: UIImageView!
    @IBOutlet weak var isWorking: UIActivityIndicatorView!
    
    @IBOutlet weak var labeTitle: UILabel!
    @IBOutlet weak var labeComment: UILabel!
    @IBOutlet weak var labelTrackNo: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var labelUpdateDate: UILabel!
    @IBOutlet weak var labelInsertDate: UILabel!
    
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var MenuButton1: MKButton!
    @IBOutlet weak var MenuButton2: MKButton!
    @IBOutlet weak var MenuButton3: MKButton!
    var bean: TrackMain?
    var delegate:MainCardCellDelegate?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    //创建View
    class func CreateCellWithNib(table: UITableView, maindata : TrackMain, celldelegate: MainCardCellDelegate) -> MainCardCell{
        var cell = table.dequeueReusableCell(withIdentifier: "MainCardCell")
        if (cell == nil) {
            //print("load data")
            table.register(UINib(nibName: "MainCardCell", bundle: nil), forCellReuseIdentifier: "MainCardCell")
            cell = Bundle.main.loadNibNamed("MainCardCell", owner: self, options: nil)?.first as! MainCardCell
        }
        (cell as! MainCardCell).setView(maindata: maindata,celldelegate:  celldelegate)
        return cell as! MainCardCell
    }
    
    //返回高度
    class func getHeight(maindata : TrackMain)-> CGFloat{
        return 110;
    }
    
    //设置View
    func setView( maindata : TrackMain, celldelegate : MainCardCellDelegate){
        self.bean = maindata
        self.delegate = celldelegate
        
        self.ContainerView.layer.masksToBounds = true
        self.ContainerView.layer.cornerRadius = 7
        self.TopView.backgroundColor = UIColor.clear
        self.LeftView.backgroundColor = UIColor.clear
        self.RightView.backgroundColor = UIColor.clear
        self.BottomView.backgroundColor = GlobalHeadColor
        
        if(maindata.commentTitle.isEmpty){
//            self.labeComment.text = maindata.comment
            self.labeTitle.text = ""
            self.labeComment.text = maindata.comment
        }
        else{
            self.labeTitle.text = maindata.commentTitle
            self.labeComment.text = maindata.comment
        }
        
        self.labelTrackNo.text = maindata.trackNo
        
        if comfunc.isOnlyWeb(maindata.trackType) {
            self.labelDetail.text = "クリックすると詳細画面が表示されます"
            self.labelInsertDate.text = DateUtils.StrFormateWithYear(instr: maindata.insertDate)
//            self.labelInsertDate.text = comfunc.getTimeInterval(maindata.updateDate) + "追加"
            self.labelUpdateDate.text = ""
        }else{
            //var strTemp : NSMutableAttributedString
//            let strTemp = maindata.latestDate + maindata.latestStatus + maindata.latestDetail
//            if(strTemp.isEmpty){
//                let strtemp = maindata.typeName
//                self.labelDetail.text = strtemp.removeWhitespace()
//            }else{
//                let strtemp = maindata.latestDate + " " + maindata.latestStatus + " " + maindata.latestDetail
//                self.labelDetail.text = strtemp
//                let attrText = comfunc.getDeliveryOverStr(strtemp)
//                self.labelDetail.attributedText = attrText
//            }
            let strtemp = maindata.getNowStatus()
            let attrText = comfunc.getDeliveryOverStr(strtemp)
            self.labelDetail.attributedText = attrText
            
            
            self.labelUpdateDate.text = comfunc.getTimeInterval(maindata.updateDate) + "更新"
            // insertDate
            self.labelInsertDate.text = DateUtils.StrFormateWithYear(instr: maindata.insertDate)
        }
        
        // 表示する画像を設定する.
        self.companyImg?.image = comfunc.getCompanyImg(maindata.trackType)
        
        if(maindata.networking){
            self.isWorking.startAnimating()
            self.isWorking.isHidden = false
            self.RightView.isHidden = true
        }else{
            self.isWorking.stopAnimating()
            self.isWorking.isHidden = true
            self.RightView.isHidden = false
        }
        if(maindata.haveUpdate){
            self.haveUpdateImg.isHidden = false
            
            self.haveUpdateImg.backgroundColor = UIColor.gray
            self.haveUpdateImg.image = nil
            self.haveUpdateImg.layer.masksToBounds = true
            self.haveUpdateImg.layer.cornerRadius = 8
        }else{
            self.haveUpdateImg.isHidden = true
        }
    }
    
    @IBAction func clickBtn1(_ sender: Any) {
        self.delegate?.MainCardCellBtnClick1(self.bean)
    }
    @IBAction func clickBtn2(_ sender: Any) {
        self.delegate?.MainCardCellBtnClick2(self.bean)
    }
    @IBAction func clickBtn3(_ sender: Any) {
        self.delegate?.MainCardCellBtnClick3(self.bean)
    }
}
