//
//  MyCartViewController.swift
//  HappyGrahak
//
//  Created by IOS on 04/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class MyCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var cartListView: UITableView!
    var cartIdArray: NSMutableArray = NSMutableArray()
    var productIdArray: NSMutableArray = NSMutableArray()
    var invtIdArray: NSMutableArray = NSMutableArray()
    var nameArray: NSMutableArray = NSMutableArray()
    var quantityArray: NSMutableArray = NSMutableArray()
    var unitArray: NSMutableArray = NSMutableArray()
    var imgPathArray: NSMutableArray = NSMutableArray()
    var sellPriceArray: NSMutableArray = NSMutableArray()
    var invtImageArray: NSMutableArray = NSMutableArray()
    var button1: UIButton?
    var totalAmount: Float = 0.00
    var myCarts: [MyCart] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet var subTotalLabel: UILabel!
    @IBOutlet var shippingLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var headerLabel1: UILabel!
    @IBOutlet var headerLabel2: UILabel!
    @IBOutlet var headerLabel3: UILabel!
    @IBOutlet var amountDetailView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        let button: UIButton = self.navigationController?.navigationBar.viewWithTag(2001) as! UIButton
        button.isHidden = true
        let label: UILabel = self.navigationController?.navigationBar.viewWithTag(1001) as! UILabel
        label.isHidden = true
        button1 = UIButton.init(type: .custom)
        button1?.setImage(UIImage.init(named: "back_Icon"), for: UIControlState.normal)
        button1?.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        button1?.addTarget(self, action:#selector(self.backAction), for:.touchUpInside)
        self.navigationController?.navigationBar.addSubview(button1!)
        cartListView.delegate = self
        cartListView.dataSource = self
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "My Cart"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
        if (UserDefaults.standard.value(forKey:"userId") != nil) {
            self.getAllOnlineCart()
        } else {
            self.getAllOfflineCart()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let button: UIButton = self.navigationController?.navigationBar.viewWithTag(2001) as! UIButton
        button.isHidden = false
        let label: UILabel = self.navigationController?.navigationBar.viewWithTag(1001) as! UILabel
        label.isHidden = false
        button1?.isHidden = true
    }
    
    @objc func backAction() -> Void {
        button1?.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(cartIdArray.count)
        return cartIdArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MyCartTableViewCell? = self.cartListView.dequeueReusableCell(withIdentifier: "cartCell") as? MyCartTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "MyCartTableViewCell", bundle: nil), forCellReuseIdentifier: "cartCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as? MyCartTableViewCell
        }
        cell?.tag = (self.productIdArray[indexPath.row] as! NSString).integerValue
        cell?.accessibilityIdentifier = "\(self.invtIdArray[indexPath.row])"
        if (UserDefaults.standard.value(forKey:"userId") != nil) {
            if let path = ((self.invtImageArray.object(at: indexPath.row) as! NSArray)[0] as? String) {
                let url = URL(string: path)
                let data: Data?
                if url != nil{
                    data = try? Data(contentsOf: url!)
                    if data != nil{
                        cell?.imgView.image = UIImage(data: data!)
                    }else{
                        cell?.imgView.image = UIImage(named: "default_product_icon")
                    }
                }else{
                    cell?.imgView.image = UIImage(named: "default_product_icon")
                }
            }
        }else{
            if let path = (self.invtImageArray.object(at: indexPath.row) as? String) {
                let url = URL(string: path)
                let data: Data?
                if url != nil{
                    data = try? Data(contentsOf: url!)
                    if data != nil{
                        cell?.imgView.image = UIImage(data: data!)
                    }else{
                        cell?.imgView.image = UIImage(named: "default_product_icon")
                    }
                }else{
                    cell?.imgView.image = UIImage(named: "default_product_icon")
                }
            }
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cartListView.separatorStyle = UITableViewCellSeparatorStyle.none
        cell?.priceLabel.text = self.sellPriceArray.object(at: indexPath.row) as! String
        cell?.titleLabel.text = self.nameArray.object(at: indexPath.row) as? String
        cell?.weightLabel.text = self.unitArray.object(at: indexPath.row) as? String
        cell?.qtyLabel.text = self.quantityArray.object(at: indexPath.row) as? String
        cell?.minusBtn.tag = indexPath.row
        cell?.plusBtn.tag = indexPath.row
        cell?.removeBtn.tag = indexPath.row
        cell?.minusBtn.addTarget(self, action: #selector(self.updateCart(sender:)), for: .touchUpInside)
        cell?.plusBtn.addTarget(self, action: #selector(self.updateCart(sender:)), for: .touchUpInside)
        cell?.removeBtn.addTarget(self, action: #selector(self.addAlert(sender:)), for: .touchUpInside)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cells = cartListView.cellForRow(at: indexPath) as! MyCartTableViewCell
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        nextViewController.productId = cells.tag
        nextViewController.invId = (cells.accessibilityIdentifier as! NSString).integerValue
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func addAlert(sender: UIButton) {
        self.alertViewPopup("HappyGrahak", "Do you want to remove this card?", sender: sender)
    }
    
    @objc func alertViewPopup(_ title: String, _ message: String, sender: UIButton) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            if (UserDefaults.standard.value(forKey:"userId") != nil) {
                self.removeCartOnline(sender: sender)
            } else {
                self.removeCartOffline(sender: sender)
            }
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
    
    func updateCartOnline(sender: UIButton) {
        
        var params: String = ""
        print(productIdArray[sender.tag])
        let quantity: Int = Int((quantityArray[sender.tag] as! NSString).intValue)
        print(quantity+1)
        
        print(invtIdArray[sender.tag])
        if sender.titleLabel?.text=="+" {
            params =  "product_id=\(productIdArray[sender.tag])&envt_id=\(invtIdArray[sender.tag])&qty=\(quantity+1)"
        } else {
            if quantity==1 {
                self.alertViewPopup("HappyGrahak", "Do you want to remove this card?", sender: sender)
            } else {
                params =  "product_id=\(productIdArray[sender.tag])&envt_id=\(invtIdArray[sender.tag])&qty=\(quantity-1)"
            }
        }
        
        let urlString = BASE_URL + "user/cart/update?" + params
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
                            var productDict: NSDictionary?
                            var invDict: NSDictionary?
                            //var unitDict: NSDictionary?
                            var  data: NSDictionary?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSDictionary
                            //                            print("Error:- \(error!)")
                            //                            print("Message:- \(message!)")
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                print("\(data!)")
                                self.getAllOnlineCart()
                            }else{
                                
                                let alert = UIAlertController(title: "Happy Grahak", message: message![0] as! String, preferredStyle: UIAlertControllerStyle.alert)
                                
                                // add an action (button)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    
                                }
        
                                alert.addAction(okAction)
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                                self.alertViewPopup("Happy Grahak", message![0] as! String, sender: sender)
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
    
    @objc func updateCart(sender: UIButton){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        if (UserDefaults.standard.value(forKey:"userId") != nil) {
            self.updateCartOnline(sender: sender)
        } else {
            self.UpdateCartOffline(sender: sender)
        }
    }
    
    @objc func removeCartOffline(sender: UIButton){
        do{
            let allCarts = try context.fetch(MyCart.fetchRequest())
            //myCarts = allCarts.sorted(by: { ($0 as AnyObject).cartId < ($1 as AnyObject).cartId }) as! [MyCart]
        }catch{
            print("Fetching Failed")
        }
        let request: NSFetchRequest<MyCart> = MyCart.fetchRequest()
        let entity = NSEntityDescription.entity(forEntityName: "MyCart", in: context)
        request.entity = entity
        //print("cartId=\(updateCartId!)")
        let pred = NSPredicate(format: "cartId=\(cartIdArray[sender.tag])")
        request.predicate = pred
        
        do {
            let results =
                try context.fetch(request as!
                    NSFetchRequest<NSFetchRequestResult>)
            //let match = results[0] as! NSManagedObject
            context.delete(results[0] as! NSManagedObject)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }catch{
            print("Object not deleted")
        }
        self.getAllOfflineCart()

    }
    
    @objc func removeCartOnline(sender: UIButton){
        var params: String = ""
        params =  "cart_id=\(cartIdArray[sender.tag])"
        
        let urlString = BASE_URL + "user/cart/remove?" + params
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
                            var productDict: NSDictionary?
                            var invDict: NSDictionary?
                            //var unitDict: NSDictionary?
                            var  data: NSArray?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSArray
                            //                            print("Error:- \(error!)")
                            //                            print("Message:- \(message!)")
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                print("\(data!)")
                                self.getAllOnlineCart()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func getAllOfflineCart(){
        do{
            let allCarts = try context.fetch(MyCart.fetchRequest())
            myCarts = allCarts as! [MyCart]
        }catch{
            print("Fetching Failed")
        }
        if myCarts.count==0 {
            self.cartListView.isHidden = true
            let button = UIButton.init(frame: CGRect(x: self.cartListView.frame.size.width/2-50, y: self.cartListView.frame.size.height/2-50, width: 100.0, height: 100.0))
            button.setImage(UIImage(named: "empty_cart_icon"), for: .normal)
            button.addTarget(self, action: #selector(self.moveHome), for: .touchUpInside)
            self.view.addSubview(button)
            self.subTotalLabel.text = "0"
            self.shippingLabel.isHidden = true
            self.totalLabel.isHidden = true
            self.headerLabel2.isHidden = true
            self.headerLabel3.isHidden = true
        }
        self.cartIdArray = NSMutableArray()
        self.productIdArray = NSMutableArray()
        self.invtIdArray = NSMutableArray()
        self.nameArray = NSMutableArray()
        self.quantityArray = NSMutableArray()
        self.unitArray = NSMutableArray()
        self.invtImageArray = NSMutableArray()
        self.sellPriceArray = NSMutableArray()
        totalAmount = 0.00
        for order in myCarts {
            self.cartIdArray.add(order.cartId)
            self.productIdArray.add(order.productId)
            self.invtIdArray.add(order.invt_id)
            self.quantityArray.add(order.quantity)
            self.invtImageArray.add(order.imgPath)
            self.nameArray.add(order.productName)
            self.sellPriceArray.add(order.price)
            self.unitArray.add(order.unit)
            self.cartListView.reloadData()
            
            let priceArray = order.price?.components(separatedBy: " ")
            print(priceArray)
            print(order.quantity)
            totalAmount += ((priceArray![1] as NSString).floatValue)*((order.quantity! as NSString).floatValue)
            self.subTotalLabel.text = "\(totalAmount)"
            self.shippingLabel.isHidden = true
            self.totalLabel.isHidden = true
            self.headerLabel2.isHidden = true
            self.headerLabel3.isHidden = true
        }
        
        print(totalAmount)
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        //self.cartListView.reloadData()
    }
    
    @objc func moveHome() {
        let viewController = SideBarRootViewController(nibName: "SideBarRootViewController_iPhone", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func UpdateCartOffline(sender: UIButton) {
        let productIdArray: NSMutableArray = NSMutableArray()
        let intvtIdArray: NSMutableArray = NSMutableArray()
        var productQuantityArray: NSMutableArray = NSMutableArray()
        var cartIdArray: NSMutableArray = NSMutableArray()
        var  updateCartId: Int?
        
        
        do{
           let allCarts = try context.fetch(MyCart.fetchRequest())
            //myCarts = allCarts.sorted(by: { ($0 as AnyObject).cartId < ($1 as AnyObject).cartId }) as! [MyCart]
            
            for cart in myCarts {
                productIdArray.add(cart.productId)
                intvtIdArray.add(cart.invt_id)
                productQuantityArray.add(cart.quantity)
                cartIdArray.add(cart.cartId)
            }
        }catch{
            print("Fetching Failed")
        }
        
                let valueIndex = sender.tag
                let quantity: Int = (productQuantityArray.object(at: valueIndex) as! NSString).integerValue
               
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
                    if sender.titleLabel?.text=="+" {
                        match.setValue("\(quantity+1)", forKey: "quantity")
                    } else {
                        if quantity==1 {
                            self.alertViewPopup("HappyGrahak", "Do you want to remove this card?", sender: sender)
                            match.setValue("1", forKey: "quantity")
                        } else {
                            match.setValue("\(quantity-1)", forKey: "quantity")
                        }
                    }
                    
                    print(quantity)
                } catch let error {
                    // Handle error
                }
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
        self.getAllOfflineCart()
    }
    
    
    
    @objc func getAllOnlineCart(){
        let params: String
        
        params =  ""
        
        let urlString = BASE_URL + "user/cart/all?" + params
        print(urlString)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        
        var request = URLRequest(url: url! as URL)
        let token: String = UserDefaults.standard.value(forKey:"token") as! String
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        BACKGROUND_QUEUE {
            
            API.startRequest(request: request, method: "Get",type: 0, params: "", completion: { (response:URLResponse?, result:AnyObject?, error:Error?, responseStatus:String?) in
                
                //print("ERROR : \(error)")
                
                if (response as? HTTPURLResponse) != nil {
                    // self.statusCode = httpResponse.statusCode
                }
                
                if error == nil {
                    if responseStatus == Sucees
                    {
                        MAIN_QUEUE {
                            //APP_DELEGATE.hideHud()
                            //print("SingleAddedUser RESPONSE:- \(result!)")
                            
                            let result = result as! NSDictionary
                            var error: Bool?
                            var message: NSArray?
                            var productDict: NSDictionary?
                            var invDict: NSDictionary?
                            //var unitDict: NSDictionary?
                            var  data: NSArray?
                            self.cartIdArray = NSMutableArray()
                            self.productIdArray = NSMutableArray()
                            self.invtIdArray = NSMutableArray()
                            self.nameArray = NSMutableArray()
                            self.quantityArray = NSMutableArray()
                            self.unitArray = NSMutableArray()
                            self.imgPathArray = NSMutableArray()
                            self.sellPriceArray = NSMutableArray()
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSArray
//                            print("Error:- \(error!)")
//                            print("Message:- \(message!)")
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                print("\(data!)")
                                if data?.count==0 {
                                    self.cartListView.isHidden = true
                                    let button = UIButton.init(frame: CGRect(x: self.cartListView.frame.size.width/2-50, y: self.cartListView.frame.size.height/2-50, width: 100.0, height: 100.0))
                                    button.setImage(UIImage(named: "empty_cart_icon"), for: .normal)
                                    self.view.addSubview(button)
                                    self.getAmount()
                                } else {
                                    self.invtImageArray = NSMutableArray()
                                for index in data! {
                                    let object = index as! NSDictionary
                                    self.cartIdArray.add(object.value(forKey: "id"))
                                    self.productIdArray.add(object.value(forKey: "product_id"))
                                    self.invtIdArray.add(object.value(forKey: "invt_id"))
                                    self.quantityArray.add(object.value(forKey: "qty"))
                                    productDict = object.value(forKey: "product") as! NSDictionary
                                    invDict = object.value(forKey: "inventry") as! NSDictionary
                                    let unitDict = invDict?.value(forKey: "unit") as? NSDictionary
                                    self.imgPathArray = NSMutableArray()
                                    if (invDict?.value(forKey: "images") as! NSArray).count>0{
//                                        print(((object.value(forKey: "images") as! NSArray)[0] as! NSArray)[0] as! NSDictionary)
                                        //let inventImagesArray =
                                        let inventoryImageDict = ((invDict?.value(forKey: "images") as! NSArray)[0] as! NSDictionary)
                                        let inventoryImage = inventoryImageDict.value(forKey: "image") as! String
                                        self.imgPathArray.add(inventoryImage)
                                    }
                                    //self.imgPathArray.add(productDict?.value(forKey: "image_path"))
                                    self.nameArray.add(productDict?.value(forKey: "name"))
                                    let price: String = invDict?.value(forKey: "sell_price") as! String
                                    self.sellPriceArray.add("Price: " + price)
                                    let quantity: String = invDict?.value(forKey: "qty_weight") as! String
                                    let unit: String = unitDict?.value(forKey: "symb") as! String
                                    let weight: String = quantity + " " + unit
                                    self.unitArray.add(weight)
                                    self.invtImageArray.add(self.imgPathArray)
                                    self.cartListView.reloadData()
                                    self.getAmount()
                                }
                                   print(self.invtImageArray)
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
    
    @objc func getAmount(){
        let params: String
        
        params =  ""
        
        let urlString = BASE_URL + "user/cart/total?" + params
        print(urlString)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        
        var request = URLRequest(url: url! as URL)
        let token: String = UserDefaults.standard.value(forKey:"token") as! String
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        BACKGROUND_QUEUE {
            
            API.startRequest(request: request, method: "Get",type: 0, params: "", completion: { (response:URLResponse?, result:AnyObject?, error:Error?, responseStatus:String?) in
                
                //print("ERROR : \(error)")
                
                if (response as? HTTPURLResponse) != nil {
                    // self.statusCode = httpResponse.statusCode
                }
                
                if error == nil {
                    if responseStatus == Sucees
                    {
                        MAIN_QUEUE {
                            //APP_DELEGATE.hideHud()
                            //print("SingleAddedUser RESPONSE:- \(result!)")
                            
                            let result = result as! NSDictionary
                            var error: Bool?
                            var message: NSArray?
                            var productDict: NSDictionary?
                            var invDict: NSDictionary?
                            //var unitDict: NSDictionary?
                            var  data: NSDictionary?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSDictionary
                            //                            print("Error:- \(error!)")
                            //                            print("Message:- \(message!)")
                            print("Data:- \(data!)")
                            if (!(error!)){
                                let subTotal: Float = data?.value(forKey: "total") as! Float
                                let shipping: Float = data?.value(forKey: "shipping") as! Float
                                let total: Float = subTotal + shipping
                                self.subTotalLabel.text = "\(subTotal)"
                                self.shippingLabel.text = "\(shipping)"
                                self.totalLabel.text = "\(total)"
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
    
    @IBAction func checkOutBtn(_ sender: Any) {
        if (UserDefaults.standard.value(forKey:"userId") != nil) {
            if cartIdArray.count > 0 {
                let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
                nextViewController.totalAmt = self.totalLabel.text
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        } else {
            
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
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
