//
//  StaticBannerTableViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 28/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class StaticBannerTableViewCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
