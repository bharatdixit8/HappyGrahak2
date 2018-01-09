//
//  MostPopularTableViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 29/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class MostPopularTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collectionView: UICollectionView!
    let idArray: NSMutableArray? = NSMutableArray()
    let nameArray: NSMutableArray? = NSMutableArray()
    let image_pathArray: NSMutableArray? = NSMutableArray()
    let statusArray: NSMutableArray? = NSMutableArray()
    let created_atArray: NSMutableArray? = NSMutableArray()
    @IBOutlet var headerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView!.register(UINib(nibName: "MostPopularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Most")
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
        let identifier = "Most"
        
        var collectionCell: MostPopularCollectionViewCell! = self.collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MostPopularCollectionViewCell
        if collectionCell == nil {
            self.collectionView!.register(UINib(nibName: "MostPopularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
            collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MostPopularCollectionViewCell
        }
        
        collectionCell.nameLabel.text = nameArray?.object(at: indexPath.row) as? String
        let url = URL(string: (image_pathArray?.object(at: indexPath.row) as? String)!)
        let data = try? Data(contentsOf: url!)
        collectionCell.imgView.image = UIImage(data: data!)
        
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2.12, height: 100.0);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        print(idArray?.object(at: indexPath.row) as Any)
        
        UserDefaults.standard.set(idArray?.object(at: indexPath.row) as! Int, forKey: "sub_category_id")
        let cell: MostPopularCollectionViewCell = self.collectionView.cellForItem(at: indexPath) as! MostPopularCollectionViewCell
        print((cell.superview?.superview?.superview?.superview?.superview?.superview?.next)!)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
        nextViewController.headerTitle = cell.nameLabel.text
        let view: UIViewController = (cell.superview?.superview?.superview?.superview?.superview?.superview?.next)! as! UIViewController
        view.navigationController?.pushViewController(nextViewController, animated: true)
        //self.getSubCategory(id: sub_category?.id?.object(at: indexPath.row) as! Int, index: indexPath)
    }
    
    @objc func getSubCategory(){
        let params: String
        
        params =  ""
        
        let urlString = BASE_URL + "tag-list?" + params
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
                                    //self.statusArray?.add(object?.value(forKey: "status"))
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
