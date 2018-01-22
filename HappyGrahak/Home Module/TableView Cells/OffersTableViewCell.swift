//
//  OffersTableViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 29/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class OffersTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var headerLabel: CustomLabel!
    @IBOutlet var collectionView: UICollectionView!
    let idArray: NSMutableArray? = NSMutableArray()
    let nameArray: NSMutableArray? = NSMutableArray()
    let image_pathArray: NSMutableArray? = NSMutableArray()
    override func awakeFromNib() {
        super.awakeFromNib()
        headerLabel.attributedText = headerLabel.labelColor(text: "HAPPYGRAHAK OFFERS", range: NSRange(location: 0, length: 11))
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView!.register(UINib(nibName: "OffersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Offers")
        self.getSubCategory()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (nameArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "Offers"
        
        var collectionCell: OffersCollectionViewCell! = self.collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? OffersCollectionViewCell
        if collectionCell == nil {
            self.collectionView!.register(UINib(nibName: "OffersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
            collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? OffersCollectionViewCell
        }
        //        collectionCell.nameLabel.text = nameArray?.object(at: indexPath.row) as? String
                let url = URL(string: (image_pathArray?.object(at: indexPath.row) as? String)!)
                let data = try? Data(contentsOf: url!)
                if data==nil{
                    collectionCell.imgView.image = UIImage(named: "default_product_icon")
                }else{
                    collectionCell.imgView.image = UIImage(data: data!)
                }
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size.height = collectionView.frame.size.height * CGFloat((nameArray?.count)!)
        return CGSize(width: collectionView.frame.size.width, height: 100.0);
    }
    @objc func getSubCategory(){
        let params: String
        
        params =  ""
        
        let urlString = BASE_URL + "offers?" + params
        print(urlString)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        
        var request = URLRequest(url: url! as URL)
        //request.addValue("Bearer \(_token)", forHTTPHeaderField: "Authorization")
        BACKGROUND_QUEUE {
            
            API.startRequest(request: request, method: "POST",type: 0, params: "", completion: { (response:URLResponse?, result:AnyObject?, error:Error?, responseStatus:String?) in
                
                //print("ERROR : \(error)")
                
                if (response as? HTTPURLResponse) != nil {
                    // self.statusCode = httpResponse.statusCode
                }
                
                if error == nil {
                    if responseStatus == Sucees
                    {
                        MAIN_QUEUE {
                            //APP_DELEGATE.hideHud()
                            print("SingleAddedUser RESPONSE:- \(result!)")
                            
                            let result = result as! NSDictionary
                            var error: Bool?
                            var message: NSArray?
                            var  data: NSArray?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                print("id:- \(data!)")
                                for i in data! {
                                    let object = i as? NSDictionary
                                    self.idArray?.add(object?.value(forKey: "id"))
                                    self.nameArray?.add(object?.value(forKey: "name"))
                                    self.image_pathArray?.add(object?.value(forKey: "image"))
                                }
                                print("images:-",self.image_pathArray)
                                if ((self.image_pathArray!.count) > 0) {
                                    self.collectionView.reloadData()
                                }else{
                                    self.collectionView.isHidden = true
                                }
                            }else{
                            }
                        }
                    }
                    else if responseStatus == ServerErr
                    {
                        MAIN_QUEUE {
                            //APP_DELEGATE.hideHud()
                            //                            ConveienceClass.showSimpleAlert(title: "Error!", message: result?.value(forKey: "Message") as! String, controller: self)
                        }
                    }
                    else if responseStatus == ClientErr
                    {
                        MAIN_QUEUE {
                            //APP_DELEGATE.hideHud()
                        }
                        
                    }
                } else {
                    
                    MAIN_QUEUE {
                        // APP_DELEGATE.hideHud()
                        //                        ConveienceClass.showSimpleAlert(title: "Error!", message: (error?.localizedDescription)!, controller: self)
                    }
                }
            })
            
        }
    }
}
