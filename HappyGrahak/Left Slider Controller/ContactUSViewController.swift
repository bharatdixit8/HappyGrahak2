//
//  ContactUSViewController.swift
//  HappyGrahak
//
//  Created by IOS on 19/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class ContactUSViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    var button1: UIButton?
    
    @IBOutlet var messageTextView: UITextView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var mobileField: UITextField!
    @IBOutlet var scroller: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.delegate = self
        emailField.delegate = self
        mobileField.delegate = self
        messageTextView.delegate = self
        messageTextView.layer.borderWidth = 2.0
        messageTextView.layer.borderColor = UIColor.black.cgColor
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        button1 = UIButton.init(type: .custom)
        button1?.setImage(UIImage.init(named: "back_Icon"), for: UIControlState.normal)
        button1?.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        button1?.addTarget(self, action:#selector(self.backAction), for:.touchUpInside)
        self.navigationController?.navigationBar.addSubview(button1!)
        self.navigationItem.title = "Contact Us"
        self.navigationItem.hidesBackButton = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        scroller.addGestureRecognizer(tap)
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
        if textField == mobileField{
            scroller.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scroller.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text=="Message"){
            textView.text = ""
            textView.textColor = UIColor.black
        }
        scroller.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text==""){
            textView.text = "Message"
            textView.textColor = UIColor.lightGray
        }
        scroller.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        button1?.isHidden = true
    }
    
    @objc func backAction() -> Void {
        let viewController = SideBarRootViewController(nibName: "SideBarRootViewController_iPhone", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func VALIDATE_EMAIL(_ email: NSString) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    @objc func alertViewPopup(_ title: String, _ message: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        if((nameField.text!.characters.count)>0){
            if ((nameField.text!.characters.count)>3){
                if ((emailField.text!.characters.count)>0){
                    if(self.VALIDATE_EMAIL(emailField.text! as NSString)){
                        if ((mobileField.text!.characters.count)>0){
                            if ((mobileField.text!.characters.count)==10){
                                if ((messageTextView.text!.characters.count)>0){
                                    if (messageTextView.text != "Message"){
                                        self.getImmovableAssetInfo()
                                    }else{
                                        self.alertViewPopup("Query not valid", "Please enter valid Query")
                                    }
                                }else{
                                    self.alertViewPopup("Empty Field", "Please enter your query")
                                }
                            }else{
                                self.alertViewPopup("Mobile No. not Valid", "Please enter valid Mobile No.")
                            }
                        }else{
                            self.alertViewPopup("Empty Field", "Please enter Mobile No.")
                        }
                    }else{
                        self.alertViewPopup("E-mail Id not Valid", "Please enter valid E-mail Id")
                    }
                }else{
                    self.alertViewPopup("Empty Field", "Please enter E-mail Id")
                }
            }else{
                self.alertViewPopup("User Name not valid", "Please enter valid User Name")
            }
        }else{
            self.alertViewPopup("Empty Field", "Please enter User Name")
        }
    }
    
    @objc func getImmovableAssetInfo(){
        
        let params: String
        
        params =  "name=\(nameField.text!)&email=\(emailField.text!)&mobile=\(mobileField.text!)&message=\(messageTextView.text!)"
        
        let urlString = BASE_URL + "contact-create?" + params
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
                                let viewController = SideBarRootViewController(nibName: "SideBarRootViewController_iPhone", bundle: nil)
                                self.navigationController?.pushViewController(viewController, animated: true)

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
