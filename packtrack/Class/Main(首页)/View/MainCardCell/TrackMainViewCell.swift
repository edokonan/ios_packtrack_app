//
//  TrackMainTableViewCell.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/12.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import UIKit

class TrackMainViewCell: UITableViewCell {
    
    @IBOutlet weak var companyImg: UIImageView!
    @IBOutlet weak var haveUpdateImg: UIImageView!
    @IBOutlet weak var isWorking: UIActivityIndicatorView!
    
    @IBOutlet weak var labeComment: UILabel!
    @IBOutlet weak var labelTrackNo: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var labelUpdateDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
