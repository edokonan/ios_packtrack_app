//
//  TrackDetailViewTitleCell.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/12.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import UIKit

class TrackDetailTableViewTitleCell: UITableViewCell {
    
    @IBOutlet weak var companyImg: UIImageView!
    @IBOutlet weak var isWorking: UIActivityIndicatorView!
    @IBOutlet weak var labelTrackNo: UILabel!
    @IBOutlet weak var labelTrackName: UILabel!
    @IBOutlet weak var labelComment: UILabel!
    @IBOutlet weak var BackGroundUIView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUI(_ trackMain : TrackMain, isWorking:Bool = false){
        self.contentView.backgroundColor = GlobalBackgroundColor
        self.backgroundColor = GlobalBackgroundColor
//        self.backgroundView?.backgroundColor = GlobalBackgroundColor
        self.BackGroundUIView.layer.masksToBounds = true
        self.BackGroundUIView.layer.cornerRadius = 7
        self.BackGroundUIView.backgroundColor = UIColor.white
        self.BackGroundUIView.layer.borderColor = UIColor.lightGray.cgColor
        self.BackGroundUIView.layer.borderWidth = 0.5
        
        self.labelTrackNo.text = trackMain.trackNo
        let str = trackMain.typeName.removeWhitespace()
        self.labelTrackName.text = str
        if(trackMain.commentTitle.isEmpty){
            self.labelComment.text = trackMain.comment}
        else{
            self.labelComment.text = trackMain.commentTitle + " " + trackMain.comment
        }
        self.companyImg.image = ComFunc.shared.getCompanyImg(trackMain.trackType)
        if( isWorking){
            self.isWorking.startAnimating()
            self.isWorking.isHidden = false
        }else{
            self.isWorking.stopAnimating()
            self.isWorking.isHidden = true
        }

        self.labelComment.textColor = UIColor.darkGray
        self.labelTrackNo.textColor = UIColor.darkGray
        self.labelTrackName.textColor = UIColor.darkGray
    }
    
    //返回高度
    class func getHeight(data : TrackDetail)-> CGFloat{
        return 90;
    }
    
}
