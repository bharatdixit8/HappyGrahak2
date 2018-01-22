//
//  ProductDetailsViewController.swift
//  HappyGrahak
//
//  Created by IOS on 02/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit
import CoreData

extension String{
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
}

class ProductDetailsViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var offerLabel: UILabel!
    var productId: Int = 0
    var invId: Int = 0
    
    var offer: String = ""
    var mrp: String = ""
    var price: String = ""
    var quantity: String = ""
    var imagePath: String = ""
    var imgArray: NSArray?
    var quantityArray: NSArray?
    var mrpArray: NSArray?
    var invIdArray: NSArray?
    var spArray: NSArray?
    var offerArray: NSArray?
    var invtArray: NSArray?
    var outerImageArray: NSMutableArray = NSMutableArray()
    
    var weightArray1 = NSMutableArray()
    var mrpArray1 = NSMutableArray()
    var spArray1 = NSMutableArray()
    var offerArray1 = NSMutableArray()
    var inventIdArray1 = NSMutableArray()
    
    var myView: UIView?
    var tableView: UITableView?
    
    var label: UILabel?
    var imgPathArray: NSMutableArray = NSMutableArray()
    var recentProductArray: NSMutableArray = NSMutableArray()
    var button1: UIButton?
    var myCarts: [MyCart] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var unitLabel: UILabel!
    @IBOutlet var mrpLabel: UILabel!
    @IBOutlet var pricceLabel: UILabel!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var addCartBtn: UIButton!
    @IBOutlet var dropBtn: UIButton!
    @IBOutlet var wishlistBtn: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let recentViewArray = UserDefaults.standard.value(forKey: "recentView") as! NSArray
        print(recentViewArray)
        if recentViewArray.contains(productId) {} else {
            for data in recentViewArray{
                self.recentProductArray.add(data)
            }
            self.recentProductArray.add(self.productId)
            print(self.recentProductArray)
            UserDefaults.standard.set(self.recentProductArray, forKey: "recentView")
            print(UserDefaults.standard.value(forKey: "recentView"))
            print(UserDefaults.standard.object(forKey: "recentView"))
            UserDefaults.standard.synchronize()
        }
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        singleTap.cancelsTouchesInView = false
        singleTap.numberOfTapsRequired = 1
        self.scrollview.addGestureRecognizer(singleTap)
        button1 = UIButton.init(type: .custom)
        button1?.setImage(UIImage.init(named: "back_Icon"), for: UIControlState.normal)
        button1?.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        button1?.addTarget(self, action:#selector(self.backAction), for:.touchUpInside)
        self.navigationController?.navigationBar.addSubview(button1!)
        self.navigationItem.hidesBackButton = true
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        label?.backgroundColor = UIColor.clear
        label?.numberOfLines = 0
        label?.font = UIFont.boldSystemFont(ofSize: 14.0)
        label?.textAlignment = .center
        label?.textColor = UIColor.black
        self.navigationItem.titleView = label!
        //
        if (UserDefaults.standard.value(forKey:"userId") == nil) {
            self.wishlistBtn.isHidden = true
        }
        //addCartBtn.layer.cornerRadius = addCartBtn.frame.size.height/2
        dropBtn.layer.borderWidth = 1.0
        dropBtn.layer.borderColor = UIColor.black.cgColor
        dropBtn.setTitleColor(UIColor.black, for: .normal)
        dropBtn.titleLabel?.font =  UIFont(name:"Times New Roman", size: 12)
        dropBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        dropBtn.addTarget(self, action: #selector(self.showAllQuantity), for:.touchUpInside)
        addCartBtn.addTarget(self, action: #selector(self.addToCart(sender:)), for:.touchUpInside)
        self.scrollview.delegate = self
        print(productId)
        
        //self.wishListBtn.tag = indexPath.row+200
        //self.wishListBtn.accessibilityIdentifier = "\(0)"
        self.wishlistBtn.addTarget(self, action: #selector(self.addWishlistOnline(sender:)), for: .touchUpInside)
        
        offerLabel.layer.cornerRadius = offerLabel.frame.size.height/2
        offerLabel.layer.borderWidth = 1.0
        offerLabel.layer.borderColor = UIColor.init(red: 92.0/255.0, green: 202.0/255.0, blue: 19.0/255.0, alpha: 1).cgColor
        self.getSubCategory()
    }
    
    @objc func addWishlistOnline(sender: UIButton) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        let params: String
        
        params =  "product_id=\(productId)&envt_id=\(dropBtn.tag)"
        
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
                            var data: NSArray?
                            var weightArray: NSMutableArray?
                            var mrpArray: NSMutableArray?
                            var spArray: NSMutableArray?
                            var offerArray: NSMutableArray?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                sender.setImage(UIImage(named: "selected_wishlist"), for: .normal)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        myView?.isHidden = true
        button1?.isHidden = true
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AllImageViewController") as! AllImageViewController
        nextViewController.imgPathArray = self.imgPathArray
        self.navigationController?.pushViewController(nextViewController, animated: true)  
        // Perform operation
    }
    
    @objc func backAction() -> Void {
        myView?.isHidden = true
        button1?.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func showAllQuantity() -> Void {
        myView?.isHidden = false
    }
    
    func addTableView() -> Void {
        myView = UIView.init(frame: CGRect(x: dropBtn.frame.origin.x, y: dropBtn.frame.origin.y+44.0, width: dropBtn.frame.size.width, height: CGFloat((self.weightArray1.count)*30)))
        myView?.layer.shadowOffset = CGSize(width: 0, height: 0)
        myView?.layer.shadowColor = UIColor.black.cgColor
        myView?.backgroundColor = UIColor.white
        myView?.layer.shadowRadius = 4
        myView?.layer.shadowOpacity = 0.25
        myView?.layer.masksToBounds = false;
        myView?.clipsToBounds = false;
        let window = UIApplication.shared.keyWindow!
        window.addSubview(myView!)
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: (myView?.frame.size.width)!, height: (myView?.frame.size.height)!))
        tableView?.delegate = self
        tableView?.dataSource = self
        myView?.addSubview(tableView!)
        myView?.isHidden = true
    }
    
    func configurePageControl() {
        self.pageControl.numberOfPages = self.imgPathArray.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.view.addSubview(pageControl)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.weightArray1.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cellID")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cellID")
        }
        
        cell?.textLabel?.text = self.weightArray1[indexPath.row] as! String
        cell?.textLabel?.font =  UIFont(name:"Times New Roman", size: 10)
        cell?.textLabel?.textAlignment = .left
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:UITableViewCell? = tableView.cellForRow(at: indexPath)
        dropBtn.setTitle(" " + (cell?.textLabel?.text)!, for: .normal)
        dropBtn.tag = self.inventIdArray1[indexPath.row] as! Int
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.mrpArray1[indexPath.row] as! String)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        self.mrpLabel.attributedText = attributeString
        self.pricceLabel.text = self.spArray1[indexPath.row] as! String
        self.offerLabel.text = self.offerArray1[indexPath.row] as! String
        
        var Y: CGFloat = self.scrollview.frame.size.width/2-self.scrollview.frame.size.height/2
        
        for index in 0..<(self.outerImageArray[indexPath.row] as! NSArray).count {
            let url = URL(string: (self.outerImageArray[indexPath.row] as! NSArray)[index] as! String)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            var imageView = UIImageView(frame: CGRect(x: Y, y: 0, width: self.scrollview.frame.size.height, height: self.scrollview.frame.size.height))
            imageView.image = UIImage(data: data!)
            imageView.layer.borderWidth=1.0
            imageView.layer.masksToBounds = true
            imageView.layer.borderColor = UIColor.white.cgColor
            //imageView.layer.cornerRadius = 50;// Corner radius should be half of the height and width.
            
            self.scrollview.addSubview(imageView)
            Y=self.scrollview.frame.size.width+Y
        }
        self.scrollview.contentSize = CGSize(width: Y, height: self.scrollview.frame.size.height)
        self.configurePageControl()
        
        self.myView?.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func getSubCategory(){
        let params: String
        
        params =  "product_id=\(productId)"
        
        let urlString = BASE_URL + "product-detail?" + params
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
                            var productName: String?
                            self.mrpArray1 = NSMutableArray()
                            self.spArray1 = NSMutableArray()
                            self.offerArray1 = NSMutableArray()
                            self.inventIdArray1 = NSMutableArray()
                            var  data: NSDictionary?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSDictionary
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            print("Data:- \(data!)")
                            if (!(error!)){
                                //let h2t = CkoHtmlToText()
                                productName = data?["name"] as! String
                                self.invtArray = data?["inventry"] as! NSArray
                                self.descLabel.attributedText = ((data?["detail"] as! NSDictionary)["description"] as! String).convertHtml()
                                self.nameLabel.text = productName
                                self.label?.text = productName
                                
                                self.outerImageArray = NSMutableArray()
                                for i in self.invtArray! {
                                    let object = i as! NSDictionary
                                    self.inventIdArray1.add(object.value(forKey: "id"))
                                    let imageArray = object.value(forKey: "images") as! NSArray
                                    var interImageArray: NSMutableArray = NSMutableArray()
                                    for j in imageArray {
                                        let imgObject = j as! NSDictionary
                                        interImageArray.add(imgObject.value(forKey: "image"))
                                    }
                                    self.outerImageArray.add(interImageArray)
                                    
                                    let weightQuantity = object.value(forKey: "qty_weight") as! String
                                    let weightUnitDict = object.value(forKey: "unit") as! NSDictionary
                                    let weightUnit = weightUnitDict.value(forKey: "symb") as! String
                                    
                                    let weightString = weightQuantity + " " + weightUnit
                                    
                                    let mrp = object.value(forKey: "mrp") as! String
                                    self.mrpArray1.add("\u{20B9} " + mrp)
                                    
                                    let sp = object.value(forKey: "sell_price") as! String
                                    self.spArray1.add("\u{20B9} " + sp)
                                    
                                    if let offer = (object.value(forKey: "offer_precentage") as? String)
                                    {
                                        self.offerArray1.add(offer + " %")
                                    }
                                    else
                                    {
                                        self.offerArray1.add("null %")
                                    }
                                    
                                    self.weightArray1.add(weightString)
                                    
                                }
                            
                                print(self.outerImageArray)
                                var Y: CGFloat = self.scrollview.frame.size.width/2-self.scrollview.frame.size.height/2
                                
                                for index in 0..<(self.outerImageArray[0] as! NSArray).count {
                                    let url = URL(string: (self.outerImageArray[0] as! NSArray)[index] as! String)
                                    var data: Data?
                                    var image: UIImage?
                                    if url != nil {
                                        data = try? Data(contentsOf: url!)
                                    }
                                    if data != nil{
                                        image = UIImage(data: data!)
                                    }else{
                                        image = UIImage(named: "default_product_icon")
                                    }
                                    var imageView = UIImageView(frame: CGRect(x: Y, y: 0, width: self.scrollview.frame.size.height, height: self.scrollview.frame.size.height))
                                    imageView.image = image
                                    imageView.layer.borderWidth=1.0
                                    imageView.layer.masksToBounds = true
                                    imageView.layer.borderColor = UIColor.white.cgColor
                                    //imageView.layer.cornerRadius = 50;// Corner radius should be half of the height and width.
                                    
                                    self.scrollview.addSubview(imageView)
                                    Y=self.scrollview.frame.size.width+Y
                                }
                                self.scrollview.contentSize = CGSize(width: Y, height: self.scrollview.frame.size.height)
                                self.configurePageControl()
                                
                                if self.offerArray1[0] as! String == "0 %" {
                                    self.offerLabel.isHidden = true
                                }else{
                                    self.offerLabel.text = self.offerArray1[0] as! String
                                }
                                
                                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.mrpArray1[0] as! String)
                                attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                                self.mrpLabel.attributedText = attributeString
                                self.pricceLabel.text = self.spArray1[0] as! String
                                self.dropBtn.tag = self.inventIdArray1[0] as! Int
                                self.dropBtn.setTitle(" " + (self.weightArray1[0] as! String), for: .normal)
                                self.addTableView()
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
        if productIdArray.contains(productId) {
            if intvtIdArray.contains(dropBtn.tag){
                let valueIndex = intvtIdArray.index(of: dropBtn.tag)
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
                    // Handle error
                }
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            } else {
                let myCart = MyCart(context: context)
                myCart.cartId = Int16(myCarts.count)
                myCart.productId = Int16(productId)
                myCart.invt_id = Int16(dropBtn.tag)
                
                myCart.productName = nameLabel.text!
                myCart.imgPath = ((self.outerImageArray[0] as! NSArray)[0] as! String)
                myCart.unit = (dropBtn.titleLabel?.text)!
                myCart.quantity = "1"
                myCart.price = pricceLabel.text!
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        } else {
            let myCart = MyCart(context: context)
            myCart.cartId = Int16(myCarts.count)
            myCart.productId = Int16(productId)
            myCart.invt_id = Int16(dropBtn.tag)
            
            myCart.productName = nameLabel.text!
            myCart.imgPath = ((self.outerImageArray[0] as! NSArray)[0] as! String)
            myCart.unit = (dropBtn.titleLabel?.text)!
            myCart.quantity = "1"
            myCart.price = pricceLabel.text!
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
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    @objc func addToCart(sender: UIButton){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.myView?.isHidden = true
        if (UserDefaults.standard.value(forKey:"userId") != nil) {
            self.addCartOnline(sender: sender)
        } else {
            self.addcardOffline(sender: sender)
        }
    }

    func addCartOnline(sender: UIButton) {
        let params: String
        
        params =  "product_id=\(productId)&envt_id=\(dropBtn.tag)"
        
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
                            //self.data = result["data"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                self.sendToken(_token: (UserDefaults.standard.value(forKey:"token") as! String))
                                //print("id:- \(self.data!)")
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
