//
//  ViewMoreScrollTableViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 28/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class ViewMoreScrollTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var nameLabel: CustomLabel!
    @IBOutlet var collectionView: UICollectionView!
    let idArray: NSMutableArray? = NSMutableArray()
    let nameArray: NSMutableArray? = NSMutableArray()
    let image_pathArray: NSMutableArray? = NSMutableArray()
    let created_atArray: NSMutableArray? = NSMutableArray()
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.attributedText = nameLabel.labelColor(text: "SHOP ON HAPPYGRAHAK", range: NSRange(location: 0, length: 7))
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView!.register(UINib(nibName: "SuperSaverCollectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SuperSaverCollectionCollectionViewCell")
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
        let identifier = "SuperSaverCollectionCollectionViewCell"
        
        var collectionCell: SuperSaverCollectionCollectionViewCell! = self.collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? SuperSaverCollectionCollectionViewCell
        if collectionCell == nil {
            self.collectionView!.register(UINib(nibName: "SuperSaverCollectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SuperSaverCollectionCollectionViewCell")
            collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? SuperSaverCollectionCollectionViewCell
        }
        collectionCell.nameLabel.text = nameArray?.object(at: indexPath.row) as? String
        if let path = (self.image_pathArray?.object(at: indexPath.row) as? String)
        {
            let url = URL(string: path)
            let data = try? Data(contentsOf: url!)
            collectionCell.imgView.image = UIImage(data: data!)
        }
        else
        {
            collectionCell.imgView.image = UIImage(named: "default_product_icon")
        }
//        let url = URL(string: (image_pathArray?.object(at: indexPath.row) as? String)!)
//        let data = try? Data(contentsOf: url!)
//        collectionCell.imgView.image = UIImage(data: data!)
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240.0, height: 90.0);
    }
    @objc func getSubCategory(){
        let params: String
        
        params =  ""
        
        let urlString = BASE_URL + "super-saver?" + params
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
                                    self.created_atArray?.add(object?.value(forKey: "created_at"))
                                }
                                self.collectionView.reloadData()
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
