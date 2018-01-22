//
//  TopBrandsTableViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 28/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class TopBrandsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    let idArray: NSMutableArray? = NSMutableArray()
    let nameArray: NSMutableArray? = NSMutableArray()
    let image_pathArray: NSMutableArray? = NSMutableArray()
    let statusArray: NSMutableArray? = NSMutableArray()
    let created_atArray: NSMutableArray? = NSMutableArray()
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView!.register(UINib(nibName: "TopBrandsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Hello")
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
        let identifier = "Hello"
        
        var collectionCell: TopBrandsCollectionViewCell! = self.collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TopBrandsCollectionViewCell
        if collectionCell == nil {
            self.collectionView!.register(UINib(nibName: "TopBrandsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
            collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TopBrandsCollectionViewCell
        }
        collectionCell.nameLabel.text = nameArray?.object(at: indexPath.row) as? String
        if ((image_pathArray?.object(at: indexPath.row) as? String) != nil) {
        let url = URL(string: (image_pathArray?.object(at: indexPath.row) as? String)!)
        DispatchQueue.global().async {
        let data = try? Data(contentsOf: url!)
        if data != nil {
            DispatchQueue.main.async() {
                collectionCell.imgView.image = UIImage(data: data!)
            }
        } else {
            collectionCell.imgView.image = UIImage(named: "default_product_icon")
        }
        }
        }
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 145.0, height: 145.0);
    }
    @objc func getSubCategory(){
        let params: String
        
        params =  ""
        
        let urlString = BASE_URL + "top-brands?" + params
        print(urlString)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        
        var request = URLRequest(url: url! as URL)
        //request.addValue("Bearer \(_token)", forHTTPHeaderField: "Authorization")
        BACKGROUND_QUEUE {
            
            API.startRequest(request: request, method: "GET",type: 0, params: "", completion: { (response:URLResponse?, result:AnyObject?, error:Error?, responseStatus:String?) in
                
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
                                    self.statusArray?.add(object?.value(forKey: "status"))
                                }
                                
                                //self.collectionView.reloadData()
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
