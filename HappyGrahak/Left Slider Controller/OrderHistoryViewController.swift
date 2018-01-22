//
//  OrderHistoryViewController.swift
//  HappyGrahak
//
//  Created by IOS on 16/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class OrderHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var orderIdArray: NSMutableArray = NSMutableArray()
    var totalArray: NSMutableArray = NSMutableArray()
    var payModeArray: NSMutableArray = NSMutableArray()
    var statusArray: NSMutableArray = NSMutableArray()
    var lastStatusArray: NSMutableArray = NSMutableArray()
    var createdArray: NSMutableArray = NSMutableArray()
    var orderProductsArray: NSMutableArray = NSMutableArray()
    var button1: UIButton?
    @IBOutlet var historyList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getOrderHistory()
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
        self.navigationItem.title = "Order History"
        self.navigationItem.hidesBackButton = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        button1?.isHidden = true
    }

    @objc func backAction() -> Void {
        let viewController = SideBarRootViewController(nibName: "SideBarRootViewController_iPhone", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderIdArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "history"
        var cell: OrderHistoryTableViewCell! = self.historyList.dequeueReusableCell(withIdentifier: identifier) as? OrderHistoryTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "OrderHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? OrderHistoryTableViewCell
        }
        self.historyList.separatorStyle = .none
        cell.selectionStyle = .none
        cell.tag = orderIdArray.object(at: indexPath.row) as! Int
        cell.cancelBtn.tag = orderIdArray.object(at: indexPath.row) as! Int
        cell.orderIdLabel.text = "Order Id: \(orderIdArray.object(at: indexPath.row))"
        if (statusArray.object(at: indexPath.row) as! String)=="3" {
            
            cell.pendingLabel.isHidden = false
            cell.progressLabel.isHidden = true
            cell.dispatchLabel.isHidden = true
            cell.oFDelivery.isHidden = true
            cell.deliveredLabel.isHidden = true
            cell.progressImg.image = UIImage(named: "order_step1")

        } else if (statusArray.object(at: indexPath.row) as! String)=="4" {
            
            cell.pendingLabel.isHidden = true
            cell.progressLabel.isHidden = false
            cell.dispatchLabel.isHidden = true
            cell.oFDelivery.isHidden = true
            cell.deliveredLabel.isHidden = true
            cell.progressImg.image = UIImage(named: "order_step2")

        } else if (statusArray.object(at: indexPath.row) as! String)=="5" {
        
            cell.pendingLabel.isHidden = true
            cell.progressLabel.isHidden = true
            cell.dispatchLabel.isHidden = false
            cell.oFDelivery.isHidden = true
            cell.deliveredLabel.isHidden = true
            cell.progressImg.image = UIImage(named: "order_step3")

        } else if (statusArray.object(at: indexPath.row) as! String)=="6" {
            
            cell.pendingLabel.isHidden = true
            cell.progressLabel.isHidden = true
            cell.dispatchLabel.isHidden = true
            cell.oFDelivery.isHidden = false
            cell.deliveredLabel.isHidden = true
            cell.progressImg.image = UIImage(named: "order_step4")

        } else if (statusArray.object(at: indexPath.row) as! String)=="7" {
            
            cell.pendingLabel.isHidden = true
            cell.progressLabel.isHidden = true
            cell.dispatchLabel.isHidden = true
            cell.oFDelivery.isHidden = true
            cell.deliveredLabel.isHidden = false
            cell.progressImg.image = UIImage(named: "order_step5")
            cell.cancelBtn.isHidden = true
        } else {
            
            cell.pendingLabel.isHidden = true
            cell.progressLabel.isHidden = true
            cell.dispatchLabel.isHidden = true
            cell.oFDelivery.isHidden = true
            cell.deliveredLabel.isHidden = false
            cell.deliveredLabel.text = "Canceled"
            cell.deliveredLabel.textColor = UIColor.red
            if (self.lastStatusArray.object(at: indexPath.row) as! String) == "3" {
                cell.progressImg.image = UIImage(named: "cancel_step1")
            }else if (self.lastStatusArray.object(at: indexPath.row) as! String) == "4" {
                cell.progressImg.image = UIImage(named: "cancel_step2")
            }else if (self.lastStatusArray.object(at: indexPath.row) as! String) == "5" {
                cell.progressImg.image = UIImage(named: "cancel_step3")
            }else if (self.lastStatusArray.object(at: indexPath.row) as! String) == "6" {
                cell.progressImg.image = UIImage(named: "cancel_step4")
            }
            cell.cancelBtn.isHidden = true
        }
        cell.layer.cornerRadius = 10.0
        cell.amountLabel.text = " Total Amount: Rs. \(totalArray.object(at: indexPath.row) as! String)"
        cell.cancelBtn.addTarget(self, action: #selector(self.cancelOrder(sender:)), for: .touchUpInside)
        //cell.paymentModeLabel.text = payModeArray.object(at: indexPath.row) as! String
        cell.timerLabel.text = createdArray.object(at: indexPath.row) as! String
        cell.itemsOrderedList.text = (self.orderProductsArray.object(at: indexPath.row) as! NSArray).componentsJoined(by: ", ")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
        nextViewController.orderId = orderIdArray.object(at: indexPath.row) as! Int
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155.0
    }
    
    @objc func cancelOrder(sender: UIButton){
        let params: String
        params = "order_id=\(sender.tag)&value=4"
        let urlString = BASE_URL + "user/order/cancel?" + params
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
                            
                            var  data: NSArray?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSArray
                            if (!(error!)){
                                self.getOrderHistory()
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
    
    @objc func getOrderHistory(){
        let params: String
        params = ""
        let urlString = BASE_URL + "user/order?" + params
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
                            
                            let result = result as! NSDictionary
                            var error: Bool?
                            var message: NSArray?
                            var cartArray: NSArray?
                            
                            var cartDataArray: NSMutableArray = NSMutableArray()
                            var  data: NSArray?
                            self.orderIdArray = NSMutableArray()
                            self.totalArray = NSMutableArray()
                            self.payModeArray = NSMutableArray()
                            self.statusArray = NSMutableArray()
                            self.createdArray = NSMutableArray()
                            self.lastStatusArray = NSMutableArray()
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSArray
                            if (!(error!)){
                                for i in data! {
                                    let object = i as! NSDictionary
                                    self.orderIdArray.add(object["id"])
                                    self.totalArray.add(object["total"])
                                    self.payModeArray.add(object["pay_mode"])
                                    self.statusArray.add(object["status"])
                                    self.createdArray.add(object["created_at"])
                                    self.lastStatusArray.add(object["last_status"])
                                    var productNameArray: NSMutableArray = NSMutableArray()
                                    cartArray = object["cart_data"] as! NSArray
                                    for j in cartArray! {
                                        let cartItem = j as! NSDictionary
                                        productNameArray.add((cartItem["product"] as! NSDictionary)["title"] as! String)
                                    }
                                    cartDataArray.add(cartArray)
                                    self.orderProductsArray.add(productNameArray)
                                }
                                
                                print(self.orderProductsArray)
                                self.historyList.reloadData()
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
