//
//  WishListViewController.swift
//  HappyGrahak
//
//  Created by IOS on 26/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class WishListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var productIdArray: NSMutableArray = NSMutableArray()
    var productNameArray: NSMutableArray = NSMutableArray()
    var imagePathArray: NSMutableArray = NSMutableArray()
    var weightArray: NSMutableArray = NSMutableArray()
    var inventryIdArray: NSMutableArray = NSMutableArray()
    var priceArray: NSMutableArray = NSMutableArray()
    var wishlistIdArray: NSMutableArray = NSMutableArray()
    
    @IBOutlet var wishlistTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //http://10.107.4.131:8000/api/user/wishlist
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let button1 = UIButton.init(type: .custom)
        button1.setImage(UIImage.init(named: "back_Icon"), for: UIControlState.normal)
        button1.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        button1.addTarget(self, action:#selector(self.backAction), for:.touchUpInside)
        let barButton1 = UIBarButtonItem.init(customView: button1)
        self.navigationItem.leftBarButtonItem = barButton1
        self.navigationItem.title = "My WishList"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
        
        self.getWishlistHistory()
    }
    
    @objc func backAction() -> Void {
        let viewController = SideBarRootViewController(nibName: "SideBarRootViewController_iPhone", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @objc func cancelOrder(sender: UIButton){
//        let params: String
//        params = "order_id=\(sender.tag)&value=4"
//        let urlString = BASE_URL + "user/order/cancel?" + params
//        print(urlString)
//        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
//
//        var request = URLRequest(url: url! as URL)
//        let token: String = UserDefaults.standard.value(forKey:"token") as! String
//
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        BACKGROUND_QUEUE {
//
//            API.startRequest(request: request, method: "POST",type: 0, params: "", completion: { (response:URLResponse?, result:AnyObject?, error:Error?, responseStatus:String?) in
//
//                //print("ERROR : \(error)")
//
//                if (response as? HTTPURLResponse) != nil {
//                    // self.statusCode = httpResponse.statusCode
//                }
//
//                if error == nil {
//                    if responseStatus == Sucees
//                    {
//                        MAIN_QUEUE {
//                            //APP_DELEGATE.hideHud()
//                            print("SingleAddedUser RESPONSE:- \(result!)")
//
//                            let result = result as! NSDictionary
//                            var error: Bool?
//                            var message: NSArray?
//
//                            var  data: NSArray?
//
//                            error = result["error"] as? Bool
//                            message = result["msg"] as? NSArray
//                            data = result["data"] as? NSArray
//                            if (!(error!)){
//                                self.getOrderHistory()
//                            }else{
//                            }
//                        }
//                    }
//                    else if responseStatus == ServerErr
//                    {
//                        MAIN_QUEUE {
//                            //APP_DELEGATE.hideHud()
//                            //                            ConveienceClass.showSimpleAlert(title: "Error!", message: result?.value(forKey: "Message") as! String, controller: self)
//                        }
//                    }
//                    else if responseStatus == ClientErr
//                    {
//                        MAIN_QUEUE {
//                            //APP_DELEGATE.hideHud()
//                        }
//
//                    }
//                } else {
//
//                    MAIN_QUEUE {
//                        // APP_DELEGATE.hideHud()
//                        //                        ConveienceClass.showSimpleAlert(title: "Error!", message: (error?.localizedDescription)!, controller: self)
//                    }
//                }
//            })
//
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlistIdArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.wishlistTable.dequeueReusableCell(withIdentifier: "Cell") as? WishListTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "WishListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? WishListTableViewCell
        }
        cell?.tag = wishlistIdArray.object(at: indexPath.row) as! Int
        if let path = (imagePathArray.object(at: indexPath.row) as? String)
        {
            let url = URL(string: path)
            let data = try? Data(contentsOf: url!)
            cell?.productImg.image = UIImage(data: data!)
        }
        else
        {
            cell?.productImg.image = UIImage(named: "default_product_icon")
        }
        self.wishlistTable.separatorStyle = .none
        cell?.selectionStyle = .none
        cell?.productName.text = productNameArray.object(at: indexPath.row) as! String
        cell?.productQuantity.text = self.weightArray.object(at: indexPath.row) as! String
        cell?.productPrice.text = self.priceArray.object(at: indexPath.row) as! String
        cell?.deleteBtn.tag = wishlistIdArray.object(at: indexPath.row) as! Int
        cell?.deleteBtn.addTarget(self, action: #selector(self.removeWish(sender:)), for: .touchUpInside)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cells = wishlistTable.cellForRow(at: indexPath) as! WishListTableViewCell
        let indx = self.wishlistIdArray.index(of: cells.tag) as! Int
        productIdArray.object(at: indx)
        inventryIdArray.object(at: indx)
        
        print(productIdArray.object(at: indx))
        print(inventryIdArray.object(at: indx))
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        nextViewController.productId = (productIdArray[indexPath.row] as! NSString).integerValue
        nextViewController.invId = (inventryIdArray[indexPath.row] as! NSString).integerValue
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    @objc func removeWish(sender: UIButton) {
        let alert = UIAlertController(title: "Happy Grahak", message: "Are you sure you want to delete item from wishlist?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.removeFromWishlist(sender: sender)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
        }
        // add an action (button)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func removeFromWishlist(sender: UIButton){
        let params: String
        params = "id=\(sender.tag)"
        let urlString = BASE_URL + "user/wishlist/delete?" + params
        print(urlString)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        
        var request = URLRequest(url: url! as URL)
        let token: String = UserDefaults.standard.value(forKey:"token") as! String
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
                            
                            self.productIdArray = NSMutableArray()
                            self.productNameArray = NSMutableArray()
                            self.imagePathArray = NSMutableArray()
                            self.weightArray = NSMutableArray()
                            self.inventryIdArray = NSMutableArray()
                            self.priceArray = NSMutableArray()
                            self.wishlistIdArray = NSMutableArray()
                            
                            let result = result as! NSDictionary
                            var error: Bool?
                            var message: NSArray?
                            var  data: NSArray?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSArray
                            if (!(error!)){
                                self.getWishlistHistory()
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
    
    
    @objc func getWishlistHistory(){
        let params: String
        params = ""
        let urlString = BASE_URL + "user/wishlist?" + params
        print(urlString)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        
        var request = URLRequest(url: url! as URL)
        let token: String = UserDefaults.standard.value(forKey:"token") as! String
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
                            
                            self.productIdArray = NSMutableArray()
                            self.productNameArray = NSMutableArray()
                            self.imagePathArray = NSMutableArray()
                            self.weightArray = NSMutableArray()
                            self.inventryIdArray = NSMutableArray()
                            self.priceArray = NSMutableArray()
                            self.wishlistIdArray = NSMutableArray()
                            
                            let result = result as! NSDictionary
                            var error: Bool?
                            var message: NSArray?
                            var  data: NSArray?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSArray
                            if (!(error!)){
                                print("data:- \(data)")
                                if data?.count == 0 {
                                    self.wishlistTable.isHidden = true
                                    let iconImg = UIImage(named: "empty_wishlist_icon")
                                    let iconImageView = UIImageView(frame: CGRect(x: CGFloat(self.view.frame.size.width/2-(iconImg?.size.width)!/2), y: CGFloat(self.view.frame.size.height/2-(iconImg?.size.height)!/2), width: CGFloat((iconImg?.size.width)!), height: CGFloat((iconImg?.size.height)!)))
                                    iconImageView.image = iconImg
                                    self.view.addSubview(iconImageView)
                                }
                                for i in data! {
                                    let object = i as! NSDictionary
                                    self.productIdArray.add(object.value(forKey: "product_id"))
                                    self.productNameArray.add((object.value(forKey: "product") as! NSDictionary).value(forKey: "name"))
                                    self.imagePathArray.add((object.value(forKey: "product") as! NSDictionary).value(forKey: "image_path"))
                                    self.inventryIdArray.add(object.value(forKey: "envt_id"))
                                    self.wishlistIdArray.add(object.value(forKey: "id"))
                                    if object["inventry"] is NSNull {
                                        
                                    }else{
                                        let priceDict = object.value(forKey: "inventry") as! NSDictionary
                                        let price = priceDict.value(forKey: "sell_price") as! String
                                        self.priceArray.add("\u{20B9}" + price)
                                        self.weightArray.add("\((object.value(forKey: "inventry") as! NSDictionary).value(forKey: "qty_weight")!) \(((object.value(forKey: "inventry") as! NSDictionary).value(forKey: "unit") as! NSDictionary).value(forKey: "symb")!)")
                                    }
                                }
                                print(self.weightArray)
                                print(self.priceArray)
                                self.wishlistTable.reloadData()
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
