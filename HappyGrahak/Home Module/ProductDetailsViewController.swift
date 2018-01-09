//
//  ProductDetailsViewController.swift
//  HappyGrahak
//
//  Created by IOS on 02/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit
import CoreData

class ProductDetailsViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var offerLabel: UILabel!
    var productId: Int = 0
    var invId: Int?
    
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
    var myView: UIView?
    var tableView: UITableView?
    
    var label: UILabel?
    var imgPathArray: NSMutableArray = NSMutableArray()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        label?.textColor = UIColor.white
        self.navigationItem.titleView = label!
        //
        if (UserDefaults.standard.value(forKey:"userId") == nil) {
            self.wishlistBtn.isHidden = true
        }
        addCartBtn.layer.cornerRadius = addCartBtn.frame.size.height/2
        self.addTableView()
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
        myView = UIView.init(frame: CGRect(x: dropBtn.frame.origin.x, y: dropBtn.frame.origin.y+44.0, width: dropBtn.frame.size.width, height: CGFloat((quantityArray?.count)!*30)))
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
        return (quantityArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cellID")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cellID")
        }
        
        cell?.textLabel?.text = quantityArray?[indexPath.row] as! String
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
        dropBtn.tag = invIdArray![indexPath.row] as! Int
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: mrpArray?[indexPath.row] as! String)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        self.mrpLabel.attributedText = attributeString
        self.pricceLabel.text = spArray?[indexPath.row] as! String
        self.offerLabel.text = offerArray?[indexPath.row] as! String
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
//                            var mrpArray: NSMutableArray?
//                            var spArray: NSMutableArray?
//                            var offerArray: NSMutableArray?
                            var  data: NSDictionary?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSDictionary
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            print("Data:- \(data!)")
                            if (!(error!)){
                                productName = data?["name"] as! String
                                self.descLabel.text = data?["description"] as! String
                                self.nameLabel.text = productName
                                self.label?.text = productName
                                self.offerLabel.text = self.offer
                                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.mrp)
                                attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                                self.mrpLabel.attributedText = attributeString
                                self.pricceLabel.text = self.price
                                self.dropBtn.tag = self.invId!
                                self.dropBtn.setTitle(" " + self.quantity, for: .normal)
                                self.imgArray = data?["images"] as? NSArray
                                
                                for i in self.imgArray! {
                                    let imgDict = i as! NSDictionary
                                    self.imgPathArray.add(imgDict["path"])
                                }
                                print(self.imgPathArray)
                                var Y: CGFloat = self.scrollview.frame.size.width/2-self.scrollview.frame.size.height/2
                                
                                for index in 0..<self.imgPathArray.count {
                                    let url = URL(string: self.imgPathArray[index] as! String)
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
                                //print(productName)
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
                let myCart = MyCart(context: context)
                myCart.cartId = Int16(myCarts.count)
                myCart.productId = Int16(productId)
                myCart.invt_id = Int16(dropBtn.tag)
                
                myCart.productName = nameLabel.text!
                myCart.imgPath = imagePath
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
            myCart.imgPath = imagePath
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
    }
    
    @objc func addToCart(sender: UIButton){
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
