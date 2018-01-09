//
//  ItemListTableViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 16/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class ItemListTableViewCell: UITableViewCell {

    @IBOutlet var produtImage: UIImageView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
