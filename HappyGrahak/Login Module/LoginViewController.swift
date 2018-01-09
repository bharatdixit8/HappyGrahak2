//
//  LoginViewController.swift
//  HappyGrahak
//
//  Created by IOS on 17/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class LoginViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var forgotBtn: UIButton!
    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var userNameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    var otpText: String?
    
    var myCarts: [MyCart] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        forgotBtn.contentHorizontalAlignment = .right
        signUpBtn.contentHorizontalAlignment = .left
        userNameField.delegate = self
        passwordField.delegate = self
        userNameField.attributedPlaceholder = NSAttributedString(string: "User Name",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        loginBtn.layer.cornerRadius = 5
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        loginBtn.addTarget(self, action: #selector(self.loadLogin), for: UIControlEvents.touchUpInside)
        let button1 = UIButton.init(type: .custom)
        button1.setImage(UIImage.init(named: "back_Icon"), for: UIControlState.normal)
        button1.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        self.backBtn.addTarget(self, action:#selector(self.backActions), for:.touchUpInside)
        let barButton1 = UIBarButtonItem.init(customView: button1)
        self.navigationItem.leftBarButtonItem = barButton1
        self.navigationItem.title = "Login"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        scroll.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField==passwordField {
            scroll.setContentOffset(CGPoint(x: 0, y: 120), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func backAction(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
    
    @objc func backActions() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func loadLogin() -> Void {
        if((userNameField.text!.characters.count)>0){
            if ((passwordField.text!.characters.count)>0){
                startAnimating(view: self.view)
                self.getImmovableAssetInfo()
            }else{
                let alert = UIAlertController(title: "Empty Field", message: "Please enter E-mail Id/Mobile No.", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Empty Field", message: "Please enter Password", preferredStyle: UIAlertControllerStyle.alert)
    
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func getImmovableAssetInfo(){
        let params: String
        
        params =  "username=\(userNameField.text!)&password=\(passwordField.text!)"
        
        let urlString = BASE_URL + "auth?" + params
        print(urlString)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        
        let request = URLRequest(url: url! as URL)
        
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
                            var token: String?
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            //token = result["token"] as? String
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            //print("Token:- \(token!)")
                            if (!(error!)){
                                //UserDefaults.standard.set(token, forKey: "token")
                                //self.verifyOTP()
                                self.showGetUserName()
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
    
    func showGetUserName() {
        
        let alertController = UIAlertController(title: "HAPPY GRAHAK", message: "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            alert -> Void in
            let fNameField = alertController.textFields![0] as UITextField
            //let lNameField = alertController.textFields![1] as UITextField
            
            if fNameField.text != "" {
                self.otpText = fNameField.text
                self.verifyOTP(otp: self.otpText!)
            } else {
                let errorAlert = UIAlertController(title: "Error", message: "Please Enter OTP", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                    alert -> Void in
                    self.present(alertController, animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Enter OTP"
            textField.textAlignment = .center
        })
        
        self.present(alertController, animated: true, completion: nil)
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
                                //UserDefaults.standard.set(data!["name"], forKey: "userName")
                                UserDefaults.standard.set(data!["mobile"], forKey: "mobile")
                                UserDefaults.standard.set(data!["avatar"], forKey: "img")
                                UserDefaults.standard.set(data!["cart_count"], forKey: "cartCount")
                                
                                var myCarts: [MyCart] = []
                                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                                myCarts = try! context.fetch(MyCart.fetchRequest())
                                
                                if (myCarts.count>0){
                                    self.sendMyOfflineCart(_token: _token)
                                } else {
                                    let viewController = SideBarRootViewController(nibName: "SideBarRootViewController_iPhone", bundle: nil)
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                }
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
    
    @objc func verifyOTP(otp: String){
        let params: String
        
        params =  "username=\(userNameField.text!)&password=\(passwordField.text!)&otp=\(otp)"
        
        let urlString = BASE_URL + "auth?" + params
        print(urlString)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        
        var request = URLRequest(url: url! as URL)
        
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
                            var token: String?
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            token = result["token"] as? String
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            //print("Token:- \(token!)")
                            if (!(error!)){
                                UserDefaults.standard.set(token, forKey: "token")
                                self.sendToken(_token: token!)
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
    
    @objc func sendMyOfflineCart(_token: String){
        
        let cartArray: NSMutableArray = NSMutableArray()
        let params: String
        
        do{
            let allCarts = try context.fetch(MyCart.fetchRequest())
            myCarts = allCarts as! [MyCart]
            
            for cart in myCarts {
                let dict: NSMutableDictionary = NSMutableDictionary()
                dict.setObject(cart.productId, forKey: "prodcut_id" as NSCopying)
                dict.setObject(cart.invt_id, forKey: "invent_id" as NSCopying)
                dict.setObject(cart.quantity, forKey: "qty" as NSCopying)
                cartArray.add(dict)
            }
        }catch{
            print("Fetching Failed")
        }
//        let realm = try! Realm()
//        let myOrders = realm.objects(OrderDetails.self)
//        let allOrders = myOrders.sorted(by: { $0.cartId < $1.cartId })
//        //let str: String = "qty"
//        for object in allOrders {
//        
//            let dict: NSMutableDictionary = NSMutableDictionary()
//            dict.setObject(object.productId, forKey: "prodcut_id" as NSCopying)
//            dict.setObject(object.invtId, forKey: "invent_id" as NSCopying)
//            dict.setObject(object.productQuantity, forKey: "qty" as NSCopying)
//            cartArray.add(dict)
//        }
        //let dict: NSDictionary = NSDictionary.init(object: cartArray, forKey: "data" as NSCopying)
        params = self.notPrettyString(from: cartArray)!
        
        print(params)
        
        let urlString = BASE_URL + "user/shipping/save-cart?" + params
        print(urlString)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        print(url)
        
        var request = URLRequest(url: url! as URL)
        request.addValue("Bearer \(_token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        //request.httpBody = jsonString.data(using: String.Encoding.utf8, allowLossyConversion:true)
        BACKGROUND_QUEUE {

            API.startRequest(request: request, method: "POST",type: 0, params: params, completion: { (response:URLResponse?, result:AnyObject?, error:Error?, responseStatus:String?) in

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

                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray

                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            //print("Token:- \(token!)")
                            if (!(error!)){
                                let viewController = SideBarRootViewController(nibName: "SideBarRootViewController_iPhone", bundle: nil)
                                self.navigationController?.pushViewController(viewController, animated: true)
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
    
    func notPrettyString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
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
