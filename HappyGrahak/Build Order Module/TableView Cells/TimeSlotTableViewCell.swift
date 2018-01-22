//
//  TimeSlotTableViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 12/01/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class TimeSlotTableViewCell: UITableViewCell {

    @IBOutlet var slotLabel: UILabel!
    @IBOutlet var slotBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
