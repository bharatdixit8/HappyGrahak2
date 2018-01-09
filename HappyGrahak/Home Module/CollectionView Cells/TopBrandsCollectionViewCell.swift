//
//  TopBrandsCollectionViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 28/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class TopBrandsCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.black.cgColor
        // Initialization code
    }

}
