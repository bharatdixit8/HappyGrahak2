//
//  OnBoardingViewController.swift
//  HappyGrahak
//
//  Created by IOS on 11/01/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var obBoardScroll: UIScrollView!
    
    var onboardImageArray: NSMutableArray = NSMutableArray()
    var count: Int = 0
    
    @IBOutlet var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let viewController = SideBarRootViewController(nibName: "SideBarRootViewController_iPhone", bundle: nil)
        if (UserDefaults.standard.value(forKey:"userId") != nil) {
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            self.obBoardScroll.delegate = self
            onboardImageArray.add("onboarding_startUp")
            onboardImageArray.add("onboarding1")
            onboardImageArray.add("onboarding2")
            onboardImageArray.add("onboarding3")
            onboardImageArray.add("onboarding4")
            //self.navigationController?.setNavigationBarHidden(true, animated: false)
            var Y: CGFloat = 0.0
            for i in self.onboardImageArray {
                
                if let onboardImg = UIImage(named: i as! String)
                {
                    let imageView = UIImageView(frame: CGRect(x: Y, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height))
                    imageView.layer.masksToBounds = true
                    imageView.image = onboardImg
                    obBoardScroll.addSubview(imageView)
                }
                Y=self.view.frame.size.width+Y
            }
            
            obBoardScroll.contentSize = CGSize(width: Y, height: self.view.frame.size.height)
            self.configurePageControl()
            print(obBoardScroll.contentSize.width)
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextBtnPresed(_ sender: Any) {
        if pageControl.currentPage<self.onboardImageArray.count-1 {
            let x = CGFloat(pageControl.currentPage+1) * obBoardScroll.frame.size.width
            print(x)
            obBoardScroll.setContentOffset(CGPoint(x: x,y :-20), animated: true)
            pageControl.currentPage += 1
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        //let count: Int = (imagesArray?.count)!
        
        pageControl.numberOfPages = self.onboardImageArray.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.currentPageIndicatorTintColor = UIColor.green
        //contentView.addSubview(pageControl)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        count += 1
        if count == 5 {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    @IBAction func skipBtnClicked(_ sender: Any) {
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
