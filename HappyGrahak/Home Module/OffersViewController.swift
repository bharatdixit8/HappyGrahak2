//
//  OffersViewController.swift
//  HappyGrahak
//
//  Created by IOS on 08/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class OffersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var myTable: UITableView!
    var cell: ProductListTableViewCell?
    var headerTitle: String?
    let idArray: NSMutableArray? = NSMutableArray()
    let  brandArray: NSMutableArray? = NSMutableArray()
    let nameArray: NSMutableArray? = NSMutableArray()
    let  deleted_atArray: NSMutableArray? = NSMutableArray()
    let titleArray: NSMutableArray? = NSMutableArray()
    let  imageArray: NSMutableArray? = NSMutableArray()
    let image_pathArray: NSMutableArray? = NSMutableArray()
    let  keywordsArray: NSMutableArray? = NSMutableArray()
    let descripArray: NSMutableArray? = NSMutableArray()
    let  updated_atArray: NSMutableArray? = NSMutableArray()
    let  statusArray: NSMutableArray? = NSMutableArray()
    let created_atArray: NSMutableArray? = NSMutableArray()
    let inventryArray: NSMutableArray? = NSMutableArray()
    let inventryWeightArray: NSMutableArray? = NSMutableArray()
    let inventryMrpArray: NSMutableArray? = NSMutableArray()
    let inventrySpArray: NSMutableArray? = NSMutableArray()
    let inventryOfferArray: NSMutableArray? = NSMutableArray()
    let inventryIdArray: NSMutableArray? = NSMutableArray()
    var  data: NSArray?
    var myCarts: [MyCart] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var searchString: String?
    var flag: Bool = false
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.nameArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = self.myTable.dequeueReusableCell(withIdentifier: "Cell") as? ProductListTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "ProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ProductListTableViewCell
        }
        cell?.tag = indexPath.row+1
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.nameLabel.text = self.nameArray?.object(at: indexPath.row) as! String
//        cell?.dropBtn.layer.borderWidth = 1.0
//        cell?.dropBtn.layer.borderColor = UIColor.black.cgColor
        if let path = (self.image_pathArray?.object(at: indexPath.row) as? String)
        {
            let url = URL(string: path)
            let data = try? Data(contentsOf: url!)
            cell?.imgIconView.image = UIImage(data: data!)
        }
        else
        {
            cell?.imgIconView.image = UIImage(named: "default_product_icon")
            
        }
//        cell?.weightLabel.text = " \((inventryWeightArray?[indexPath.row] as! NSArray)[0])"
//        
//        cell?.weightLabel.tag = (self.inventryIdArray![indexPath.row] as! NSArray)[0] as! Int
//        cell?.weightLabel?.font =  UIFont(name:"Times New Roman", size: 10)
//        cell?.weightLabel.textAlignment = .left
        cell?.weightArray = self.inventryWeightArray![indexPath.row] as! NSArray
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (self.inventryMrpArray![indexPath.row] as! NSArray)[0] as! String)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        cell?.mrpLabel.attributedText = attributeString
        cell?.sellingPriceLabel.text = (self.inventrySpArray![indexPath.row] as! NSArray)[0] as! String
        cell?.mrpArray = self.inventryMrpArray![indexPath.row] as! NSArray
        cell?.spArray = self.inventrySpArray![indexPath.row] as! NSArray
        cell?.invIdArray = self.inventryIdArray![indexPath.row] as! NSArray
        if (self.inventryOfferArray![indexPath.row] as! NSArray)[0] as! String == "0 %" {
            cell?.offerLabel.isHidden = true
        } else {
            cell?.offerLabel.text = (self.inventryOfferArray![indexPath.row] as! NSArray)[0] as! String
        }
        cell?.offerArray = self.inventryOfferArray![indexPath.row] as! NSArray
        cell?.viewDetailsBtn.tag = indexPath.row
        cell?.cartBtn.tag = indexPath.row+100
        cell?.cartBtn.accessibilityIdentifier = "\(0)"
        cell?.wishListBtn.tag = indexPath.row+200
        cell?.wishListBtn.accessibilityIdentifier = "\(0)"
        cell?.cartBtn.addTarget(self, action:#selector(self.addToCart(sender:)), for:.touchUpInside)
        cell?.viewDetailsBtn.addTarget(self, action:#selector(self.showDetails), for:.touchUpInside)
        cell?.wishListBtn.addTarget(self, action: #selector(self.addWishlistOnline(sender:)), for: .touchUpInside)
        return cell!
    }
    
    @objc func addWishlistOnline(sender: UIButton) {
        cell?.myView?.isHidden = true
        let params: String
        print(sender.superview!)
        print(sender.superview?.viewWithTag((self.inventryIdArray![sender.tag-200] as! NSArray)[(sender.accessibilityIdentifier! as NSString).integerValue] as! Int))
        let btn: UIButton = sender.superview?.viewWithTag((self.inventryIdArray![sender.tag-200] as! NSArray)[(sender.accessibilityIdentifier as! NSString).integerValue] as! Int) as! UIButton
        
        params =  "product_id=\(idArray![sender.tag-200])&envt_id=\(btn.tag)"
        
        let urlString = BASE_URL + "user/wishlist/create?" + params
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
                            
                            let result = result as! NSDictionary
                            var error: Bool?
                            var message: NSArray?
                            var weightArray: NSMutableArray?
                            var mrpArray: NSMutableArray?
                            var spArray: NSMutableArray?
                            var offerArray: NSMutableArray?
                            //var  data: NSArray?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            self.data = result["data"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                sender.setImage(UIImage(named: "selected_wishlist"), for: .normal)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        nextViewController.offer = (self.inventryOfferArray![indexPath.row] as! NSArray)[0] as! String
        nextViewController.mrp = (self.inventryMrpArray![indexPath.row] as! NSArray)[0] as! String
        //print()
        nextViewController.price = (self.inventrySpArray![indexPath.row] as! NSArray)[0] as! String
        nextViewController.quantity = (self.inventryWeightArray![indexPath.row] as! NSArray)[0] as! String
        nextViewController.quantityArray = self.inventryWeightArray![indexPath.row] as! NSArray
        nextViewController.mrpArray = self.inventryMrpArray![indexPath.row] as! NSArray
        nextViewController.offerArray = self.inventryOfferArray![indexPath.row] as! NSArray
        nextViewController.spArray = self.inventrySpArray![indexPath.row] as! NSArray
        nextViewController.productId = self.idArray![indexPath.row] as! Int
        nextViewController.invIdArray = self.inventryIdArray![indexPath.row] as! NSArray
        nextViewController.invId = (self.inventryIdArray![indexPath.row] as! NSArray)[0] as! Int
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func showDetails(sender:UIButton) -> Void {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        nextViewController.offer = (self.inventryOfferArray![sender.tag] as! NSArray)[0] as! String
        nextViewController.mrp = (self.inventryMrpArray![sender.tag] as! NSArray)[0] as! String
        //print()
        nextViewController.price = (self.inventrySpArray![sender.tag] as! NSArray)[0] as! String
        nextViewController.quantity = (self.inventryWeightArray![sender.tag] as! NSArray)[0] as! String
        nextViewController.quantityArray = self.inventryWeightArray![sender.tag] as! NSArray
        nextViewController.mrpArray = self.inventryMrpArray![sender.tag] as! NSArray
        nextViewController.offerArray = self.inventryOfferArray![sender.tag] as! NSArray
        nextViewController.spArray = self.inventrySpArray![sender.tag] as! NSArray
        nextViewController.productId = self.idArray![sender.tag] as! Int
        nextViewController.invIdArray = self.inventryIdArray![sender.tag] as! NSArray
        nextViewController.invId = (self.inventryIdArray![sender.tag] as! NSArray)[0] as! Int
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    @objc func getSubCategory(){
        let params: String
        
        params =  ""
        
        let urlString = BASE_URL + "product-offer?" + params
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
                            var weightArray: NSMutableArray?
                            var mrpArray: NSMutableArray?
                            var spArray: NSMutableArray?
                            var offerArray: NSMutableArray?
                            var inventIdArray: NSMutableArray?
                            //var  data: NSArray?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            self.data = result["data"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                print("id:- \(self.data!)")
                                for i in self.data! {
                                    let object = i as? NSDictionary
                                    print(object?.value(forKey: "id"))
                                    self.idArray?.add(object?.value(forKey: "id"))
                                    self.brandArray?.add(object?.value(forKey: "brand"))
                                    self.nameArray?.add(object?.value(forKey: "name"))
                                    self.deleted_atArray?.add(object?.value(forKey: "deleted_at"))
                                    self.titleArray?.add(object?.value(forKey: "title"))
                                    self.imageArray?.add(object?.value(forKey: "image"))
                                    self.image_pathArray?.add(object?.value(forKey: "image_path"))
                                    self.keywordsArray?.add(object?.value(forKey: "keywords"))
                                    self.descripArray?.add(object?.value(forKey: "description"))
                                    self.updated_atArray?.add(object?.value(forKey: "updated_at"))
                                    self.statusArray?.add(object?.value(forKey: "status"))
                                    self.created_atArray?.add(object?.value(forKey: "created_at"))
                                    self.inventryArray?.add(object?.value(forKey: "inventry"))
                                }
                                print(self.inventryArray![0])
                                for i in self.inventryArray! {
                                    let object = i as? NSArray
                                    print(object![0])
                                    weightArray = NSMutableArray()
                                    mrpArray = NSMutableArray()
                                    spArray = NSMutableArray()
                                    offerArray = NSMutableArray()
                                    inventIdArray = NSMutableArray()
                                    for j in object! {
                                        let weight = j as? NSDictionary
                                        let weightQuantity = weight?.value(forKey: "qty_weight") as! String
                                        let weightUnitDict = weight?.value(forKey: "unit") as! NSDictionary
                                        let weightUnit = weightUnitDict.value(forKey: "symb") as! String
                                        let weightString = weightQuantity + " " + weightUnit
                                        
                                        let mrp = weight?.value(forKey: "mrp") as! String
                                         mrpArray?.add("\u{20B9}" + mrp)
                                        
                                        let sp = weight?.value(forKey: "sell_price") as! String
                                        spArray?.add("\u{20B9}" + sp)
                                        
                                        if let offer = (weight?.value(forKey: "offer_precentage") as? String)
                                        {
                                            offerArray?.add(offer + " %")
                                        }
                                        else
                                        {
                                            offerArray?.add("null %")
                                        }
                                        
                                        weightArray?.add(weightString)
                                        
                                        let id = weight?.value(forKey: "id")
                                        inventIdArray?.add(id)
                                    }
                                    self.inventryWeightArray?.add(weightArray)
                                    self.inventryMrpArray?.add(mrpArray)
                                    self.inventrySpArray?.add(spArray)
                                    self.inventryOfferArray?.add(offerArray)
                                    self.inventryIdArray?.add(inventIdArray)
                                }
                                print(self.inventryWeightArray)
                                let ptoduct_details = ProductDetailsModel.init(id: self.idArray, name: self.nameArray, title: self.titleArray, image: self.imageArray, image_path: self.image_pathArray, keywords: self.keywordsArray, descrip: self.descripArray, deleted_at: self.deleted_atArray, updated_at: self.updated_atArray, status: self.statusArray, created_at: self.created_atArray, brand: self.brandArray)
                                self.myTable.reloadData()
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
                    }
                }
            })
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let controller: DataController?
        //let entityDesc: NSEntityDescription?
        if flag {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        let button1 = UIButton.init(type: .custom)
        button1.setImage(UIImage.init(named: "back_Icon"), for: UIControlState.normal)
        button1.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        button1.addTarget(self, action:#selector(self.backAction), for:.touchUpInside)
        let barButton1 = UIBarButtonItem.init(customView: button1)
        self.navigationItem.leftBarButtonItem = barButton1
        self.navigationItem.title = headerTitle
        myTable.delegate = self
        myTable.dataSource = self
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
        self.getSubCategory()
        // Do any additional setup after loading the view.
    }
    
    @objc func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addToCart(sender: UIButton){
        if (UserDefaults.standard.value(forKey:"userId") != nil) {
            self.addCartOnline(sender: sender)
        } else {
            self.addcardOffline(sender: sender)
        }
    }
    
    func addcardOffline(sender: UIButton) {
        
        let productIdArray: NSMutableArray = NSMutableArray()
        let intvtIdArray: NSMutableArray = NSMutableArray()
        var productQuantityArray: NSMutableArray = NSMutableArray()
        var cartIdArray: NSMutableArray = NSMutableArray()
        var  updateCartId: Int?
        
        cell?.myView?.isHidden = true
        
        do{
            myCarts = try context.fetch(MyCart.fetchRequest())
        }catch{
            print("Fetching Failed")
        }
        for cart in myCarts {
            productIdArray.add(cart.productId)
            intvtIdArray.add(cart.invt_id)
            productQuantityArray.add(cart.quantity)
            cartIdArray.add(cart.cartId)
        }
        
        //allOrders.filter("\(productIdArray)")
        let btn: UILabel = sender.superview?.viewWithTag((self.inventryIdArray![sender.tag-100] as! NSArray)[(sender.accessibilityIdentifier as! NSString).integerValue] as! Int) as! UILabel
        if productIdArray.contains(idArray?.object(at: sender.tag-100)) {
            if intvtIdArray.contains(btn.tag){
                let valueIndex = intvtIdArray.index(of: btn.tag)
                let quantity: Int = (productQuantityArray.object(at: valueIndex) as! NSString).integerValue
                let cells: ProductListTableViewCell = sender.superview?.superview as! ProductListTableViewCell
                updateCartId = cartIdArray.object(at: valueIndex) as! Int
                
                let request: NSFetchRequest<MyCart> = MyCart.fetchRequest()
                let entity = NSEntityDescription.entity(forEntityName: "MyCart", in: context)
                request.entity = entity
                print("cartId=\(updateCartId!)")
                let pred = NSPredicate(format: "cartId=\(updateCartId!)")
                request.predicate = pred
                
                do {
                    let results =
                        try context.fetch(request as!
                            NSFetchRequest<NSFetchRequestResult>)
                    let match = results[0] as! NSManagedObject
                    let quantity = (match.value(forKey: "quantity") as! NSString).integerValue
                    match.setValue("\(quantity+1)", forKey: "quantity")
                    print(quantity)
                } catch let error {
                    // Handle error
                }
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            } else {
                let btn: UILabel = sender.superview?.viewWithTag((self.inventryIdArray![sender.tag-100] as! NSArray)[(sender.accessibilityIdentifier as! NSString).integerValue] as! Int) as! UILabel
                let myCart = MyCart(context: context)
                myCart.cartId = Int16(myCarts.count)
                myCart.productId = Int16(idArray?.object(at: sender.tag-100) as! Int)
                myCart.invt_id = Int16(btn.tag)
                let cells: ProductListTableViewCell = sender.superview?.superview as! ProductListTableViewCell
                myCart.productName = nameArray?.object(at: sender.tag-100) as! String
                myCart.imgPath = image_pathArray?.object(at: sender.tag-100) as! String
                myCart.unit = (cells.weightLabel.text)!
                myCart.quantity = "1"
                myCart.price = (cells.sellingPriceLabel.text)!
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        } else {
            let btn: UILabel = sender.superview?.viewWithTag((self.inventryIdArray![sender.tag-100] as! NSArray)[(sender.accessibilityIdentifier as! NSString).integerValue] as! Int) as! UILabel
            let myCart = MyCart(context: context)
            myCart.cartId = Int16(myCarts.count)
            myCart.productId = Int16(idArray?.object(at: sender.tag-100) as! Int)
            myCart.invt_id = Int16(btn.tag)
            let cells: ProductListTableViewCell = sender.superview?.superview as! ProductListTableViewCell
            myCart.productName = nameArray?.object(at: sender.tag-100) as! String
            myCart.imgPath = image_pathArray?.object(at: sender.tag-100) as! String
            myCart.unit = (cells.weightLabel.text)!
            myCart.quantity = "1"
            myCart.price = (cells.sellingPriceLabel.text)!
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        do{
            myCarts = try context.fetch(MyCart.fetchRequest())
        }catch{
            print("Fetching Failed")
        }
        let count: Int = myCarts.count
        //        let viewArray: Array = (self.navigationController?.navigationBar.subviews)!
        //        print(viewArray)
        let label: UILabel = self.navigationController?.navigationBar.viewWithTag(1001) as! UILabel
        label.text = String(describing: count)
    }
    
    func addCartOnline(sender: UIButton) {
        cell?.myView?.isHidden = true
        let params: String
        let btn: UILabel = sender.superview?.viewWithTag((self.inventryIdArray![sender.tag-100] as! NSArray)[(sender.accessibilityIdentifier as! NSString).integerValue] as! Int) as! UILabel
        
        params =  "product_id=\(idArray![sender.tag-100])&envt_id=\(btn.tag)"
        
        let urlString = BASE_URL + "user/cart/add?" + params
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
                            
                            let result = result as! NSDictionary
                            var error: Bool?
                            var message: NSArray?
                            var weightArray: NSMutableArray?
                            var mrpArray: NSMutableArray?
                            var spArray: NSMutableArray?
                            var offerArray: NSMutableArray?
                            //var  data: NSArray?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            self.data = result["data"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                print("id:- \(self.data!)")
                                self.sendToken(_token: (UserDefaults.standard.value(forKey:"token") as! String))
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
    
    @objc func sendToken(_token: String){
        let params: String
        
        params =  "token=\(_token)"
        
        let urlString = BASE_URL + "user?" + params
        print(urlString)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        
        var request = URLRequest(url: url! as URL)
        request.addValue("Bearer \(_token)", forHTTPHeaderField: "Authorization")
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
                            var  data: NSDictionary?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSDictionary
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                let userDetails = UserDetailsModel(id: data!["id"] as? Int, roleId: data!["role_id"] as? Int, name: data!["name"] as? String, mobile: data!["mobile"] as? String, email: data!["email"] as? String, is_active: data!["is_active"] as? Bool, cartCount: data!["cart_count"] as? Int)
                                UserDefaults.standard.set(data!["id"], forKey: "userId")
                                UserDefaults.standard.set(data!["cart_count"], forKey: "cartCount")
                                let count: Int = (UserDefaults.standard.value(forKey:"cartCount") as! Int)
                                let label: UILabel = self.navigationController?.navigationBar.viewWithTag(1001) as! UILabel
                                label.text = String(describing: count)
                            }else{
                                let alert = UIAlertController(title: "Not Registered", message: message?[0] as? String, preferredStyle:  UIAlertControllerStyle.alert)
                                
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                                
                                alert.addAction(okAction)
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                    else if responseStatus == ServerErr
                    {
                        MAIN_QUEUE {
                            //APP_DELEGATE.hideHud()
                            ConveienceClass.showSimpleAlert(title: "Error!", message: result?.value(forKey: "Message") as! String, controller: self)
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
                        ConveienceClass.showSimpleAlert(title: "Error!", message: (error?.localizedDescription)!, controller: self)
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
