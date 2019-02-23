//
//  TrackDetailViewCell.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/12.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import UIKit

class TrackDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timelineLabel: UILabel!
    @IBOutlet weak var timelineImg: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    
    @IBOutlet weak var BackGroundUIView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUI(_ trackdetail : TrackDetail, first:Bool = false){
        self.contentView.backgroundColor = GlobalBackgroundColor
        self.BackGroundUIView.layer.masksToBounds = true
        self.BackGroundUIView.layer.cornerRadius = 7
        self.BackGroundUIView.layer.borderColor = UIColor.lightGray.cgColor
        self.BackGroundUIView.layer.borderWidth = 0.5
        
        if first{
            self.timelineLabel.backgroundColor = UIColor.orange
            self.labelDate.textColor = UIColor.orange
            self.labelTitle.textColor = UIColor.orange
            self.labelSubTitle.textColor = UIColor.orange
//            self.timelineImg.image = UIImage.init(named: "arrow_left.png")
            self.timelineImg.backgroundColor = UIColor.orange
            self.timelineImg.image = nil
            self.timelineImg.layer.masksToBounds = true
            self.timelineImg.layer.cornerRadius = 7
        }else{
            self.timelineLabel.backgroundColor = UIColor.gray
            self.labelDate.textColor = UIColor.gray
            self.labelTitle.textColor = UIColor.gray
            self.labelSubTitle.textColor = UIColor.gray
//            self.timelineImg.image = UIImage.init(named: "arrow_up.png")
            
            self.timelineImg.backgroundColor = UIColor.gray
            self.timelineImg.image = nil
            self.timelineImg.layer.masksToBounds = true
            self.timelineImg.layer.cornerRadius = 7
        }
        
        self.labelDate.text = trackdetail.date
        self.labelTitle.text = trackdetail.status
        self.labelSubTitle.text = trackdetail.detail
    }
    
    //返回高度
    class func getHeight()-> CGFloat{
        return 90;
    }
    
}
