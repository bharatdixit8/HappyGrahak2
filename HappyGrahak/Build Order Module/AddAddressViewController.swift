//
//  AddAddressViewController.swift
//  HappyGrahak
//
//  Created by IOS on 15/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class AddAddressViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var data: String?
    var data2: String?
    var pickerView: UIPickerView?
    var pickerView1: UIPickerView?
    var doneButton: UIBarButtonItem?
    var doneButton1: UIBarButtonItem?
    var cancelButton: UIBarButtonItem?
    var cancelButton1: UIBarButtonItem?
    var stateNameArray: NSMutableArray?
    var stateIdArray: NSMutableArray?
    var cityNameArray: NSMutableArray?
    var cityIdArray: NSMutableArray?
    var addressId: Int?
    var name: String?
    var mobile: String?
    var email:  String?
    var address: String?
    var country: String?
    var state: String?
    var city:  String?
    var pincode: String?
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var mobileField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var addressField: UITextField!
    @IBOutlet var countryField: UITextField!
    @IBOutlet var stateField: UITextField!
    @IBOutlet var cityField: UITextField!
    @IBOutlet var pincodeField: UITextField!
    @IBOutlet var scroll: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if addressId != nil {
            nameField.text = name
            mobileField.text = mobile
            emailField.text = email
            addressField.text = address
            countryField.text = country
            stateField.text = state
            cityField.text = city
            pincodeField.text = pincode
        }
        countryField.text = " India"
        self.addPickerToState()
        self.addPickerToCity()
        self.getAllStates(countryId: "101")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        scroll.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == pincodeField {
            scroll.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        } else if textField==self.stateField {
            if stateNameArray?.count != 0 {
                self.stateField.becomeFirstResponder()
            }
        } else if textField==self.cityField {
            if cityNameArray?.count != 0 {
                self.cityField.becomeFirstResponder()
            }
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
    
    func addPickerToState() {
        pickerView = UIPickerView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        pickerView?.showsSelectionIndicator = true;
        pickerView?.dataSource = self
        pickerView?.delegate = self
        
        // set change the inputView (default is keyboard) to UIPickerView
        self.stateField.inputView = pickerView;
        
        // add a toolbar with Cancel & Done button
        let toolBar: UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar.barStyle = UIBarStyle.blackOpaque;
        
        doneButton = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(self.doneTouched(sender:)))
        doneButton?.tintColor = UIColor.white
        cancelButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(self.cancelTouched(sender:)))
        cancelButton?.tintColor = UIColor.white
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
        toolBar.setItems([cancelButton!, flexibleSpace, doneButton!], animated: true)
        // the middle button is to make the Done button align to right
        self.stateField.inputAccessoryView = toolBar;
    }
    
    func addPickerToCity() {
        pickerView1 = UIPickerView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        pickerView1?.showsSelectionIndicator = true;
        pickerView1?.dataSource = self
        pickerView1?.delegate = self
        
        // set change the inputView (default is keyboard) to UIPickerView
        self.cityField.inputView = pickerView1;
        
        // add a toolbar with Cancel & Done button
        let toolBar: UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar.barStyle = UIBarStyle.blackOpaque;
        
        doneButton1 = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(self.doneTouched(sender:)))
        doneButton1?.tintColor = UIColor.white
        cancelButton1 = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(self.cancelTouched(sender:)))
        cancelButton1?.tintColor = UIColor.white
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
        toolBar.setItems([cancelButton1!, flexibleSpace, doneButton1!], animated: true)
        // the middle button is to make the Done button align to right
        self.cityField.inputAccessoryView = toolBar;
    }
    
    @objc func cancelTouched(sender: UIBarButtonItem)
    {
        if sender==cancelButton1 {
            // hide the picker view
            self.cityField.text = cityNameArray?.object(at: 0) as! String
            self.cityField.resignFirstResponder()
        } else {
            // hide the picker view
            self.stateField.text = stateNameArray?.object(at: 0) as! String
            self.stateField.resignFirstResponder()
        }
        
    }
    @objc func doneTouched(sender: UIBarButtonItem)
    {
        if sender==doneButton1 {
            // hide the picker view
            if (data2 != nil) {
                self.cityField.text = data2
                let index: Int = (cityNameArray?.index(of: data2))!
                self.cityField.tag = cityIdArray![index] as! Int
                self.cityField.resignFirstResponder()
            } else {
                self.cityField.text = cityNameArray?[0] as! String
                self.cityField.tag = cityIdArray![0] as! Int
                self.cityField.resignFirstResponder()
            }
        } else {
            // hide the picker view
            if (data != nil) {
                self.stateField.text = data
                self.cityField.text = ""
                let index: Int = (stateNameArray?.index(of: data))!
                self.stateField.tag = stateIdArray![index] as! Int
                let state_id: String = "\(stateIdArray![index])"
                self.getAllCities(stateId: state_id)
                self.stateField.resignFirstResponder()
            } else {
                self.stateField.text = stateNameArray?.object(at: 0) as! String
                self.cityField.text = ""
                //let index: Int = (stateNameArray?.index(of: data))!
                self.stateField.tag = stateIdArray![0] as! Int
                let state_id: String = "\(stateIdArray![0])"
                self.getAllCities(stateId: state_id)
                self.stateField.resignFirstResponder()
            }
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView==pickerView1 {
            return (self.cityIdArray?.count)!
        } else {
            return (self.stateIdArray?.count)!
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView==pickerView1 {
            let item: String = self.cityNameArray?.object(at:row) as! String
            return item;
        } else {
            let item: String = self.stateNameArray?.object(at:row) as! String
            return item;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView==pickerView1 {
            self.cityField.text = cityNameArray?.object(at: row) as! String
            data2 = cityNameArray?.object(at: row) as! String
        } else {
            self.stateField.text = stateNameArray?.object(at: row) as! String
            data = stateNameArray?.object(at: row) as! String
        }
    }
    
    @objc func getAllStates(countryId: String){
        var params: String = ""
        params =  "country_id=\(countryId)"
        
        
        let urlString = BASE_URL + "state-list?" + params
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
                            self.stateNameArray = NSMutableArray()
                            self.stateIdArray = NSMutableArray()
                            var  data: NSArray?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            
                            if (!(error!)){
                                data = result["data"] as? NSArray
                                for index in data! {
                                    let object = index as! NSDictionary
                                    self.stateNameArray?.add(object.value(forKey: "name"))
                                    self.stateIdArray?.add(object.value(forKey: "id"))
                                }
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
    
    @objc func getAllCities(stateId: String){
        var params: String = ""
        params =  "state_id=\(stateId)"
        
        
        let urlString = BASE_URL + "city-list?" + params
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
                            self.cityNameArray = NSMutableArray()
                            self.cityIdArray = NSMutableArray()
                            var  data: NSArray?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            
                            if (!(error!)){
                                data = result["data"] as? NSArray
                                for index in data! {
                                    let object = index as! NSDictionary
                                    self.cityNameArray?.add(object.value(forKey: "name"))
                                    self.cityIdArray?.add(object.value(forKey: "id"))
                                }
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
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func submitAddressClicked(_ sender: Any) {
        if((nameField.text!.characters.count)>0){
            if ((nameField.text!.characters.count)>3){
                if ((emailField.text!.characters.count)>0){
                    if(self.VALIDATE_EMAIL(emailField.text! as NSString)){
                        if ((mobileField.text!.characters.count)>0){
                            if ((mobileField.text!.characters.count)==10){
                                if ((addressField.text!.characters.count)>0){
                                    if ((countryField.text!.characters.count)>0){
                                        if ((stateField.text!.characters.count)>0){
                                            if ((cityField.text!.characters.count)>0){
                                                if ((pincodeField.text!.characters.count)>0){
                                                    if((pincodeField.text!.characters.count)==6){
                                                        if addressId != nil {
                                                            self.updateAddress(id: addressId!)
                                                        }else{
                                                            self.getImmovableAssetInfo()
                                                        }
                                                    }else{
                                                        self.alertViewPopup("Pincode not Valid", "Please enter valid Pincode")
                                                    }
                                                }else{
                                                    self.alertViewPopup("Empty Field", "Please enter Pincode")
                                                }
                                            }else{
                                                self.alertViewPopup("Empty Field", "Please enter City")
                                            }
                                        }else{
                                            self.alertViewPopup("Empty Field", "Please enter State")
                                        }
                                    }else{
                                        self.alertViewPopup("Empty Field", "Please enter Country")
                                    }
                                }else{
                                    self.alertViewPopup("Empty Field", "Please enter Address")
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
    
    func getImmovableAssetInfo(){
        let params: String
        
        params =  "name=\(nameField.text!)&mobile=\(mobileField.text!)&email=\(emailField.text!)&address=\(addressField.text!)&country=\(countryField.text!)&city=\(cityField.tag)&pin=\(pincodeField.text!)&status='1'&state=\(stateField.tag)"
        
        let urlString = BASE_URL + "user/shipping/add-address?" + params
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
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            if (!(error!)){
                                let alert = UIAlertController(title: "Congratulations!", message: "Address Added Successfully", preferredStyle:  UIAlertControllerStyle.alert)
                                
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    self.dismiss(animated: true, completion: nil)
                                }
                                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default)
                                // add an action (button)
                                alert.addAction(okAction)
                                alert.addAction(cancelAction)
                                
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
    
    func updateAddress(id: Int){
        let params: String
        
        params =  "id=\(id)&name=\(nameField.text!)&mobile=\(mobileField.text!)&email=\(emailField.text!)&address=\(addressField.text!)&country=\(countryField.text!)&city=\(cityField.tag)&pin=\(pincodeField.text!)&status='1'&state=\(stateField.tag)"
        
        let urlString = BASE_URL + "user/shipping/update-address?" + params
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
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            if (!(error!)){
                                let alert = UIAlertController(title: "Congratulations!", message: "Address Updated Successfully", preferredStyle:  UIAlertControllerStyle.alert)
                                
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    self.dismiss(animated: true, completion: nil)
                                }
                                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default)
                                // add an action (button)
                                alert.addAction(okAction)
                                alert.addAction(cancelAction)
                                
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
}


