//
//  AmazonOrderCell.swift
//  packtrack
//
//  Created by ksymac on 2018/8/26.
//  Copyright © 2018年 ZHUKUI. All rights reserved.
//

import UIKit

class AmazonOrderCell: UITableViewCell {
    
    @IBOutlet weak var workingIcon: UIActivityIndicatorView!
    
    @IBOutlet weak var asynIcon: UIImageView!
    
    @IBOutlet weak var companyImg: UIImageView!
    
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
    
    func setUI(_ detail : Order_Amazon_Cls){
        self.contentView.backgroundColor = GlobalBackgroundColor
        self.BackGroundUIView.layer.masksToBounds = true
        self.BackGroundUIView.layer.cornerRadius = 7
        self.BackGroundUIView.layer.borderColor = UIColor.lightGray.cgColor
        self.BackGroundUIView.layer.borderWidth = 0.5

        if detail.isNeedGetShipInfo{
            workingIcon.startAnimating()
            workingIcon.isHidden = false
        }else{
            workingIcon.stopAnimating()
            workingIcon.isHidden = true
        }
       self.asynIcon.isHidden = !detail.isAddLocalDB
        
        if detail.titles.count > 1{
            self.labelComment.text =
                String.init(format: "%@ 等(%d件)", detail.titles[0], detail.titles.count )
        }else{
            self.labelComment.text = detail.titles[0]
        }

        self.labelTrackNo.text =
            String.init(format: "%@ %@ %@", detail.tracktypename ?? "", detail.trackno ?? "" , detail.trackstatus ?? "")
        self.labelTrackName.text = detail.order_status
        
        if let url = URL.init(string: detail.imglink){
            self.companyImg.setImageWith(url)
        }
    }
    
}
