//
//  MyCartTableViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 05/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class MyCartTableViewCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var qtyLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var myView: UIView!
    @IBOutlet var minusBtn: UIButton!
    @IBOutlet var plusBtn: UIButton!
    @IBOutlet var removeBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        myView.layer.cornerRadius = 5.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
