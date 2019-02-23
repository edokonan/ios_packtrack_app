//
//  TrackDetailViewTitleCell.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/12.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import UIKit

class TrackDetailViewTitleCell: UITableViewCell {
    
    @IBOutlet weak var companyImg: UIImageView!
    @IBOutlet weak var isWorking: UIActivityIndicatorView!
    @IBOutlet weak var labelTrackNo: UILabel!
    @IBOutlet weak var labelTrackName: UILabel!
    @IBOutlet weak var labelComment: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
