//
//  SuperSaverCollectionCollectionViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 28/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class SuperSaverCollectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.borderWidth = 1.0
        backView.layer.borderColor = UIColor.black.cgColor
        // Initialization code
    }

}
