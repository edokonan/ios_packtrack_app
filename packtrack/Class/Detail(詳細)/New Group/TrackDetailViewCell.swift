//
//  TrackDetailViewCell.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/12.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import UIKit

class TrackDetailViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var timelineLabel: UILabel!
    @IBOutlet weak var timelineImg: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
