//
//  ProfileViewController.swift
//  HappyGrahak
//
//  Created by IOS on 05/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit
import MobileCoreServices
import Foundation

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate,  UIImagePickerControllerDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView==pickerView1 {
            if self.cityIdArray != nil {
                return (self.cityIdArray?.count)!
            }
            return 0
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField==self.stateField {
            self.stateField.becomeFirstResponder()
        } else if textField==self.cityField {
            if cityNameArray?.count != 0 {
                self.cityField.becomeFirstResponder()
            }
        }
    }
    
    var picker:UIImagePickerController?=UIImagePickerController()
    var myView: UIView?
    var tableView: UITableView?
    var data: String?
    var data2: String?
    var images: UIImage?
    var pickerView: UIPickerView?
    var pickerView1: UIPickerView?
    var imageName: String?
    var doneButton: UIBarButtonItem?
    var doneButton1: UIBarButtonItem?
    
    var cancelButton: UIBarButtonItem?
    var cancelButton1: UIBarButtonItem?
    
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var mobileField: UITextField!
    @IBOutlet var scroll: UIScrollView!
    var stateNameArray: NSMutableArray?
    var  stateIdArray: NSMutableArray?
    var cityNameArray: NSMutableArray?
    var  cityIdArray: NSMutableArray?
    var customView: UIView?
    @IBOutlet var stateView: UIView!
    @IBOutlet var submitBtn: UIButton!
    
    @IBOutlet var profileBtn: UIButton!
    @IBOutlet var cityView: UIView!
    @IBOutlet var stateField: UITextField!
    @IBOutlet var cityField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserDetails()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let button1 = UIButton.init(type: .custom)
        button1.setImage(UIImage.init(named: "back_Icon"), for: UIControlState.normal)
        button1.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        button1.addTarget(self, action:#selector(self.backAction), for:.touchUpInside)
        let barButton1 = UIBarButtonItem.init(customView: button1)
        self.navigationItem.leftBarButtonItem = barButton1
        self.navigationItem.title = "My Profile"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
        
        profilePic.layer.cornerRadius = profilePic.frame.size.height/2
        profilePic.clipsToBounds = true
        profilePic.layer.borderWidth = 2.0
        profilePic.layer.borderColor = UIColor.white.cgColor
        //profileBtn.addTarget(self, action: #selector(self.uploadImageBtn(sender:)), for: .touchUpInside)
        //        stateBtn.addTarget(self, action: #selector(self.addTableView), for: .touchUpInside)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        picker?.delegate=self
        scroll.addGestureRecognizer(tap)
        self.addCustomView()
        self.addPickerToState()
        self.addPickerToCity()
        submitBtn.addTarget(self, action: #selector(self.saveData), for: .touchUpInside)
    }
    
    @objc func uploadImageBtn(sender: UIButton) {
        let screenRect: CGRect = UIScreen.main.bounds;
        let screenWidth: CGFloat = screenRect.size.width;
        let screenHeight: CGFloat = screenRect.size.height;
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseIn, animations: {
            self.customView?.frame = CGRect(x: 0, y: screenHeight-150, width: screenWidth, height: 150);
        }) { (finished) in}
    }
    
    func addCustomView() {
        let screenRect: CGRect = UIScreen.main.bounds
        let screenWidth:CGFloat = screenRect.size.width
        let screenHeight: CGFloat = screenRect.size.height
        customView = UIView.init(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: 150))
        self.view.addSubview(customView!)
        
        let pickPhotoButton: UIButton = UIButton.init(frame: CGRect(x: 20, y: 10, width: screenWidth-40, height: 35));
        pickPhotoButton.backgroundColor = UIColor.black
        pickPhotoButton.setTitle("Upload Photo", for: .normal)
        pickPhotoButton.setTitleColor(UIColor.white, for: .normal)
        pickPhotoButton.addTarget(self, action: #selector(self.OpenGallery), for: .touchUpInside)
        customView?.addSubview(pickPhotoButton)
        let takePhoto: UIButton = UIButton.init(frame: CGRect(x: 20, y: 55, width: screenWidth-40, height: 35));
        takePhoto.backgroundColor = UIColor.black
        takePhoto.setTitle("Camera", for: .normal)
        takePhoto.setTitleColor(UIColor.white, for: .normal)
        takePhoto.addTarget(self, action: #selector(self.TakePhoto), for: .touchUpInside)
        customView?.addSubview(takePhoto)
        let cancelButton: UIButton = UIButton.init(frame: CGRect(x: 20, y: 100, width: screenWidth-40, height: 35));
        cancelButton.backgroundColor = UIColor.black
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.cancelDone), for: .touchUpInside)
        customView?.addSubview(cancelButton)
    }
    
    @objc func cancelDone() {
        let screenRect: CGRect = UIScreen.main.bounds;
        let screenWidth: CGFloat = screenRect.size.width;
        let screenHeight: CGFloat = screenRect.size.height;
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseIn, animations: {
            self.customView?.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 150);
        }) { (finished) in
            self.customView?.removeFromSuperview()
            self.addCustomView()
        }
    }
    
    // Open Gallery button click
    @IBAction func OpenGallery(sender: AnyObject) {
        openGallary()
    }
    
    // Take Photo button click
    @IBAction func TakePhoto(sender: AnyObject) {
        openCamera()
    }
    
    
    func openGallary()
    {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker!.allowsEditing = false
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            picker!.cameraCaptureMode = .photo
            present(picker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePic.image = image
            print(image);
        }
        if let path: URL = info[UIImagePickerControllerImageURL] as? URL {
            imageName = path.lastPathComponent
            print(path.lastPathComponent)
        }
        picker.dismiss(animated: true, completion: nil);
        self.cancelDone()
    }
    
    func imagePickerController(_picker: UIImagePickerController, didFinishPickingImage img: UIImage, editingInfo: NSDictionary) {
        picker?.dismiss(animated: true, completion: nil);
        let imagePath: URL = editingInfo.object(forKey: "UIImagePickerControllerReferenceURL") as! URL
        let imageName: String = imagePath.lastPathComponent
        print(imageName)
    }
    
    @objc func backAction() -> Void {
        let viewController = SideBarRootViewController(nibName: "SideBarRootViewController_iPhone", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
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
            if cityIdArray?.object(at: 0) != nil {
                self.cityField.text = cityNameArray?.object(at: 0) as! String
                self.cityField.tag = cityIdArray![0] as! Int
                self.cityField.resignFirstResponder()
            }else{
                self.cityField.resignFirstResponder()
            }
        } else {
            // hide the picker view
            self.stateField.text = stateNameArray?.object(at: 0) as! String
            self.stateField.tag = stateIdArray![0] as! Int
            self.getAllCities(stateId: stateIdArray![0] as! String)
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
                    if cityIdArray?.object(at: 0) != nil {
                        self.cityField.text = cityNameArray?[0] as! String
                        self.cityField.tag = cityIdArray![0] as! Int
                        self.cityField.resignFirstResponder()
                }else{
                    self.cityField.resignFirstResponder()
                }
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (stateNameArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cellID")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cellID")
        }
        
        cell?.textLabel?.text = stateNameArray?[indexPath.row] as! String
        cell?.textLabel?.font =  UIFont(name:"Times New Roman", size: 10)
        cell?.textLabel?.textAlignment = .left
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell:UITableViewCell? = tableView.cellForRow(at: indexPath)
//        dropBtn.setTitle(" " + (cell?.textLabel?.text)!, for: .normal)
//        dropBtn.tag = invIdArray![indexPath.row] as! Int
//        self.cartBtn.accessibilityIdentifier = "\(indexPath.row)"
//        mrpLabel.text = mrpArray?[indexPath.row] as! String
//        sellingPriceLabel.text = spArray?[indexPath.row] as! String
//        offerLabel.text = offerArray?[indexPath.row] as! String
//        myView.isHidden = true
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        myView?.isHidden = true
    }
    
    @objc func addTableView() -> Void {
        myView = UIView.init(frame: CGRect(x: stateView.frame.origin.x, y: stateView.frame.origin.y+44.0, width: stateView.frame.size.width, height: CGFloat((stateNameArray?.count)!*30)))
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
        myView?.isHidden = false
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func getUserDetails(){
        var params: String = ""
        params =  ""
        
        
        let urlString = BASE_URL + "user?" + params
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
                            var imgUrl: String?
                            var userName: String?
                            var email: String?
                            var mobile: String?
                            var countryId: String?
                            
                            //var nameArray: NSMutableArray = NSMutableArray()
                            
                            var  data: NSDictionary?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            
                            //                            print("Error:- \(error!)")
                            //                            print("Message:- \(message!)")
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                data = result["data"] as? NSDictionary
                                imgUrl = data?.value(forKey: "avatar") as! String
                                let url = URL(string: imgUrl!)
                                let data1 = try? Data(contentsOf: url!)
                                if data1 != nil {
                                    self.profilePic.image = UIImage(data: data1!)
                                }
                                let state = data!["state"] as? NSDictionary
                                let city = data!["city"] as? NSDictionary
                                userName = data?.value(forKey: "name") as! String
//                                email = data?.value(forKey: "email") as! String
                                mobile = data?.value(forKey: "mobile") as! String
                                countryId = data?.value(forKey: "country_id") as! String
                                if state != nil {
                                    let state_name = state!["name"]
                                    self.stateField.text = state_name as! String
                                }
                                if city != nil {
                                    let city_name = city!["name"]
                                    self.cityField.text = city_name as! String
                                }
                                self.nameField.text = userName
                                
                                self.mobileField.text = mobile
                                
                                self.getAllStates(countryId: countryId!)
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
    
    func compressForUpload(original: UIImage, scale: CGFloat)->UIImage
    {
        // Calculate new size given scale factor.
        let originalSize: CGSize = original.size;
        let newSize: CGSize = CGSize(width: originalSize.width * scale, height: originalSize.height * scale);

        // Scale the original image to match the new size.
        UIGraphicsBeginImageContext(newSize);
        original.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let compressedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();

        return compressedImage;
    }
    
    
    
    @objc func saveData() {
        if((nameField.text!.characters.count)>0){
            if((nameField.text!.characters.count)>3){
                self.CallForUploadWebService()
            }else{
                
            }
        }else{
            
        }
    }
    
//    private func createBody(with parameters: [String: String]?, filePathKey: String, paths: [String], boundary: String) throws -> Data {
//        var body = Data()
//
//        if parameters != nil {
//            for (key, value) in parameters! {
//                body.append(NSString(format: "--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
//                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.append("\(value)\r\n")
//            }
//        }
//
//        for path in paths {
//            let url = URL(fileURLWithPath: path)
//            let filename = url.lastPathComponent
//            let data = try Data(contentsOf: url)
//            let mimetype = mimeType(for: path)
//
//            body.append("--\(boundary)\r\n")
//            body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
//            body.append("Content-Type: \(mimetype)\r\n\r\n")
//            body.append(data)
//            body.append("\r\n")
//        }
//
//        body.append("--\(boundary)--\r\n")
//        return body
//    }
//
//    private func mimeType(for path: String) -> String {
//        let url = URL(fileURLWithPath: path)
//        let pathExtension = url.pathExtension
//
//        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
//            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
//                return mimetype as String
//            }
//        }
//        return "application/octet-stream"
//    }
    
    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
//
    func createRequestBody(photo:NSData)->NSMutableData {
        let boundary:String = "------WebKitFormBoundaryasdas543wfsdfs5453533d3sdfsf3"
        var contentType = "multipart/form-data; boundary=\(boundary)"
        let body = NSMutableData()
        body.append(NSString(format: "\r\n--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format: "Content-Disposition: form-data; name=\"photo\"; avatar=\"photo.jpeg\"\r\n").data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format:"Content-Type: image/jpeg\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
        body.append(photo as Data)
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        print(body) // This will be the request body to post to your api/service
        return body
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func CallForUploadWebService(){
        
        var params: String
        var error: NSError?
        let timage: UIImage = self.compressForUpload(original: profilePic.image!, scale: 0.3)
        let imageData: NSData = UIImageJPEGRepresentation(timage, 1.0)! as NSData;
        let jsonData: NSData = self.createRequestBody(photo: imageData)
        let dataString: String? = "\(jsonData)"
//        let jsonDict = try! JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//        print(jsonDict)
        
        params =  "name=\(nameField.text!)&state_id=\(stateField.tag)&city_id=\(cityField.tag)"
        let urlString = BASE_URL + "user/update?" + params
        print(urlString)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)

        var request = URLRequest(url: url! as URL)
        let token: String = UserDefaults.standard.value(forKey:"token") as! String
        
        let boundary = generateBoundaryString()
//        let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        request.httpBody = try? createBody(with: ["name"  : nameField.text!], filePathKey: "avatar", paths: [path1], boundary: boundary)
        BACKGROUND_QUEUE {
            
            API.startRequest(request: request, method: "POST",type: 0, params: "avatar=\(dataString!)", completion: { (response:URLResponse?, result:AnyObject?, error:Error?, responseStatus:String?) in
                
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
                                self.getUserDetails()
                            }else if ((error!)){
                                
                            }
                                // add an action (button)
                            
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
