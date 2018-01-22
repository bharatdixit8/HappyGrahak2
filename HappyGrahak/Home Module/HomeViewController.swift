//
//  HomeViewController.swift
//  HappyGrahak
//
//  Created by IOS on 24/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit
//import InteractiveSideMenu
import CoreData

class HomeViewController: UITabBarController {
    var userDetails: UserDetailsModel?
    var button2: UIImageView?
    var button3: UILabel?
    var button5: UIImageView?
    var button6: UILabel?
    let navigationNormalHeight: CGFloat = 44
    let navigationExtendHeight: CGFloat = 84
    let recentViewArray: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(self.recentViewArray, forKey: "recentView")
        let button4 = UIButton.init(type: .custom)
        button4.setImage(UIImage.init(named: "cart_icon"), for: UIControlState.normal)
        button4.frame = CGRect.init(x: (self.navigationController?.navigationBar.frame.size.width)!-60, y: 8, width: 25, height: 25)
        button4.tag = 2001
        button4.addTarget(self, action:#selector(self.moveToCart), for:.touchUpInside)
        
        button3 = UILabel.init(frame: CGRect(x: (self.navigationController?.navigationBar.frame.size.width)!-50, y: 4.0, width: 13, height: 13))
        button3?.backgroundColor = UIColor.red
        button3?.layer.cornerRadius = (button3?.frame.size.height)!/2
        button3?.clipsToBounds = true
        button3?.textColor = UIColor.white
        button3?.font = UIFont.boldSystemFont(ofSize: 8.0)
        button3?.tag = 1001
        button3?.textAlignment = .center
        if (UserDefaults.standard.value(forKey:"cartCount") != nil) {
            let count: Int = (UserDefaults.standard.value(forKey:"cartCount") as! Int)
            button3?.text = String(describing: count)
        } else {
            var myCarts: [MyCart] = []
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            myCarts = try! context.fetch(MyCart.fetchRequest())
            let count: Int = myCarts.count
            button3?.text = String(describing: count)
        }
        //let barButton4 = UIBarButtonItem.init(customView: button4)
        self.navigationController?.navigationBar.addSubview(button4)
        self.navigationController?.navigationBar.addSubview(button3!)
//        self.navigationItem.rightBarButtonItems = [barButton3, barButton4]
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem?.tintColor = UIColor.black
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.white
//        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 17.0/255.0, green: 106.0/255.0, blue: 148.0/255.0, alpha: 1)
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
        let defaults = UserDefaults.standard
        defaults.set(userDetails?.name, forKey: "name")
        defaults.synchronize()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.init(red: 16.0/255.0, green: 32.0/255.0, blue: 38.0/255.0, alpha: 1)], for: .selected)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        button2 = UIImageView.init(image: UIImage.init(named: "home_logo_icon"))
        button2?.frame = CGRect.init(x: 50, y: 13, width: 150, height: 20.5)
        self.navigationController?.navigationBar .addSubview(button2!)
        
        button5 = UIImageView.init(image: UIImage.init(named: "notification_icon"))
        button5?.frame = CGRect.init(x: (self.navigationController?.navigationBar.frame.size.width)!-100, y: 8, width: 24, height: 24)
        self.navigationController?.navigationBar .addSubview(button5!)
        
        button6 = UILabel.init(frame: CGRect(x: (self.navigationController?.navigationBar.frame.size.width)!-95, y: 4.0, width: 13, height: 13))
        button6?.backgroundColor = UIColor.red
        button6?.layer.cornerRadius = (button6?.frame.size.height)!/2
        button6?.clipsToBounds = true
        button6?.textColor = UIColor.white
        button6?.font = UIFont.boldSystemFont(ofSize: 8.0)
        button6?.tag = 101
        button6?.textAlignment = .center
        button6?.text = "0"
        self.navigationController?.navigationBar.addSubview(button6!)
        
        if(UserDefaults.standard.value(forKey:"userId") != nil){
            self.sendToken(_token: (UserDefaults.standard.value(forKey:"token") as! String))
        } else {
            var myCarts: [MyCart] = []
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            myCarts = try! context.fetch(MyCart.fetchRequest())
            let count: Int = myCarts.count
            button3?.text = String(describing: count)
        }
    }
//    extension UINavigationBar {
//        override open func sizeThatFits(_ size: CGSize) -> CGSize {
//            var barHeight: CGFloat = navigationNormalHeight
//
//            if size.height == navigationExtendHeight {
//                barHeight = size.height
//            }
//
//            let newSize: CGSize = CGSize(width: self.frame.size.width, height: barHeight)
//            return newSize
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        button2?.isHidden = true
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
                                UserDefaults.standard.set(data!["mobile"], forKey: "mobile")
                                //UserDefaults.standard.set(data!["id"], forKey: "userId")
                                UserDefaults.standard.set(data!["cart_count"], forKey: "cartCount")
                                if UserDefaults.standard.value(forKey:"cartCount") != nil {
                                    let count: Int = (UserDefaults.standard.value(forKey:"cartCount") as! Int)
                                    self.button3?.text = String(describing: count)
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
//    @IBAction func openMenu(_ sender: UIButton) {
//        let viewController = SideBarRootViewController(nibName: "SideBarRootViewController_iPhone", bundle: nil)
//        viewController.jaSidePanel.toggleLeftPanel(sender)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func moveToCart() -> Void {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        
        // self.revealViewController().setFrontViewPosition(FrontViewPosition, animated: true)
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
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
