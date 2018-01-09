//
//  OrderDetailsViewController.swift
//  HappyGrahak
//
//  Created by IOS on 16/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var cartArray: NSArray?
    var nameArray: NSMutableArray = NSMutableArray()
    var imagePathArray: NSMutableArray = NSMutableArray()
    var quantityArray: NSMutableArray = NSMutableArray()
    var priceArray: NSMutableArray = NSMutableArray()
    var address: String?
    var city: String?
    var state: String?
    var country: String?
    var pin: String?
    var orderId: Int?
    var button1: UIButton?
    @IBOutlet var scroller: UIScrollView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var itemList: UITableView!
    @IBOutlet var subtotalLabel: UILabel!
    @IBOutlet var shippingChargesLabel: UILabel!
    @IBOutlet var discountLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var paymentModeLabel: UILabel!
    @IBOutlet var priceDetailView: UIView!
    @IBOutlet var shippingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.layer.cornerRadius = 5.0
        itemList.layer.cornerRadius = 5.0
        priceDetailView.layer.cornerRadius = 5.0
        shippingView.layer.cornerRadius = 5.0
        self.itemList.sizeToFit()
        self.getOrderDetails()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scroller.delegate = self
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        button1 = UIButton.init(type: .custom)
        button1?.setImage(UIImage.init(named: "back_Icon"), for: UIControlState.normal)
        button1?.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        button1?.addTarget(self, action:#selector(self.backAction), for:.touchUpInside)
        self.navigationController?.navigationBar.addSubview(button1!)
        self.navigationItem.title = "Order Detail"
        self.navigationItem.hidesBackButton = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        button1?.isHidden = true
    }
    
    @objc func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (nameArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ItemList"
        var cell: ItemListTableViewCell! = self.itemList.dequeueReusableCell(withIdentifier: identifier) as? ItemListTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "ItemListTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ItemListTableViewCell
        }
        self.itemList.separatorStyle = .none
        cell.selectionStyle = .none
        cell.productNameLabel.text=nameArray[indexPath.row] as! String
        cell.quantityLabel.text=quantityArray[indexPath.row] as! String
        cell.priceLabel.text=priceArray[indexPath.row] as! String
        if let path = (self.imagePathArray.object(at: indexPath.row) as? String)
        {
            let url = URL(string: path)
            let data = try? Data(contentsOf: url!)
            cell?.produtImage.image = UIImage(data: data!)
        }
        else
        {
            cell?.produtImage.image = UIImage(named: "default_product_icon")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    @objc func getOrderDetails(){
        let params: String
        let id: String = "\(self.orderId!)"
        //let o_id: String = self.orderId!
        params =  "order_id=\(self.orderId!)"
        
        let urlString = BASE_URL + "user/order/show?" + params
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
                            //print("SingleAddedUser RESPONSE:- \(result!)")
                            
                            let result = result as! NSDictionary
                            var error: Bool?
                            var message: NSArray?
                            var productDict: NSDictionary?
                            var invDict: NSDictionary?
                            self.nameArray = NSMutableArray()
                            self.imagePathArray = NSMutableArray()
                            self.quantityArray = NSMutableArray()
                            self.priceArray = NSMutableArray()
                            //var unitDict: NSDictionary?
                            var  data: NSDictionary?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSDictionary
                            
                            if (!(error!)){
                                self.cartArray = data?["cart_data"] as! NSArray
                                self.numberLabel.text = "\(data?["id"] as! Int)"
                                if data!["status"] as! String=="0" {
                                    self.statusLabel.text = "Pending"
                                } else if data!["status"] as! String=="1" {
                                    self.statusLabel.text = "Process"
                                } else if data!["status"] as! String=="2" {
                                    self.statusLabel.text = "Dispatch"
                                } else if data!["status"] as! String=="3" {
                                    self.statusLabel.text = "Delivered"
                                } else {
                                    self.statusLabel.text = "Canceled"
                                }
                                self.subtotalLabel.text=data?["sub_total"] as! String
                                self.shippingChargesLabel.text=data?["shipping_charge"] as! String
                                self.discountLabel.text=data?["discount"] as! String
                                self.totalLabel.text=data?["total"] as! String
                                self.paymentModeLabel.text=data?["pay_mode"] as! String
                                let shippingDetails: NSDictionary = data?["shipping_address"] as! NSDictionary
                                self.address = shippingDetails["address"] as! String
                                self.city = (shippingDetails["city"] as! NSDictionary).value(forKey: "name") as! String
                                self.state = (shippingDetails["state"] as! NSDictionary).value(forKey: "name") as! String
                                self.country = shippingDetails["country"] as! String
                                self.pin = shippingDetails["pin"] as! String
                                self.addressLabel.text = "\(self.address!), \(self.city!), \(self.state!), \(self.country!), \(self.pin!)"
                                for i in self.cartArray! {
                                    let object = i as? NSDictionary
                                    self.nameArray.add((object?.value(forKey: "product") as! NSDictionary).value(forKey: "name") as! String)
                                    self.imagePathArray.add((object?.value(forKey: "product") as! NSDictionary).value(forKey: "image_path") as! String)
                                    self.quantityArray.add(object?.value(forKey: "qty") as! String)
                                    self.priceArray.add(object?.value(forKey: "sub_total") as! String)
                                }
                                self.itemList.reloadData()
                                
                                var frame: CGRect = self.itemList.frame;
                                print(self.itemList.frame.size.height)
                                print(self.itemList.contentSize.height)
                                frame.size.height = CGFloat(90*self.nameArray.count)
                                self.itemList.frame = frame;
                                self.itemList.contentSize = frame.size
                                
                                var frame1: CGRect = self.priceDetailView.frame
                                frame1.origin.y = self.itemList.frame.origin.y+self.itemList.frame.size.height+8.0
                                self.priceDetailView.frame = frame1
                                var frame2: CGRect = self.shippingView.frame
                                frame2.origin.y = self.priceDetailView.frame.origin.y+self.priceDetailView.frame.size.height+8.0
                                                                self.shippingView.frame = frame2
                                
                                self.scroller.contentSize = CGSize(width: self.view.frame.size.width, height: self.headerView.frame.size.height+self.itemList.frame.size.height+self.priceDetailView.frame.size.height+self.shippingView.frame.size.height+50.0)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var frame: CGRect = self.itemList.frame;
        print(self.itemList.frame.size.height)
        print(self.itemList.contentSize.height)
        frame.size.height = CGFloat(90*self.nameArray.count)
        self.itemList.frame = frame;
        self.itemList.contentSize = frame.size
        
        var frame1: CGRect = self.priceDetailView.frame
        frame1.origin.y = self.itemList.frame.origin.y+self.itemList.frame.size.height+8.0
        self.priceDetailView.frame = frame1
        var frame2: CGRect = self.shippingView.frame
        frame2.origin.y = self.priceDetailView.frame.origin.y+self.priceDetailView.frame.size.height+8.0
        self.shippingView.frame = frame2
        
        self.scroller.contentSize = CGSize(width: self.view.frame.size.width, height: self.headerView.frame.size.height+self.itemList.frame.size.height+self.priceDetailView.frame.size.height+self.shippingView.frame.size.height+50.0)
    }
    
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        print("hello")
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
