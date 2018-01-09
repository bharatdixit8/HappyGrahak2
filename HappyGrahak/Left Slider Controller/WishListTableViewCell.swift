//
//  WishListTableViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 29/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class WishListTableViewCell: UITableViewCell {

    @IBOutlet var productImg: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productQuantity: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var deleteBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
