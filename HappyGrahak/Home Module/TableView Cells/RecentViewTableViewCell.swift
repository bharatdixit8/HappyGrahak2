//
//  RecentViewTableViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 20/01/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit
import CoreData

class RecentViewTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var productIdArray: NSMutableArray = NSMutableArray()
    var productNameArray: NSMutableArray = NSMutableArray()
    var allInventryArray: NSMutableArray = NSMutableArray()
    var allImagesArray: NSMutableArray = NSMutableArray()
    var allMRPArray: NSMutableArray = NSMutableArray()
    var allSPArray: NSMutableArray = NSMutableArray()
    var allCRArray: NSMutableArray = NSMutableArray()
    var allRPArray: NSMutableArray = NSMutableArray()
    var allOfferArray: NSMutableArray = NSMutableArray()
    var allWeightArray: NSMutableArray = NSMutableArray()
    var inventryIdArray: NSMutableArray = NSMutableArray()
    var collectionCell: MostPopularProductCollectionViewCell?
    var selectedProductId: Int?
    var selectedInvtId: Int?
    var label: UILabel?
    var innerIndx: Int?
    var outerIndx: Int?
    var myCarts: [MyCart] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var footerLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.activityIndicator.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView!.register(UINib(nibName: "MostPopularProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "mostPopular")
        self.getRecentView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "mostPopular"
        
        collectionCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MostPopularProductCollectionViewCell
        if collectionCell == nil {
            self.collectionView!.register(UINib(nibName: "MostPopularProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
            collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MostPopularProductCollectionViewCell
        }
        collectionCell?.tag = productIdArray.object(at: indexPath.row) as! Int
        collectionCell?.nameLabel.text = self.productNameArray.object(at: indexPath.row) as? String
        
        if let path = (((self.allImagesArray.object(at: indexPath.row) as! NSArray)[0] as! NSArray)[0] as? String) {
            let url = URL(string: path)
            if url != nil {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                    if data != nil {
                        DispatchQueue.main.async() {
                            self.collectionCell?.imgView.image = UIImage(data: data!)
                        }
                    } else {
                        self.collectionCell?.imgView.image = UIImage(named: "default_product_icon")
                    }
                }
            }else{
                collectionCell?.imgView.image = UIImage(named: "default_product_icon")
            }
        }
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: ((self.allMRPArray[indexPath.row]) as! NSArray)[0] as! String)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        collectionCell?.mrpLabel.attributedText = attributeString
        //collectionCell.mrpLabel.text = ((self.allMRPArray[indexPath.row]) as! NSArray)[0] as! String
        collectionCell?.spLabel.text = ((self.allSPArray[indexPath.row]) as! NSArray)[0] as! String
        collectionCell?.cpLabel.text = ((self.allCRArray[indexPath.row]) as! NSArray)[0] as! String
        collectionCell?.rpLabel.text = ((self.allRPArray[indexPath.row]) as! NSArray)[0] as! String
        collectionCell?.dropDownBtn.setTitle(" \((self.allWeightArray[indexPath.row] as! NSArray)[0] as! String)", for: .normal)
        collectionCell?.dropDownBtn.tag = (self.inventryIdArray[indexPath.row] as! NSArray)[0] as! Int
        collectionCell?.addCartBtn.tag = (self.inventryIdArray[indexPath.row] as! NSArray)[0] as! Int
        collectionCell?.offerLabel.text = ((self.allOfferArray[indexPath.row]) as! NSArray)[0] as! String
        collectionCell?.weightArray = self.allWeightArray[indexPath.row] as! NSArray
        collectionCell?.inventryIdArray = self.inventryIdArray[indexPath.row] as! NSArray
        collectionCell?.mrpArray = self.allMRPArray[indexPath.row] as! NSArray
        collectionCell?.spArray = self.allSPArray[indexPath.row] as! NSArray
        collectionCell?.crArray = self.allCRArray[indexPath.row] as! NSArray
        collectionCell?.rpArray = self.allRPArray[indexPath.row] as! NSArray
        collectionCell?.imageArray = self.allImagesArray[indexPath.row] as! NSArray
        collectionCell?.offerArray = self.allOfferArray[indexPath.row] as! NSArray
        collectionCell?.addCartBtn.addTarget(self, action: #selector(self.addToCart(sender:)), for: .touchUpInside)
        return collectionCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collectionCell: MostPopularProductCollectionViewCell = collectionView.cellForItem(at: indexPath) as! MostPopularProductCollectionViewCell
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        nextViewController.offer = (self.allOfferArray[indexPath.row] as! NSArray)[0] as! String
        nextViewController.mrp = (self.allMRPArray[indexPath.row] as! NSArray)[0] as! String
        //print()
        nextViewController.invtArray = self.allInventryArray.object(at: indexPath.row) as! NSArray
        nextViewController.price = (self.allSPArray[indexPath.row] as! NSArray)[0] as! String
        nextViewController.quantity = (self.allWeightArray[indexPath.row] as! NSArray)[0] as! String
        nextViewController.quantityArray = self.allWeightArray[indexPath.row] as! NSArray
        nextViewController.mrpArray = self.allMRPArray[indexPath.row] as! NSArray
        nextViewController.offerArray = self.allOfferArray[indexPath.row] as! NSArray
        nextViewController.spArray = self.allSPArray[indexPath.row] as! NSArray
        nextViewController.productId = self.productIdArray[indexPath.row] as! Int
        nextViewController.invIdArray = self.inventryIdArray[indexPath.row] as! NSArray
        nextViewController.invId = (self.inventryIdArray[indexPath.row] as! NSArray)[0] as! Int
        let view: UIViewController = (collectionCell.superview?.superview?.superview?.superview?.superview?.next)! as! UIViewController
        view.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170.0, height: 270.0);
    }
    
    
    @objc func getRecentView(){
        let params: String
        let productsArray = UserDefaults.standard.value(forKey: "recentView") as! NSArray
        let idsString: String?
        if productsArray.count>0 {
            idsString = productsArray.componentsJoined(by: ",") as! String
            params =  idsString!
            let urlString = BASE_URL + "recent-product?" + params
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
                                var  data: NSArray?
                                self.productNameArray = NSMutableArray()
                                self.allInventryArray = NSMutableArray()
                                self.allImagesArray = NSMutableArray()
                                self.productIdArray = NSMutableArray()
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
                                        self.productNameArray.add(object?.value(forKey: "title"))
                                        let inventryPerProductArray = object?.value(forKey: "inventry")
                                        self.allInventryArray.add(inventryPerProductArray)
                                        self.productIdArray.add(object?.value(forKey: "id"))
                                    }
                                    
                                    for j in self.allInventryArray{
                                        let productInventries = j as! NSArray
                                        let imagesPerProductArray: NSMutableArray = NSMutableArray()
                                        let weightPerProductArray: NSMutableArray = NSMutableArray()
                                        let inventryIdPerProductArray: NSMutableArray = NSMutableArray()
                                        let mpArray: NSMutableArray = NSMutableArray()
                                        let spArray: NSMutableArray = NSMutableArray()
                                        let offerArray: NSMutableArray = NSMutableArray()
                                        let clubRateArray: NSMutableArray = NSMutableArray()
                                        let rewardPointArray: NSMutableArray = NSMutableArray()
                                        for i in productInventries{
                                            let inventry = i as! NSDictionary
                                            let weight = inventry.value(forKey: "qty_weight") as! String + " " + ((inventry.value(forKey: "unit") as! NSDictionary).value(forKey: "symb") as! String)
                                            let clubRate = inventry.value(forKey: "hg_club") as! String
                                            let rewardPoint = inventry.value(forKey: "hg_point") as! String
                                            clubRateArray.add("Club Rate: \u{20B9}" + clubRate)
                                            rewardPointArray.add("Reward Points: " + rewardPoint)
                                            let mrp = inventry.value(forKey: "mrp") as! String
                                            mpArray.add("\u{20B9} " + mrp)
                                            
                                            let sp = inventry.value(forKey: "sell_price") as! String
                                            spArray.add("\u{20B9} " + sp)
                                            
                                            if let offer = (inventry.value(forKey: "offer_precentage") as? String)
                                            {
                                                offerArray.add(offer + " %")
                                            }
                                            else
                                            {
                                                offerArray.add("0 %")
                                            }
                                            weightPerProductArray.add(weight)
                                            inventryIdPerProductArray.add(inventry.value(forKey: "id"))
                                            let imageArray = inventry.value(forKey: "images") as! NSArray
                                            let imagesPerInventryArray: NSMutableArray = NSMutableArray()
                                            for k in imageArray{
                                                let imageDict = k as! NSDictionary
                                                imagesPerInventryArray.add(imageDict.value(forKey: "image"))
                                            }
                                            imagesPerProductArray.add(imagesPerInventryArray)
                                        }
                                        self.allImagesArray.add(imagesPerProductArray)
                                        self.allWeightArray.add(weightPerProductArray)
                                        self.inventryIdArray.add(inventryIdPerProductArray)
                                        self.allMRPArray.add(mpArray)
                                        self.allSPArray.add(spArray)
                                        self.allOfferArray.add(offerArray)
                                        self.allCRArray.add(clubRateArray)
                                        self.allRPArray.add(rewardPointArray)
                                    }
                                    print(self.allImagesArray[3])
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
        }else{
            self.contentView.isHidden = true
        }
        
        
        
    }
    
    @objc func addToCart(sender: UIButton){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        selectedProductId = sender.superview?.tag
        selectedInvtId = sender.tag
        print(selectedInvtId)
        print(selectedProductId)
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
        //        let btn: UIButton = sender.superview?.viewWithTag((self.inventryIdArray![sender.tag-100] as! NSArray)[(sender.accessibilityIdentifier as! NSString).integerValue] as! Int) as! UIButton
        if productIdArray.contains(selectedProductId) {
            if intvtIdArray.contains(selectedInvtId){
                let valueIndex = intvtIdArray.index(of: selectedInvtId)
                let quantity: Int = (productQuantityArray.object(at: valueIndex) as! NSString).integerValue
                //let cells: ProductListTableViewCell = sender.superview?.superview as! ProductListTableViewCell
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
                    
                }
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            } else {
                let collectionCell = sender.superview?.superview as! MostPopularProductCollectionViewCell
                let indx = allInventryArray.index(of: selectedInvtId)
                let myCart = MyCart(context: context)
                myCart.cartId = Int16(myCarts.count)
                myCart.productId = Int16(selectedProductId!)
                myCart.invt_id = Int16(Int(selectedInvtId!))
                myCart.productName = collectionCell.nameLabel.text
                
                for i in 0..<self.inventryIdArray.count{
                    let object = self.inventryIdArray[i] as! NSArray
                    for j in 0..<object.count{
                        let invtId = object[j] as! Int
                        if sender.tag == invtId{
                            innerIndx = j
                            outerIndx = i
                        }
                    }
                }
                
                myCart.imgPath = ((self.allImagesArray.object(at: outerIndx!) as! NSArray)[innerIndx!] as! NSArray)[0] as! String
                
                myCart.unit = collectionCell.dropDownBtn.titleLabel?.text
                myCart.quantity = "1"
                myCart.price = (collectionCell.spLabel.text)!
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        } else {
            let collectionCell = sender.superview?.superview as! MostPopularProductCollectionViewCell
            let myCart = MyCart(context: context)
            myCart.cartId = Int16(myCarts.count)
            myCart.productId = Int16(selectedProductId!)
            myCart.invt_id = Int16(Int(selectedInvtId!))
            myCart.productName = collectionCell.nameLabel.text
            for i in 0..<self.inventryIdArray.count{
                let object = self.inventryIdArray[i] as! NSArray
                for j in 0..<object.count{
                    let invtId = object[j] as! Int
                    if sender.tag == invtId{
                        innerIndx = j
                        outerIndx = i
                    }
                }
            }
            print(outerIndx)
            print(innerIndx)
            if (((self.allImagesArray.object(at: outerIndx!) as! NSArray)[innerIndx!] as! NSArray)[0] as! String) != nil {
                myCart.imgPath = ((self.allImagesArray.object(at: outerIndx!) as! NSArray)[innerIndx!] as! NSArray)[0] as! String
            }else{
                myCart.imgPath = ""
            }
            
            myCart.unit = collectionCell.dropDownBtn.titleLabel?.text
            myCart.quantity = "1"
            myCart.price = (collectionCell.spLabel.text)!
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
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        label?.text = String(describing: count)
        
        //        let viewArray: NSArray = nextViewController.navigationController?.navigationBar.subviews as! NSArray
        //        for i in viewArray {
        //            let label: UILabel = (i as! UIView).viewWithTag(1001) as! UILabel
        //            label.text = String(describing: count)
        //        }
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    func addCartOnline(sender: UIButton) {
        let params: String
        
        params =  "product_id=\(selectedProductId!)&envt_id=\(selectedInvtId!)"
        
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
                            var data: NSArray?
                            //var  data: NSArray?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                print("id:- \(data!)")
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
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
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
                                
                                let label: UILabel = nextViewController.navigationController?.navigationBar.viewWithTag(1001) as! UILabel
                                label.text = String(describing: count)
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                            }else{
                                //                                let alert = UIAlertController(title: "Not Registered", message: message?[0] as? String, preferredStyle:  UIAlertControllerStyle.alert)
                                //
                                //                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                                //
                                //                                alert.addAction(okAction)
                                //
                                //                                // show the alert
                                //                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                    else if responseStatus == ServerErr
                    {
                        MAIN_QUEUE {
                            //APP_DELEGATE.hideHud()
                            ConveienceClass.showSimpleAlert(title: "Error!", message: result?.value(forKey: "Message") as! String, controller: nextViewController)
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
                        ConveienceClass.showSimpleAlert(title: "Error!", message: (error?.localizedDescription)!, controller: nextViewController)
                    }
                }
            })
            
        }
    }
    
}
