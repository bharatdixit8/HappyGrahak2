//
//  AboutUsViewController.swift
//  HappyGrahak
//
//  Created by IOS on 19/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit
import WebKit

class AboutUsViewController: UIViewController, WKUIDelegate {

    @IBOutlet var myWebView: WKWebView!
    var button1: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        myWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        myWebView.uiDelegate = self
        view = myWebView
        
        let myURL = URL(string: "https://www.happygrahak.com/about-us")
        let myRequest = URLRequest(url: myURL!)
        myWebView.load(myRequest)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        button1 = UIButton.init(type: .custom)
        button1?.setImage(UIImage.init(named: "back_Icon"), for: UIControlState.normal)
        button1?.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        button1?.addTarget(self, action:#selector(self.backAction), for:.touchUpInside)
        self.navigationController?.navigationBar.addSubview(button1!)
        self.navigationItem.title = "About Us"
        self.navigationItem.hidesBackButton = true
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        button1?.isHidden = true
    }
    
    @objc func backAction() -> Void {
        let viewController = SideBarRootViewController(nibName: "SideBarRootViewController_iPhone", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
