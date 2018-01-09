//
//  LocationViewController.swift
//  HappyGrahak
//
//  Created by IOS on 17/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet var currentLocation: UIButton!
    @IBOutlet var pickLocationBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        currentLocation.layer.cornerRadius = 5
        pickLocationBtn.layer.cornerRadius = 5
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "refresh_Icon"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(self.callMethod), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let button1 = UIButton.init(type: .custom)
        button1.setImage(UIImage.init(named: "back_Icon"), for: UIControlState.normal)
        button1.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        button1.addTarget(self, action:#selector(self.backAction), for:.touchUpInside)
        let barButton = UIBarButtonItem.init(customView: button)
        let barButton1 = UIBarButtonItem.init(customView: button1)
        self.navigationItem.leftBarButtonItem = barButton1
        self.navigationItem.rightBarButtonItem = barButton
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
        
        currentLocation.addTarget(self, action: #selector(self.moveOffline), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func callMethod() -> Void {
        print("hello")
    }
    
    @objc func moveOffline() {
        let viewController = SideBarRootViewController(nibName: "SideBarRootViewController_iPhone", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
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
