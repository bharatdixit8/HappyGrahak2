//
//  CustomLabel.swift
//  HappyGrahak
//
//  Created by IOS on 27/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    func labelColor(text: String!, range: NSRange!)->NSMutableAttributedString{
        var myMutableString: NSMutableAttributedString!
        myMutableString = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font:UIFont(name: "Lato-Bold", size: 15.0)!])
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.init(red: 255.0/255.0, green: 150.0/255.0, blue: 0.0/255.0, alpha: 1), range: range)
        // set label Attribute
        return myMutableString
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
