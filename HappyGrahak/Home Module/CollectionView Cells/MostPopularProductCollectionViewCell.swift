//
//  MostPopularProductCollectionViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 15/01/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class MostPopularProductCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var addCartBtn: UIButton!
    @IBOutlet var dropDownBtn: UIButton!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mrpLabel: UILabel!
    @IBOutlet var spLabel: UILabel!
    @IBOutlet var cpLabel: UILabel!
    @IBOutlet var rpLabel: UILabel!
    var backView: UIView?
    var myView: UIView?
    var weightArray: NSArray?
    var inventryIdArray: NSArray?
    var mrpArray: NSArray?
    var spArray: NSArray?
    var crArray: NSArray?
    var rpArray: NSArray?
    var imageArray: NSArray?
    var offerArray: NSArray?
    
    @IBOutlet var offerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        offerLabel.layer.cornerRadius = offerLabel.frame.size.height/2
        offerLabel.layer.borderWidth = 1.0
        offerLabel.layer.borderColor = UIColor.init(red: 111.0/255.0, green: 168.0/255.0, blue: 22.0/255.0, alpha: 1).cgColor
        addCartBtn.layer.cornerRadius = addCartBtn.frame.size.height/2
        if self.inventryIdArray != nil {
            addCartBtn.tag = self.inventryIdArray![0] as! Int
        }
        dropDownBtn.layer.borderWidth = 1.0
        dropDownBtn.layer.borderColor = UIColor.black.cgColor
        if self.weightArray != nil {
            dropDownBtn.setTitle(" \(self.weightArray![0] as! String)", for: .normal)
        }
        dropDownBtn.titleLabel?.textColor = UIColor.black
        if self.inventryIdArray != nil {
            dropDownBtn.tag = self.inventryIdArray![0] as! Int
        }
        dropDownBtn?.titleLabel?.font =  UIFont(name:"Times New Roman", size: 14)
        dropDownBtn.contentHorizontalAlignment = .left
        dropDownBtn.addTarget(self, action: #selector(self.customPopup), for: .touchUpInside)
        print(dropDownBtn.titleLabel?.text)
        // Initialization code
    }
    
    @objc func customPopup() -> Void {
        let window = UIApplication.shared.keyWindow!
        //print(weightArray?.count)
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
        imgView.image = self.imgView.image
        
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
        
        cell?.textLabel?.text = self.weightArray?[indexPath.row] as! String
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
        dropDownBtn.tag = self.inventryIdArray![indexPath.row] as! Int
        addCartBtn.tag = self.inventryIdArray![indexPath.row] as! Int
        if let path = ((self.imageArray![indexPath.row] as! NSArray)[0] as? String) {
            let url = URL(string: path)
            if url != nil {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                    if data != nil {
                        DispatchQueue.main.async() {
                            self.imgView.image = UIImage(data: data!)
                        }
                    } else {
                        self.imgView.image = UIImage(named: "default_product_icon")
                    }
                }
            }else{
                self.imgView.image = UIImage(named: "default_product_icon")
            }
        }
        //self.cartBtn.accessibilityIdentifier = "\(indexPath.row)"
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.mrpArray?[indexPath.row] as! String)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        mrpLabel.attributedText = attributeString
        //mrpLabel.text =
        spLabel.text = self.spArray?[indexPath.row] as! String
        cpLabel.text = self.crArray?[indexPath.row] as! String
        rpLabel.text = self.rpArray?[indexPath.row] as! String
        if self.offerArray?[indexPath.row] as! String == "0 %" {
            offerLabel.isHidden = true
        } else {
            offerLabel.text = offerArray?[indexPath.row] as! String
        }
        backView?.isHidden = true
    }

}
