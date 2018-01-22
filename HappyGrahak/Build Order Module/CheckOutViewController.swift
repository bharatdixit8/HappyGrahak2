//
//  CheckOutViewController.swift
//  HappyGrahak
//
//  Created by IOS on 14/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class CheckOutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let kCellIdentifier = "Cell"
    var totalAmt: String?
    var addressIdArray: NSMutableArray = NSMutableArray()
    var addressArray: NSMutableArray = NSMutableArray()
    var countryArray: NSMutableArray = NSMutableArray()
    var nameArray: NSMutableArray = NSMutableArray()
    var mobileArray: NSMutableArray = NSMutableArray()
    var emailArray: NSMutableArray = NSMutableArray()
    var stateArray: NSMutableArray = NSMutableArray()
    var cityArray: NSMutableArray = NSMutableArray()
    var pinArray: NSMutableArray = NSMutableArray()
    var flagArray: NSMutableArray = NSMutableArray()
    @IBOutlet var totalLable: UILabel!
    @IBOutlet var addressList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func checkoutClicked(_ sender: Any) {
        self.verifyAddress()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addressList.reloadData()
        totalLable.text = "Total: \(totalAmt!)"
        let button1 = UIButton.init(type: .custom)
        button1.setImage(UIImage.init(named: "back_Icon"), for: UIControlState.normal)
        button1.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        button1.addTarget(self, action:#selector(self.backAction), for:.touchUpInside)
        let barButton1 = UIBarButtonItem.init(customView: button1)
        self.navigationItem.leftBarButtonItem = barButton1
        self.navigationItem.title = "Delivery Address"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
        
        let button: UIButton = self.navigationController?.navigationBar.viewWithTag(2001) as! UIButton
        button.isHidden = true
        let label: UILabel = self.navigationController?.navigationBar.viewWithTag(1001) as! UILabel
        label.isHidden = true
        self.getImmovableAssetInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (addressArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Address"
        var cell: AddressTableViewCell! = self.addressList.dequeueReusableCell(withIdentifier: identifier) as? AddressTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AddressTableViewCell
        }
        self.addressList.separatorStyle = .none
        cell.tag = indexPath.row
        cell.selectionStyle = .none
        cell.editBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        cell.addressLabel.text = addressArray[indexPath.row] as! String
        cell.descriptionLabel.text = "\(cityArray[indexPath.row] as! String), \(stateArray[indexPath.row] as! String), \(countryArray[indexPath.row] as! String), \(pinArray[indexPath.row] as! String)"
        cell.editBtn.addTarget(self, action: #selector(self.editBtnClicked(sender:)), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(self.deleteBtnClicked(sender:)), for: .touchUpInside)
        if flagArray.object(at: indexPath.row) as! Int == 1 {
            cell.isChecked = true
        }else{
            cell.isChecked = false
        }
        return cell!
    }
    
    @objc func deleteBtnClicked(sender: UIButton) {
        
        let alert = UIAlertController(title: "Are you sure?", message: "Do you Want to remove this address?", preferredStyle:  UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.deleteShippingAddress(sender: sender)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default)
        // add an action (button)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func editBtnClicked(sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure?", message: "Do you Want to edit this address?", preferredStyle:  UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
            nextViewController.addressId = self.addressIdArray.object(at: sender.tag) as! Int
            nextViewController.name = self.nameArray.object(at: sender.tag) as! String
            nextViewController.mobile = self.mobileArray.object(at: sender.tag) as! String
            nextViewController.email = self.emailArray.object(at: sender.tag) as! String
            nextViewController.address = self.addressArray.object(at: sender.tag) as! String
            nextViewController.country = self.countryArray.object(at: sender.tag) as! String
            nextViewController.state = self.stateArray.object(at: sender.tag) as! String
            nextViewController.city = self.cityArray.object(at: sender.tag) as! String
            nextViewController.pincode = self.pinArray.object(at: sender.tag) as! String
            self.present(nextViewController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default)
        // add an action (button)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indicesPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indicesPath!) as! UITableViewCell
        let portableArray = flagArray
        flagArray = NSMutableArray()
        //print(flagArray)
        for i in portableArray {
            let flag = i as! Int
            print(portableArray.index(of: flag))
            if portableArray.index(of: flag) == currentCell.tag {
                flagArray.add(1)
            }else{
                flagArray.add(portableArray.object(at: portableArray.index(of: flag)) as! Int + 1)
            }
        }
        print(flagArray)
        self.addressList.reloadData()
    }
    
    @IBAction func addAddressClicked(_ sender: Any) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    func getImmovableAssetInfo(){
        let params: String
        
        params =  ""
        
        let urlString = BASE_URL + "user/shipping/get-all?" + params
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
                            self.addressArray = NSMutableArray()
                            self.countryArray = NSMutableArray()
                            self.stateArray = NSMutableArray()
                            self.cityArray = NSMutableArray()
                            self.pinArray = NSMutableArray()
                            self.addressIdArray = NSMutableArray()
                            self.nameArray = NSMutableArray()
                            self.mobileArray = NSMutableArray()
                            self.emailArray = NSMutableArray()
                            self.flagArray = NSMutableArray()
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            if (!(error!)){
                                data = result["data"] as? NSArray
                                print("data:- \(data!)")
                                if data?.count==0 {
                                    self.addressList.isHidden = true
                                }
                                for da in data! {
                                    let object = da as? NSDictionary
                                    let state = object!["state"] as? NSDictionary
                                    let city = object!["city"] as? NSDictionary
                                    self.addressArray.add(object!["address"])
                                    self.countryArray.add(object!["country"])
                                    if state != nil {
                                        self.stateArray.add(state!["name"])
                                    }else{
                                        self.stateArray.add("Select State")
                                    }
                                    if city != nil {
                                        self.cityArray.add(city!["name"])
                                    }else{
                                        self.cityArray.add("Select City")
                                    }
                                    self.pinArray.add(object!["pin"])
                                    self.addressIdArray.add(object!["id"])
                                    self.nameArray.add(object!["name"])
                                    self.mobileArray.add(object!["mobile"])
                                    self.emailArray.add(object!["email"])
                                    self.flagArray.add((data?.index(of: object))!+1)
                                }
                                self.addressList.reloadData()
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
                            print("SingleAddedUser RESPONSE:- \(result!)")
                            
                            let result = result as! NSDictionary
                            var error: Bool?
                            var message: NSArray?
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            if ((error!)){
                                let alert = UIAlertController(title: "Already Registered", message: "Your E-mail Id and Mobile No. already registered with us", preferredStyle:  UIAlertControllerStyle.alert)
                                
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                    
                                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                    self.navigationController?.pushViewController(nextViewController, animated: true)
                                }
                                // add an action (button)
                                alert.addAction(okAction)
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
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
    
    func deleteShippingAddress(sender: UIButton){
        let params: String
        
        params =  "add_id=\(addressIdArray[sender.tag])"
        
        let urlString = BASE_URL + "user/shipping/delete-address?" + params
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
                            self.addressArray = NSMutableArray()
                            self.countryArray = NSMutableArray()
                            self.stateArray = NSMutableArray()
                            self.cityArray = NSMutableArray()
                            self.pinArray = NSMutableArray()
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            if (!(error!)){
                                let alert = UIAlertController(title:"Address Deleted", message: "Address Deleted Successfully", preferredStyle: UIAlertControllerStyle.alert)
                                
                                // add an action (button)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    self.getImmovableAssetInfo()
                                }
                                
                                alert.addAction(okAction)
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
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
                            print("SingleAddedUser RESPONSE:- \(result!)")
                            
                            let result = result as! NSDictionary
                            var error: Bool?
                            var message: NSArray?
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            if ((error!)){
                            }
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
    
    func verifyAddress(){
        let params: String
        
        params =  "shipping_id=\(addressIdArray[flagArray.index(of: 1)])"
        
        let urlString = BASE_URL + "user/order/verify-pin?" + params
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
                            //var data: NSArray?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            if (!(error!)){
                                let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "BuildOrderViewController") as! BuildOrderViewController
                                let indeces = self.flagArray.index(of: 1)
                                print(self.addressIdArray)
                                nextViewController.addressId = "\(self.addressIdArray.object(at: indeces))"
                                self.navigationController?.pushViewController(nextViewController, animated: true)
                            }else if ((error!)){
                                let alert = UIAlertController(title:"Invalid Pincode", message: "Sorry! Delivery is not possible on this location", preferredStyle: UIAlertControllerStyle.alert)
                                
                                // add an action (button)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    self.getImmovableAssetInfo()
                                }
                                
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
                            print("SingleAddedUser RESPONSE:- \(result!)")
                            
                            let result = result as! NSDictionary
                            var error: Bool?
                            var message: NSArray?
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            if ((error!)){
                            }
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
    
    //user/order/verify-pin
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
