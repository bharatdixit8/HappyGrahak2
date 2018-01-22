//
//  Helper.swift
//  Translator
//
//  Created by Avineet on 17/10/16.
//  Copyright © 2016 Corwhite. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import CoreData

//MARK: - CONSTANTS

// ---------------<( URLS )>-----------------

let BASE_URL = "http://10.107.4.9:8000/api/"
//let BASE_URL = "https://www.happygrahak.com/api/"

// ---------------<( MISCELLANEOUS )>-----------------


var APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

var USER_DEFAULTS = UserDefaults.standard

var SCREEN_WIDTH = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)

var SCREEN_HEIGHT = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)

var IndexPathZero = IndexPath(row: 0, section: 0)



// Constants

let IS_DOCUMENT_COMPLETE = "IsDocumentFilingComplete"
let IS_DOCUMENT_UPLOAD = "IsDocumentUploaded"
let IS_FORM16_UPLOAD = "IsForm16Uploaded"
let IS_MANUAL_FILING = "IsManualFiling"
let IS_PHONE_CONFIRMED = "IsPhoneNumberConfirmed"
let IS_PROFILE_UPDATED = "IsProfileUpdated"
let IS_QUESTIONAIRE_COMPLETE = "IsQuestionnaireComplete"
let IS_TAXFILING_COMPLETE = "IsTaxFilingComplete"
let USER_ASSESMENT_YEAR_ID = "UserAssestmentYearId"


struct ScreenSize {
    
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO             = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}



struct iOSVersion {
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7 = (iOSVersion.SYS_VERSION_FLOAT < 8.0 && iOSVersion.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8 = (iOSVersion.SYS_VERSION_FLOAT >= 8.0 && iOSVersion.SYS_VERSION_FLOAT < 9.0)
    static let iOS9 = (iOSVersion.SYS_VERSION_FLOAT >= 9.0 && iOSVersion.SYS_VERSION_FLOAT < 10.0)
}


let Info = "Informational"
let Sucees = "Success"
let Direction = "Redirection"
let ClientErr = "Client Error"
let ServerErr = "Server Error"
let StatusErr = "Status Error"

//MARK: - SWIFT CLOSURE(MACROS)

// ---------------<( MISCELLANEOUS )>-----------------

public func prefersStatusBarHidden() -> Bool {
    return false
}

public func IS_NOT_NIL(_ value: AnyObject!) -> Bool {
    return (value != nil)
}

public func IS_NOT_EMPTY_STRING(_ value: AnyObject!) -> Bool {
    return (!value.isEqual(to: value as! String))
}

public func TRIMMED_STRING(_ inputString: NSString) -> NSString {
    return inputString.trimmingCharacters(in: CharacterSet(charactersIn: "\n \r\n \r \t")) as NSString
}

public func ARRAY_FROM_STRING(_ string: NSString) -> [String] {
    return string.components(separatedBy: ",")
}

public func getRandomColor() -> UIColor{
    //Generate between 0 to 1
    let red:CGFloat = CGFloat(drand48())
    let green:CGFloat = CGFloat(drand48())
    let blue:CGFloat = CGFloat(drand48())
    
    return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
}

//public func stateCountryName(_ id: String, _ stateOrCountry: String) -> String {
//    let searchPredicate = NSPredicate(format: "Id == %@",id);
//    if stateOrCountry == "state"
//    {
//        let stateArray = APP_DELEGATE.stateArray.filter { searchPredicate.evaluate(with: $0) } as NSArray;
//        return ((stateArray.object(at: 0) as! NSDictionary).value(forKey: "State") as? String)!
//    }
//    else
//    {
//        let countryArray = APP_DELEGATE.countryArray.filter { searchPredicate.evaluate(with: $0) } as NSArray;
//        return ((countryArray.object(at: 0) as! NSDictionary).value(forKey: "Country") as? String)!
//    }
//    
//}

public func getNameFromId(_ id: String, _ array: NSArray, _ key: String) -> String {
    let searchPredicate = NSPredicate(format: "Id == %@",id);
    let empArray = array.filter { searchPredicate.evaluate(with: $0) } as NSArray;
    return ((empArray.object(at: 0) as! NSDictionary).value(forKey: key) as? String)!
}

public func getUniqueId(_ id: String, _ array: NSArray, _ key: String) -> String {
    let searchPredicate = NSPredicate(format: "BankAccountTypeFlag == %@",id);
    let empArray = array.filter { searchPredicate.evaluate(with: $0) } as NSArray;
    return ((empArray.object(at: 0) as! NSDictionary).value(forKey: key) as? String)!
}

public func getUniqueAssessmentId(_ id: String, _ array: NSArray, _ key: String) -> String {
    let searchPredicate = NSPredicate(format: "Value == %@",id);
    let empArray = array.filter { searchPredicate.evaluate(with: $0) } as NSArray;
    return ((empArray.object(at: 0) as! NSDictionary).value(forKey: key) as? String)!
}



public func checkForUniqueId(_ id: String, _ array: NSArray, _ key: String) -> Bool {
    let searchPredicate = NSPredicate(format: "BankAccountTypeFlag == %@",id);
    let empArray = array.filter { searchPredicate.evaluate(with: $0) } as NSArray;
    if empArray.count == 0
    {
        return false
    }
    else
    {
        return true
    }
}

public func getIndexOfPrimaryAccount(_ id: String, _ array: NSArray) -> Int
{
    let searchPredicate = NSPredicate(format: "Id == %@",id);
    let empArray = array.filter { searchPredicate.evaluate(with: $0) } as NSArray;
    let index = array.index(of: (empArray.object(at: 0) as! NSDictionary))
    return index
}

//public func financialYearName(_ id: String, _ array: NSArray) -> String {
//    let searchPredicate = NSPredicate(format: "Id == %@",id);
//    let financialArray = array.filter { searchPredicate.evaluate(with: $0) } as NSArray;
//    return ((financialArray.object(at: 0) as! NSDictionary).value(forKey: "FinancialYear") as? String)!
//}
//
//public func listedSecuritiesName(_ id: String, _ array: NSArray) -> String {
//    let searchPredicate = NSPredicate(format: "Id == %@",id);
//    let securityArray = array.filter { searchPredicate.evaluate(with: $0) } as NSArray;
//    return ((securityArray.object(at: 0) as! NSDictionary).value(forKey: "ShareType") as? String)!
//}
// ------------------<( UICOLOR )>--------------------


public func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

public func UIColorFromRGBA(_ rgbValue: UInt, alpha: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(alpha)
    )
}

// -----------------<(Date Format)>---------------------

public func convertDateString(dateString : String!, fromFormat sourceFormat : String!, toFormat desFormat : String!) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = sourceFormat
    let date = dateFormatter.date(from: dateString)
    dateFormatter.dateFormat = desFormat
    let str = dateFormatter.string(from: date!)
    return str
}

// ------------------<( GCD )>--------------------

public func BACKGROUND_QUEUE(_ codeBlock:@escaping (() -> Void)) -> Void {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: codeBlock)
}

public func MAIN_QUEUE(_ codeBlock:@escaping (() -> Void)) -> Void {
    return DispatchQueue.main.async(execute: codeBlock)
}

// ------------------<( VALIDATION )>--------------------

public func VALIDATE_EMAIL(_ email: NSString) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
}

public func VALIDATE_PAN(_ pan: NSString) -> Bool {
    let panRegEx = "^[A-Z]{5}[0-9]{4}[A-Z]$"
    let panTest = NSPredicate(format:"SELF MATCHES %@", panRegEx)
    return panTest.evaluate(with: pan)
}

public func VALIDATE_TAN(_ pan: NSString) -> Bool {
    let panRegEx = "^[A-Z]{4}[0-9]{5}[A-Z]$"
    let panTest = NSPredicate(format:"SELF MATCHES %@", panRegEx)
    return panTest.evaluate(with: pan)
}


public func VALIDATE_IFSC(_ pan: NSString) -> Bool {
    let panRegEx = "^[A-Z]{4}[0]{1}[0-9]{6}$"
    let panTest = NSPredicate(format:"SELF MATCHES %@", panRegEx)
    return panTest.evaluate(with: pan)
}


public func VALIDATE_MOBILE(_ phone: NSString) -> Bool {
    
    let PHONE_REGEX = "^09[0-9'@s]{9,9}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: phone)
    return result
}



//MARK: - USEFUL METHODS

extension String {
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.characters.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.characters.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return String(self[startIndex ..< endIndex])
    }
    
    func substring(from: Int) -> String {
        return self.substring(from: from, to: nil)
    }
    
    func substring(to: Int) -> String {
        return self.substring(from: nil, to: to)
    }
    
    func substring(from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }
        
        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length - 1
        }
        
        return self.substring(from: from, to: end)
    }
    
    func substring(length: Int, to: Int?) -> String {
        guard let end = to, end > 0, length > 0 else {
            return ""
        }
        
        let start: Int
        if let end = to, end - length > 0 {
            start = end - length + 1
        } else {
            start = 0
        }
        
        return self.substring(from: start, to: to)
    }
}


class ConveienceClass: NSObject {
    
    // ------------------<( UIALERT )>--------------------
    
    class func showSimpleAlert(title: String, message: String, controller: UIViewController, onCancel:@escaping ((UIAlertAction) -> Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: onCancel))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
  
    
    class func showSimpleAlert(title: String, message: String, controller: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        controller.present(alert, animated: true, completion: nil)
    }
  
    
    
    class func showNetworkConnectionAlert(controller: UIViewController) {
        
        let title = "Mobile Data is Turned Off"
        let message = "Turn on mobile data or use Wi-Fi to access data."
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (UIAlertAction) in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: ["": ""], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    // ------------------<( LAYER ANIMATION )>--------------------
    
    class func layerWarningAnimation(_ layer:CALayer) {
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.duration = 1.5
        colorAnimation.fromValue = UIColor.white.cgColor
        colorAnimation.toValue = UIColor.red.cgColor
        colorAnimation.autoreverses = true
        
        layer.add(colorAnimation, forKey: "backgroundColor")
        
    }
    
}




class CustomAlert: NSObject {
    
    class func showNetworkAlert(_ controller: UIViewController) {
        
        let networkAlert = UIAlertController(title: "Mobile Data is Turned Off", message: "Turn on mobile data or use Wi-Fi to access data.", preferredStyle: .alert)
        
        networkAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action:UIAlertAction) in
            
        }))
        
        networkAlert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action:UIAlertAction) in
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }))
        
        controller.present(networkAlert, animated: true, completion: nil)
        
    }
    
    class func showSimpleAlert(_ title: String, controller: UIViewController) {
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action:UIAlertAction) in
        }))
        controller.present(alert, animated: true, completion: nil)
    }
}



//MARK: - SERVER CLASS

public func statusCode(_ response: HTTPURLResponse?) -> String? {
    if let httpResponse = response  {
        let val: Int = (httpResponse.statusCode) / 100
        if val == 1
        {
            return Info
        }
        else if val == 2
        {
            return Sucees
        }
        else if val == 3
        {
            return Direction
        }
        else if val == 4
        {
            return ClientErr
        }
        else if val == 5
        {
            return ServerErr
        }else{
        
            return StatusErr
        }
    }
    return nil
}

func startAnimating(view: UIView) {
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
    indicator.center = view.center
    view.addSubview(indicator)
    indicator.bringSubview(toFront: view)
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
}

func stopAnimating(view: UIView) {
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
    indicator.center = view.center
    view.addSubview(indicator)
    indicator.bringSubview(toFront: view)
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
}


class API: NSObject {
    
    typealias Completion = ( _ response:URLResponse?,  _ result: AnyObject?,  _ error: Error?,  _ responseStatus:String?) -> Void
    class func startRequest(request:URLRequest, method:String,type:Int, params:String, completion:@escaping Completion) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var request = request
        let type = type
        request.httpMethod = method
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        print("REQUEST : -> \(method)|\(String(describing: request.url?.absoluteString))")
        
        if method == "POST" {
            request.httpBody = params.data(using: String.Encoding.utf8)
            print("PARAMS : -> \(params)")
        }
        else if method == "PUT"
        {
//            [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"]
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = params.data(using: String.Encoding.utf8)
            print("PARAMS : -> \(params)")
        }
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            
            if let httpResponse = response as? HTTPURLResponse {
                print("RESPONSE URL Response \(httpResponse.statusCode)")
            }
            
            let statusValue = statusCode(response as? HTTPURLResponse)
            if type == 0 {
                if let responseData = data
                {

                if let result = try? JSONSerialization.jsonObject(with: responseData) as? [String:Any] {
                    OperationQueue.main.addOperation {
                        completion(response, result as AnyObject?, error, statusValue)
                    }
                } else {
                    let result = NSString(data: responseData, encoding: String.Encoding.utf8.rawValue)
                    OperationQueue.main.addOperation {
                        completion(response, result, error, statusValue)
                    }
                }
                }
            } else {
                if let responseData = data
                {
                    if let result = try? JSONSerialization.jsonObject(with: responseData) as? [[String:Any]] {
                        OperationQueue.main.addOperation {
                            completion(response, result as AnyObject?, error, statusValue)
                        }
                    }else {
                        let result = NSString(data: responseData, encoding: String.Encoding.utf8.rawValue)
                        OperationQueue.main.addOperation {
                            completion(response, result, error, statusValue)
                        }
                    }
                }
                
            }
        }
        task.resume()
    }
    
    
    
    class func startPOSTRequest(request:URLRequest, method:String, params:[String:Any], completion:@escaping Completion) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var request = request
        print("REQUEST : -> \(method)|\(String(describing: request.url?.absoluteString))")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        if method == "POST" {
            request.httpBody = NSKeyedArchiver.archivedData(withRootObject: params)
            print("PARAMS : -> \(params)")
        }
        
        
        request.httpMethod = method
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let statusValue = statusCode(response as? HTTPURLResponse)
            if let result = try? JSONSerialization.jsonObject(with: data!) as! [String:Any] {
                OperationQueue.main.addOperation {
                    completion(response, result as AnyObject?, error, statusValue)
                }
            }
        }
        task.resume()
    }
    
}


class Downloader: NSObject {
    class func load(url: URL, to localUrl: URL, completion: @escaping () -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                    completion()
                } catch (let writeError) {
                    print("error writing file \(localUrl) : \(writeError)")
                }
                
            } else {
                print("Failure: %@", error?.localizedDescription as Any);
            }
        }
        task.resume()
    }
    
}


class InsetLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)))
    }
}
