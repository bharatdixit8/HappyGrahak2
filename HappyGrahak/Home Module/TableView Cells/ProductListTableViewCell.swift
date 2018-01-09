//
//  ProductListTableViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 01/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class ProductListTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var offerLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imgIconView: UIImageView!
    @IBOutlet var mrpLabel: UILabel!
    @IBOutlet var cartBtn: UIButton!
    @IBOutlet var sellingPriceLabel: UILabel!
    var myView: UIView?
    var backView: UIView?
    @IBOutlet var viewDetailsBtn: UIButton!
    @IBOutlet var weightLabel: UILabel!
    var weightArray: NSArray?
    var mrpArray: NSArray?
    var spArray: NSArray?
    var offerArray: NSArray?
    var invIdArray: NSArray?
    var tableView: UITableView?
    
    @IBOutlet var wishListBtn: UIButton!
    @IBOutlet var dropDownBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        cartBtn.layer.cornerRadius = cartBtn.frame.size.height/2
        offerLabel.layer.cornerRadius = offerLabel.frame.size.height/2
        offerLabel.layer.borderWidth = 1.0
        offerLabel.layer.borderColor = UIColor.init(red: 92.0/255.0, green: 202.0/255.0, blue: 19.0/255.0, alpha: 1.0).cgColor
        dropDownBtn.layer.borderWidth = 1.0
        dropDownBtn.layer.borderColor = UIColor.lightGray.cgColor
        //whListView.frame.size.height = CGFloat((weightArray?.count)!*20)
        // Initialization code
    }
    
//    func addTableView() -> Void {
//        print(self.tag)
//        if weightArray?.count == nil {
//            myView = UIView.init(frame: CGRect(x: dropBtn.frame.origin.x, y: dropBtn.frame.origin.y+64.0, width: dropBtn.frame.size.width, height: 30.0))
//        } else {
//            myView = UIView.init(frame: CGRect(x: dropBtn.frame.origin.x, y: CGFloat((self.tag)*Int(dropBtn.frame.origin.y+64.0)), width: dropBtn.frame.size.width, height: CGFloat((weightArray?.count)!*30)))
//        }
//        myView?.layer.shadowOffset = CGSize(width: 0, height: 0)
//        myView?.layer.shadowColor = UIColor.black.cgColor
//        myView?.backgroundColor = UIColor.white
//        myView?.layer.shadowRadius = 4
//        myView?.layer.shadowOpacity = 0.25
//        myView?.layer.masksToBounds = false;
//        myView?.clipsToBounds = false;
//        let window = UIApplication.shared.keyWindow!
//        window.addSubview(myView!)
//        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: (myView?.frame.size.width)!, height: (myView?.frame.size.height)!))
//        tableView?.delegate = self
//        tableView?.dataSource = self
//        myView?.addSubview(tableView!)
//        myView?.isHidden = true
//    }

//    @IBAction func dropDownClicked(_ sender: Any) {
//        myView?.isHidden = true
//        self.addTableView()
//        myView?.isHidden = false
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        dropDownBtn.setTitle(" \(weightArray![0])", for: .normal)
        dropDownBtn.titleLabel?.textColor = UIColor.black
        dropDownBtn.tag = invIdArray![0] as! Int
        dropDownBtn?.titleLabel?.font =  UIFont(name:"Times New Roman", size: 14)
        dropDownBtn.contentHorizontalAlignment = .left
        dropDownBtn.addTarget(self, action: #selector(self.customPopup), for: .touchUpInside)
        print(dropDownBtn.titleLabel?.text)
        // Configure the view for the selected state
    }
    
    @objc func customPopup() -> Void {
        let window = UIApplication.shared.keyWindow!
        print(weightArray?.count)
        if weightArray?.count != nil {
            backView = UIView.init(frame: CGRect(x: 0, y: 0, width: window.frame.size.width, height: window.frame.size.height))
            myView = UIView.init(frame: CGRect(x: (backView?.frame.size.width)!/2-150.0, y: (backView?.frame.size.height)!/2-CGFloat((150+(weightArray?.count)!*30)/2), width: 300.0, height: CGFloat(150+(weightArray?.count)!*30)))
        }
        myView?.layer.shadowOffset = CGSize(width: 0, height: 0)
        myView?.layer.shadowColor = UIColor.black.cgColor
        backView?.backgroundColor = UIColor.clear
        myView?.backgroundColor = UIColor.white
        myView?.layer.shadowRadius = 4
        myView?.layer.shadowOpacity = 0.25
        myView?.layer.masksToBounds = false;
        myView?.clipsToBounds = false;
        
        let imgView: UIImageView = UIImageView.init(frame: CGRect(x: (myView?.frame.size.width)!/2-40.0, y: 20.0, width: 80.0, height: 80.0))
        imgView.image = imgIconView.image
        
        let namesLabel: UILabel = UILabel.init(frame: CGRect(x: 0.0, y: 100.0, width: (myView?.frame.size.width)!, height: 30.0))
        namesLabel.text = nameLabel!.text
        namesLabel.textAlignment = .center
        myView?.addSubview(imgView)
        myView?.addSubview(namesLabel)
        let weightTable = UITableView.init(frame: CGRect(x: 0, y: 150, width: (myView?.frame.size.width)!, height: (myView?.frame.size.height)!-150.0))
        weightTable.delegate = self
        weightTable.dataSource = self
        myView?.addSubview(weightTable)
        backView?.addSubview(myView!)
        window.addSubview(backView!)
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//
//        backView?.addGestureRecognizer(tap)
        //myView?.isHidden = true
    }
    
//    @objc func dismissKeyboard() {
//        //backView?.isHidden = true
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if weightArray?.count != nil {
            return (weightArray?.count)!
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cellID")

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cellID")
        }

        cell?.textLabel?.text = weightArray?[indexPath.row] as! String
        cell?.textLabel?.font =  UIFont(name:"Times New Roman", size: 10)
        cell?.textLabel?.textAlignment = .left
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:UITableViewCell? = tableView.cellForRow(at: indexPath)
        dropDownBtn.setTitle(" " + (cell?.textLabel?.text)!, for: .normal)
        dropDownBtn.tag = invIdArray![indexPath.row] as! Int
        //self.cartBtn.accessibilityIdentifier = "\(indexPath.row)"
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: mrpArray?[indexPath.row] as! String)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        mrpLabel.attributedText = attributeString
        //mrpLabel.text =
        sellingPriceLabel.text = spArray?[indexPath.row] as! String
        if offerArray?[indexPath.row] as! String == "0 %" {
            offerLabel.isHidden = true
        } else {
            offerLabel.text = offerArray?[indexPath.row] as! String
        }
        backView?.isHidden = true
    }
    
}
