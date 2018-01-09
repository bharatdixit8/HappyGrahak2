//
//  BuildOrderViewController.swift
//  HappyGrahak
//
//  Created by IOS on 15/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class BuildOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cellID")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cellID")
        }
        return cell!
    }
    

    @IBOutlet var cashDeliveryBtn: UIButton!
    @IBOutlet var onlinePaymentBtn: UIButton!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var shippingPriceLabel: UILabel!
    @IBOutlet var paaybleAmtLabel: UILabel!
    var addressId: String?
    var orderId: Int?
    var transactionId: String?
    var button1: UIButton?
    var myView: UIView?
    var backView: UIView?
    
    let checkedImage = UIImage(named: "selected_icon")! as UIImage
    let uncheckedImage = UIImage(named: "not_selected_icon")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.cashDeliveryBtn.setImage(checkedImage, for: UIControlState.normal)
            } else {
                self.cashDeliveryBtn.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    
    var isChecked1: Bool = false {
        didSet{
            if isChecked1 == true {
                self.onlinePaymentBtn.setImage(checkedImage, for: UIControlState.normal)
            } else {
                self.onlinePaymentBtn.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        self.customPopup()
        self.createOrder()
    }
    
    @objc func customPopup() -> Void {
        let window = UIApplication.shared.keyWindow!
        backView = UIView.init(frame: CGRect(x: 0, y: 0, width: window.frame.size.width, height: window.frame.size.height))
//        myView = UIView.init(frame: CGRect(x: (backView?.frame.size.width)!/2-150.0, y: (backView?.frame.size.height)!/2-CGFloat((150+(weightArray?.count)!*30)/2), width: 300.0, height: CGFloat(150+(weightArray?.count)!*30)))
        myView = UIView.init(frame: CGRect(x: (backView?.frame.size.width)!/2-150.0, y: (backView?.frame.size.height)!/2-CGFloat((150+(4)*30)/2), width: 300.0, height: CGFloat(150+(4)*30)))
        myView?.layer.shadowOffset = CGSize(width: 0, height: 0)
        myView?.layer.shadowColor = UIColor.black.cgColor
        backView?.backgroundColor = UIColor.clear
        myView?.backgroundColor = UIColor.white
        myView?.layer.shadowRadius = 4
        myView?.layer.shadowOpacity = 0.25
        myView?.layer.masksToBounds = false;
        myView?.clipsToBounds = false;
        
        let imgView: UIImageView = UIImageView.init(frame: CGRect(x: (myView?.frame.size.width)!/2-40.0, y: 20.0, width: 80.0, height: 80.0))
//        imgView.image = imgIconView.image
        
        let namesLabel: UILabel = UILabel.init(frame: CGRect(x: 0.0, y: 100.0, width: (myView?.frame.size.width)!, height: 30.0))
//        namesLabel.text = nameLabel!.text
        namesLabel.textAlignment = .center
        myView?.addSubview(imgView)
        myView?.addSubview(namesLabel)
        let weightTable = UITableView.init(frame: CGRect(x: 0, y: 150, width: (myView?.frame.size.width)!, height: (myView?.frame.size.height)!-150.0))
        weightTable.delegate = self
        weightTable.dataSource = self
        myView?.addSubview(weightTable)
        backView?.addSubview(myView!)
        window.addSubview(backView!)
        
        //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        //
        //        backView?.addGestureRecognizer(tap)
        //myView?.isHidden = true
    }
    
    func createOrder(){
        let params: String
        print(addressId)
        params =  "shipping_id=\(addressId!)&payment_mode=COD"
        
        let urlString = BASE_URL + "user/order/create?" + params
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
                            var data: NSDictionary?
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            if (!(error!)){
                                data = result["data"] as? NSDictionary
                                print("data:- \(data!)")
                                self.orderId = data!["order_id"] as! Int
                                self.transactionId = "\(data!["tid"])"
                                let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
                                
                                nextViewController.orderId = self.orderId!
                                self.navigationController?.pushViewController(nextViewController, animated: true)
                            }else if ((error!)){
                                
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cashDeliveryBtn.addTarget(self, action: #selector(self.cashClicked), for: .touchUpInside)
        onlinePaymentBtn.addTarget(self, action: #selector(self.onlineClicked), for: .touchUpInside)
        
        isChecked = true
        isChecked1 = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        button1 = UIButton.init(type: .custom)
        button1?.setImage(UIImage.init(named: "back_Icon"), for: UIControlState.normal)
        button1?.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        button1?.addTarget(self, action:#selector(self.backAction), for:.touchUpInside)
        self.navigationController?.navigationBar.addSubview(button1!)
        self.navigationItem.title = "Build Order"
        self.navigationItem.hidesBackButton = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
        self.getAmount()
    }
    
    @objc func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        button1?.isHidden = true
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
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                let subTotal: Float = data?.value(forKey: "total") as! Float
                                let shipping: Float = data?.value(forKey: "shipping") as! Float
                                let total: Float = subTotal + shipping
                                self.priceLabel.text = "\(subTotal)"
                                self.shippingPriceLabel.text = "\(shipping)"
                                self.paaybleAmtLabel.text = "\(total)"
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
    
    @objc func cashClicked() {
        isChecked = true
        isChecked1 = false
    }
    
    @objc func onlineClicked() {
        isChecked = false
        isChecked1 = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
