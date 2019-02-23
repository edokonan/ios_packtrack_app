//
//  MainCardCell.swift
//  packtrack
//
//  Created by ksymac on 2017/12/16.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit

class MainCardCdCell: UITableViewCell {
    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak var ContainerViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //创建View
    class func CreateCellWithNib(table: UITableView) -> MainCardCdCell{
        var cell = table.dequeueReusableCell(withIdentifier: "MainCardCdCell")
        if (cell == nil) {
            table.register(UINib(nibName: "MainCardCdCell", bundle: nil), forCellReuseIdentifier: "MainCardCdCell")
            cell = Bundle.main.loadNibNamed("MainCardCdCell", owner: self, options: nil)?.first as! MainCardCdCell
        }
//        (cell as! MainCardCdCell).setView(maindata: maindata)
        return cell as! MainCardCdCell
    }
    
//    //返回高度
//    class func getHeight(maindata : TrackMain)-> CGFloat{
//        return 110;
//    }
    
    //设置View
    func setView( adview: UIView){

    }
    
    func addADView(adview: UIView){
        self.ContainerView.layer.masksToBounds = true
        self.ContainerView.layer.cornerRadius = 7
        self.ContainerViewHeight.constant = adview.height
        self.ContainerView.addSubview(adview)
    }
}
