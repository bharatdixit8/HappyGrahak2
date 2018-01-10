//
//  SignUpViewController.swift
//  HappyGrahak
//
//  Created by IOS on 17/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var mobileField: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var referralField: UITextField!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var acceptBtn: UIButton!
    let checkedImage = UIImage(named: "check_icon")! as UIImage
    let uncheckedImage = UIImage(named: "uncheck_icon")! as UIImage
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.acceptBtn.setImage(checkedImage, for: UIControlState.normal)
            } else {
                self.acceptBtn.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.getImmovableAssetInfo()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isChecked = false
        scroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        mobileField.delegate = self
        password.delegate = self
        referralField.delegate = self
        signUpBtn.layer.cornerRadius = 5
        
        mobileField.attributedPlaceholder = NSAttributedString(string: "Mobile Number",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        password.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        referralField.attributedPlaceholder = NSAttributedString(string: "Reffer Id",
                                                            attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        signUpBtn .addTarget(self, action: #selector(self.loadSignUp), for: UIControlEvents.touchUpInside)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let button1 = UIButton.init(type: .custom)
        button1.setImage(UIImage.init(named: "back_Icon"), for: UIControlState.normal)
        button1.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        button1.addTarget(self, action:#selector(self.backAction), for:.touchUpInside)
        let barButton1 = UIBarButtonItem.init(customView: button1)
        self.navigationItem.leftBarButtonItem = barButton1
        self.navigationItem.title = "Sign Up"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        scroll.addGestureRecognizer(tap)
        
        self.acceptBtn.addTarget(self, action: #selector(checkClicked), for: .touchUpInside)
    }
    
    @objc func checkClicked() {
        if isChecked {
            isChecked = false
        }else{
            isChecked = true
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == password||textField==referralField{
            scroll.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
//    {
//        if textField == mobileField{
//            if textField.text?.characters.count == 10{
//                return false
//            }
//        }
//        return true
//    }
    
    @objc func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func VALIDATE_EMAIL(_ email: NSString) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    @objc func loadSignUp() -> Void {
                        if ((mobileField.text!.characters.count)>0){
                            if ((mobileField.text!.characters.count)==10){
                                if ((password.text!.characters.count)>0){
                                    if isChecked{
                                        self.getImmovableAssetInfo()
                                    } else {
                                        self.alertViewPopup("Accept Conditions", "Please accept terms and conditions")
                                    }
                                }else{
                                    self.alertViewPopup("Empty Field", "Please enter Password")
                                }
                            }else{
                                self.alertViewPopup("Mobile No. not Valid", "Please enter valid Mobile No.")
                            }
                        }else{
                            self.alertViewPopup("Empty Field", "Please enter Mobile No.")
                        }
    }
   
    @objc func alertViewPopup(_ title: String, _ message: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func getImmovableAssetInfo(){

        let params: String
        
        params =  "mobile=\(mobileField.text!)&password=\(password.text!)&refer_id=\(referralField.text!)&accept=\(isChecked)"
        
        let urlString = BASE_URL + "register?" + params
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
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            if (!(error!)){
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                                
                                nextViewController.mobile = self.mobileField.text
                                nextViewController.password = self.password.text
                                nextViewController.referId = self.referralField.text
                                nextViewController.flag = false
                                nextViewController.checked = self.isChecked
                                self.navigationController?.pushViewController(nextViewController, animated: true)
                            }else if ((error!)){
                                let alert = UIAlertController(title: "HAPPY GRAHAK", message: message?[0] as? String, preferredStyle:  UIAlertControllerStyle.alert)
                                
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
//                                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//                                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                                    self.navigationController?.pushViewController(nextViewController, animated: true)
                                }
                                // add an action (button)
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
    
    //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
   // let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
  //  self.navigationController?.pushViewController(nextViewController, animated: true)

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
