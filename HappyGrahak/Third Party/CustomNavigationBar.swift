//
//  CustomNavigationBar.swift
//  HappyGrahak
//
//  Created by IOS on 17/01/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class CustomNavigationBar: NSObject {
    var myView: UIView?
    var button2: UIImageView?
    var button5: UIImageView?
    var button6: UILabel?
    var button3: UILabel?
    var button4: UIButton?
    var button1: UIButton?
    var button7: UIBarButtonItem?
    var button8: UIBarButtonItem?
    var toolbar: UIToolbar = UIToolbar()
    
    func addCustomNavigationBar(width: CGFloat) -> UIView {
        myView  = UIView.init(frame: CGRect(x: 0, y: 20, width: width, height: 64))
        myView?.backgroundColor = UIColor.white
        
        button1 = UIButton.init(type: .custom)
        button1 = UIButton.init(frame: CGRect(x: 0, y: (myView?.frame.size.height)!/2-20, width: 40, height: 40))
        button1?.setImage(UIImage(named: "left_menu_icon"), for: .normal)
        button7 = UIBarButtonItem.init(image: UIImage(named: "left_menu_icon"), style: .plain, target: self, action: #selector(JASidePanelController.toggleLeftPanel(_:)))
        button7?.tintColor = UIColor.black
        button8 = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        self.toolbar.setItems([button7!, button8!], animated: true)
        print(button7!)
        myView?.addSubview(self.toolbar)
        
        let img = UIImage(named: "home_logo_icon")
        button2 = UIImageView.init(image: UIImage.init(named: "home_logo_icon"))
        button2?.frame = CGRect.init(x: 50, y: (myView?.frame.size.height)!/2-(img?.size.height)!/2, width: (img?.size.width)!, height: (img?.size.height)!)
        myView?.addSubview(button2!)
        
        button4 = UIButton.init(type: .custom)
        let img2 = UIImage(named: "cart_icon")
        button4?.setImage(UIImage.init(named: "cart_icon"), for: UIControlState.normal)
        button4?.frame = CGRect.init(x: (myView?.frame.size.width)!-60, y: (myView?.frame.size.height)!/2-(img2?.size.height)!/2, width: 25, height: 25)
        button4?.tag = 2001
        myView?.addSubview(button4!)
        //button4.addTarget(self, action:#selector(self.moveToCart), for:.touchUpInside)
        
        button3 = UILabel.init(frame: CGRect(x: (myView?.frame.size.width)!-50, y: (myView?.frame.size.height)!/2-(img2?.size.height)!/2-5, width: 13, height: 13))
        button3?.backgroundColor = UIColor.red
        button3?.layer.cornerRadius = (button3?.frame.size.height)!/2
        button3?.clipsToBounds = true
        button3?.textColor = UIColor.white
        button3?.font = UIFont.boldSystemFont(ofSize: 8.0)
        button3?.tag = 1001
        button3?.textAlignment = .center
        myView?.addSubview(button3!)
        
        let img1 = UIImage(named: "notification_icon")
        button5 = UIImageView.init(image: UIImage.init(named: "notification_icon"))
        button5?.frame = CGRect.init(x: (myView?.frame.size.width)!-100, y: (myView?.frame.size.height)!/2-(img1?.size.height)!/2, width: (img1?.size.width)!, height: (img1?.size.height)!)
        myView?.addSubview(button5!)
        
        button6 = UILabel.init(frame: CGRect(x: (myView?.frame.size.width)!-95, y: (myView?.frame.size.height)!/2-(img1?.size.height)!/2-5, width: 13, height: 13))
        button6?.backgroundColor = UIColor.red
        button6?.layer.cornerRadius = (button6?.frame.size.height)!/2
        button6?.clipsToBounds = true
        button6?.textColor = UIColor.white
        button6?.font = UIFont.boldSystemFont(ofSize: 8.0)
        button6?.tag = 101
        button6?.textAlignment = .center
        button6?.text = "0"
        myView?.addSubview(button6!)
        
        return myView!
    }
    
    func addCustomNavigationBar1(width: CGFloat, button: UIButton, titleLabel: UILabel) -> UIView {
        myView  = UIView.init(frame: CGRect(x: 0, y: 20, width: width, height: 64))
        myView?.backgroundColor = UIColor.white
        myView?.addSubview(button)
        myView?.addSubview(titleLabel)
        
        button4 = UIButton.init(type: .custom)
        let img2 = UIImage(named: "cart_icon")
        button4?.setImage(UIImage.init(named: "cart_icon"), for: UIControlState.normal)
        button4?.frame = CGRect.init(x: (myView?.frame.size.width)!-60, y: (myView?.frame.size.height)!/2-(img2?.size.height)!/2, width: 25, height: 25)
        button4?.tag = 2001
        myView?.addSubview(button4!)
        //button4.addTarget(self, action:#selector(self.moveToCart), for:.touchUpInside)
        
        button3 = UILabel.init(frame: CGRect(x: (myView?.frame.size.width)!-50, y: (myView?.frame.size.height)!/2-(img2?.size.height)!/2-5, width: 13, height: 13))
        button3?.backgroundColor = UIColor.red
        button3?.layer.cornerRadius = (button3?.frame.size.height)!/2
        button3?.clipsToBounds = true
        button3?.textColor = UIColor.white
        button3?.font = UIFont.boldSystemFont(ofSize: 8.0)
        button3?.tag = 1001
        button3?.textAlignment = .center
        myView?.addSubview(button3!)
        
        let img1 = UIImage(named: "notification_icon")
        button5 = UIImageView.init(image: UIImage.init(named: "notification_icon"))
        button5?.frame = CGRect.init(x: (myView?.frame.size.width)!-100, y: (myView?.frame.size.height)!/2-(img1?.size.height)!/2, width: (img1?.size.width)!, height: (img1?.size.height)!)
        myView?.addSubview(button5!)
        
        button6 = UILabel.init(frame: CGRect(x: (myView?.frame.size.width)!-95, y: (myView?.frame.size.height)!/2-(img1?.size.height)!/2-5, width: 13, height: 13))
        button6?.backgroundColor = UIColor.red
        button6?.layer.cornerRadius = (button6?.frame.size.height)!/2
        button6?.clipsToBounds = true
        button6?.textColor = UIColor.white
        button6?.font = UIFont.boldSystemFont(ofSize: 8.0)
        button6?.tag = 101
        button6?.textAlignment = .center
        button6?.text = "0"
        myView?.addSubview(button6!)
        
        return myView!
    }
}
