//
//  AddressTableViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 15/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var radioBtn: UIButton!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    
    let checkedImage = UIImage(named: "selected_icon")! as UIImage
    let uncheckedImage = UIImage(named: "not_selected_icon")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.radioBtn.setImage(checkedImage, for: UIControlState.normal)
            } else {
                self.radioBtn.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
