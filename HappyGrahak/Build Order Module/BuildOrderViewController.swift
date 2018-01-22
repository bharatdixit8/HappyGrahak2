//
//  BuildOrderViewController.swift
//  HappyGrahak
//
//  Created by IOS on 15/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class BuildOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

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
    var toggleBtn1: UIButton?
    var toggleBtn2: UIButton?
    var timeSlotTable: UITableView?
    var timeSlotArray: NSMutableArray = NSMutableArray()
    var flagArray: NSMutableArray = NSMutableArray()
    var typeSlot: Int?
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
    
    var isChecked2: Bool = false {
        didSet{
            if isChecked2 == true {
                self.toggleBtn1?.setImage(checkedImage, for: UIControlState.normal)
            } else {
                self.toggleBtn1?.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    
    var isChecked3: Bool = false {
        didSet{
            if isChecked3 == true {
                self.toggleBtn2?.setImage(checkedImage, for: UIControlState.normal)
            } else {
                self.toggleBtn2?.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        
        self.customPopup()
        isChecked2 = true
        isChecked3 = false
        self.getTimeSlot(row: 50, slotType: 1)
    }
    
    @objc func customPopup() -> Void {
        let window = UIApplication.shared.keyWindow!
        backView = UIView.init(frame: CGRect(x: 0, y: 0, width: window.frame.size.width, height: window.frame.size.height))
        myView = UIView.init(frame: CGRect(x: (backView?.frame.size.width)!/2-150.0, y: (backView?.frame.size.height)!/2-CGFloat((150+(4)*30)/2), width: 300.0, height: CGFloat(150+(4)*30)))
        myView?.layer.shadowOffset = CGSize(width: 0, height: 0)
        myView?.layer.shadowColor = UIColor.black.cgColor
        backView?.backgroundColor = UIColor.clear
        myView?.backgroundColor = UIColor.white
        myView?.layer.shadowRadius = 4
        myView?.layer.shadowOpacity = 0.25
        myView?.layer.masksToBounds = false;
        myView?.clipsToBounds = false;
        let deviderView = UIView.init(frame: CGRect(x: 0, y: 40, width: (myView?.frame.size.width)!, height: 2.0))
        deviderView.backgroundColor = UIColor.black
        myView?.addSubview(deviderView)
       
        toggleBtn1 = UIButton.init(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
        
        //toggleBtn1?.setImage(checkedImage, for: .normal)
        toggleBtn1?.addTarget(self, action: #selector(todayClicked), for: .touchUpInside)
        myView?.addSubview(toggleBtn1!)
        
        toggleBtn2 = UIButton.init(frame: CGRect(x: (myView?.frame.size.width)!/2+5, y: 5, width: 30, height: 30))
        //toggleBtn2?.setImage(uncheckedImage, for: .normal)
        toggleBtn2?.addTarget(self, action: #selector(tommorowClicked), for: .touchUpInside)
        myView?.addSubview(toggleBtn2!)
        
        let todayLabel = UILabel.init(frame: CGRect(x: 40, y: 5, width: (myView?.frame.size.width)!/2-40, height: 30))
        todayLabel.text = "Today"
        todayLabel.textColor = UIColor.black
        myView?.addSubview(todayLabel)
        
        let tommorowLabel = UILabel.init(frame: CGRect(x: (myView?.frame.size.width)!/2+40, y: 5, width: (myView?.frame.size.width)!/2-40, height: 30))
        tommorowLabel.text = "Tommorow"
        tommorowLabel.textColor = UIColor.black
        myView?.addSubview(tommorowLabel)
        
        timeSlotTable = UITableView.init(frame: CGRect(x: 0.0, y: 42.0, width: (myView?.frame.size.width)!, height: (myView?.frame.size.height)!-82.0))
        timeSlotTable?.delegate = self
        timeSlotTable?.dataSource = self
        myView?.addSubview(timeSlotTable!)
        
        let selectSlotBtn = UIButton.init(frame: CGRect(x: (myView?.frame.size.width)!/2-50.0, y: (myView?.frame.size.height)!-40.0, width: 100.0, height: 30.0))
        selectSlotBtn.setTitle("Select Slot", for: .normal)
        selectSlotBtn.setTitleColor(UIColor.init(red: 111.0/255.0, green: 168.0/255.0, blue: 22.0/255.0, alpha: 1), for: .normal)
        selectSlotBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        selectSlotBtn.addTarget(self, action: #selector(slotSelected), for: .touchUpInside)
        myView?.addSubview(selectSlotBtn)
        
        backView?.addSubview(myView!)
        window.addSubview(backView!)
    }
    
    @objc func slotSelected(){
        backView?.isHidden = true
        if self.flagArray.contains(true){
            let index: Int = self.flagArray.index(of: true)
            let timeSlot: String = self.timeSlotArray.object(at: index) as! String
            self.createOrder(slot: timeSlot)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timeSlotArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: TimeSlotTableViewCell! = self.timeSlotTable!.dequeueReusableCell(withIdentifier: "timeslot") as? TimeSlotTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "TimeSlotTableViewCell", bundle: nil), forCellReuseIdentifier: "timeslot")
            cell = tableView.dequeueReusableCell(withIdentifier: "timeslot") as? TimeSlotTableViewCell
        }
        cell.selectionStyle = .none
        print(self.flagArray.object(at: indexPath.row))
        cell.slotLabel.text = self.timeSlotArray.object(at: indexPath.row) as! String
        if (self.flagArray.object(at: indexPath.row) as! Bool){
            cell.slotBtn.setImage(checkedImage, for: .normal)
        }else{
            cell.slotBtn.setImage(uncheckedImage, for: .normal)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:TimeSlotTableViewCell? = tableView.cellForRow(at: indexPath) as! TimeSlotTableViewCell
        self.getTimeSlot(row: indexPath.row, slotType: typeSlot!)
//        self.flagArray.replaceObject(at: indexPath.row, with: true)
//        tableView.reloadData()
        //cell?.slotBtn.setImage(checkedImage, for: .normal)
    }
    
    func createOrder(slot: String){
        let params: String
        print(addressId)
        params =  "shipping_id=\(addressId!)&payment_mode=COD&drop_time=\(slot)"
        
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
                                var refreshAlert = UIAlertController(title: "HAPPY GRAHAK", message: message?[0] as! String, preferredStyle: UIAlertControllerStyle.alert)
                                
                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                }))
                                
                                self.present(refreshAlert, animated: true, completion: nil)
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
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
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
    
    @objc func todayClicked() {
        isChecked2 = true
        isChecked3 = false
        self.getTimeSlot(row: 50, slotType: 1)
    }
    
    @objc func tommorowClicked() {
        isChecked2 = false
        isChecked3 = true
        self.getTimeSlot(row: 50, slotType: 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTimeSlot(row: Int, slotType: Int){
        let params: String
        print(addressId)
        typeSlot = slotType
        params =  "slot_type=\(slotType)"
        
        let urlString = BASE_URL + "time-slot?" + params
        print(urlString)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        
        var request = URLRequest(url: url! as URL)
//        let token: String = UserDefaults.standard.value(forKey:"token") as! String
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
                            self.timeSlotArray = NSMutableArray()
                            self.flagArray = NSMutableArray()
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            if (!(error!)){
                                data = result["data"] as? NSArray
                                print("data:- \(data!)")
                                if data!.count > 0 {
                                    for i in data! {
                                        let object = i as! NSDictionary
                                        self.timeSlotArray.add(object.value(forKey: "name"))
                                        self.flagArray.add(false)
                                    }
                                }
                                if row != 50{
                                    self.flagArray.replaceObject(at: row, with: true)
                                }
                                self.timeSlotTable?.reloadData()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
