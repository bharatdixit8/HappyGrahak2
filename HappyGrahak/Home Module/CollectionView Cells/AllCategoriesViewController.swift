//
//  AllCategoriesViewController.swift
//  HappyGrahak
//
//  Created by IOS on 20/01/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class AllCategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var categoryDataArray: NSArray?
    var idArray: NSMutableArray? = NSMutableArray()
    var  ukeyArray: NSMutableArray? = NSMutableArray()
    var nameArray: NSMutableArray? = NSMutableArray()
    var  slugArray: NSMutableArray? = NSMutableArray()
    var titleArray: NSMutableArray? = NSMutableArray()
    var  imageArray: NSMutableArray? = NSMutableArray()
    var image_pathArray: NSMutableArray? = NSMutableArray()
    var  keywordsArray: NSMutableArray? = NSMutableArray()
    var descripArray: NSMutableArray? = NSMutableArray()
    var  typeArray: NSMutableArray? = NSMutableArray()
    var parentArray: NSMutableArray? = NSMutableArray()
    var  statusArray: NSMutableArray? = NSMutableArray()
    var created_atArray: NSMutableArray? = NSMutableArray()
    @IBOutlet var categoryCollectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (categoryDataArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "CollectionViewCell"
        
        var collectionCell: CategoryCollectionViewCell! = self.categoryCollectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CategoryCollectionViewCell
        if collectionCell == nil {
            self.categoryCollectionView!.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
            collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CategoryCollectionViewCell
        }
        print(self.categoryDataArray)
        if((self.categoryDataArray) != nil){
            collectionCell.productName.text = self.nameArray?.object(at: indexPath.row) as? String
            let url = URL(string: (self.image_pathArray?.object(at: indexPath.row) as? String)!)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                if data==nil{
                    collectionCell.productIcon.image = UIImage(named: "default_product_icon")
                }else{
                    DispatchQueue.main.async() {
                        collectionCell.productIcon.image = UIImage(data: data!)
                    }
                }
            }
            
            collectionCell.accessibilityIdentifier = self.idArray?.object(at: indexPath.row) as? String
        }
        
        return collectionCell
    }
    
    @objc func getMostPopularProduct(){
        let params: String
        
        params =  "category_id=1"
        
        let urlString = BASE_URL + "all-sub-category?" + params
        print(urlString)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        
        let request = URLRequest(url: url! as URL)
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
                            self.idArray = NSMutableArray()
                            self.ukeyArray = NSMutableArray()
                            self.nameArray = NSMutableArray()
                            self.slugArray = NSMutableArray()
                            self.titleArray = NSMutableArray()
                            self.imageArray = NSMutableArray()
                            self.image_pathArray = NSMutableArray()
                            self.keywordsArray = NSMutableArray()
                            self.descripArray = NSMutableArray()
                            self.typeArray = NSMutableArray()
                            self.parentArray = NSMutableArray()
                            self.statusArray = NSMutableArray()
                            self.created_atArray = NSMutableArray()
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            self.categoryDataArray = result["data"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                print("id:- \(self.categoryDataArray!)")
                            for i in self.categoryDataArray! {
                                let object = i as? NSDictionary
                                print(object?.value(forKey: "id"))
                                self.idArray?.add(object?.value(forKey: "id"))
                                self.ukeyArray?.add(object?.value(forKey: "ukey"))
                                self.nameArray?.add(object?.value(forKey: "name"))
                                self.slugArray?.add(object?.value(forKey: "slug"))
                                self.titleArray?.add(object?.value(forKey: "title"))
                                self.imageArray?.add(object?.value(forKey: "image"))
                                self.image_pathArray?.add(object?.value(forKey: "image_path"))
                                self.keywordsArray?.add(object?.value(forKey: "keywords"))
                                self.descripArray?.add(object?.value(forKey: "description"))
                                self.typeArray?.add(object?.value(forKey: "type"))
                                self.parentArray?.add(object?.value(forKey: "parent"))
                                self.statusArray?.add(object?.value(forKey: "status"))
                                self.created_atArray?.add(object?.value(forKey: "created_at"))
                            }
                            self.categoryCollectionView.reloadData()
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
