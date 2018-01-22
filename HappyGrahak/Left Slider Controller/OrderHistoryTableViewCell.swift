//
//  OrderHistoryTableViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 16/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {

    @IBOutlet var orderIdLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var itemsOrderedList: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var pendingLabel: UILabel!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var dispatchLabel: UILabel!
    @IBOutlet var deliveredLabel: UILabel!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var oFDelivery: UILabel!
    @IBOutlet var progressImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.borderColor = UIColor.red.cgColor
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.height/2
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
