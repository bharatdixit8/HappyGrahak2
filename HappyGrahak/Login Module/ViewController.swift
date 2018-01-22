//
//  ViewController.swift
//  HappyGrahak
//
//  Created by IOS on 17/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var signupBtn: UIButton!
    @IBAction func skipBtn(_ sender: Any) {
        let viewController = SideBarRootViewController(nibName: "SideBarRootViewController_iPhone", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 5
        signupBtn.layer.cornerRadius = 5
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //let defaults = UserDefaults.standard
//        let viewController = SideBarRootViewController(nibName: "SideBarRootViewController_iPhone", bundle: nil)
//        if (UserDefaults.standard.value(forKey:"userId") != nil) {
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }else{
//            
//        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

