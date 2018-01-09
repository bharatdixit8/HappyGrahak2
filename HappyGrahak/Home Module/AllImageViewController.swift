//
//  AllImageViewController.swift
//  HappyGrahak
//
//  Created by IOS on 04/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class AllImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollview: UIScrollView!
    var imgPathArray: NSMutableArray = NSMutableArray()
    var myUIImageView: UIImageView!
    var button1: UIButton?
    @IBOutlet var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        button1 = UIButton.init(type: .custom)
        button1?.setImage(UIImage.init(named: "back_Icon"), for: UIControlState.normal)
        button1?.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        button1?.addTarget(self, action:#selector(self.backAction), for:.touchUpInside)
        self.navigationController?.navigationBar.addSubview(button1!)
        self.navigationItem.hidesBackButton = true
        self.scrollview.maximumZoomScale = 5.0
        self.scrollview.minimumZoomScale = 0.5
        self.scrollview.delegate = self
        
        var Y: CGFloat = 0
        
        for index in 0..<self.imgPathArray.count {
            let url = URL(string: self.imgPathArray[index] as! String)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            myUIImageView = UIImageView(frame: CGRect(x: Y, y: 0, width: self.scrollview.frame.size.width, height: self.scrollview.frame.size.height))
            myUIImageView.image = UIImage(data: data!)
            myUIImageView.layer.borderWidth=1.0
            myUIImageView.layer.masksToBounds = true
            myUIImageView.layer.borderColor = UIColor.white.cgColor
            //imageView.layer.cornerRadius = 50;// Corner radius should be half of the height and width.
            
            self.scrollview.addSubview(myUIImageView)
            Y=self.scrollview.frame.size.width+Y
        }
        self.scrollview.contentSize = CGSize(width: Y, height: 150)
        self.configurePageControl()
       // self.configureZoomScale()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        button1?.isHidden = true
    }

    @objc func backAction() -> Void {
        button1?.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    func configurePageControl() {
        self.pageControl.numberOfPages = self.imgPathArray.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.view.addSubview(pageControl)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func configureZoomScale()->Void{
//
//    //WE NEED TO CALCULATE BY HOW MUCH WE NEED TO RESIZE THE IMAGE VIEW
//    //FOR IT TO FIT PERFECTLY WITHIN THE Scroll View
//
//    // the_view_size * some_zoom_scale_value = the_screen_size
//    //therefore ***  zoom_scale_value = the_screen_size/the_view_size  ****
//    //we use this formula to determine both the xscale value
//    //and the yscale value
//    //We then take the smaller ratio of the two to make sure that the
//    //entire image fits, regardless of whether width or height is bigger
//
//        let xZoomScale: CGFloat = self.scrollview.bounds.size.width/self.myUIImageView.bounds.size.width;
//        let yZoomScale: CGFloat = self.scrollview.bounds.size.height/self.myUIImageView.bounds.size.height;
//        let minZoomScale: CGFloat = (xZoomScale,yZoomScale);
//
//    //set minimumZoomScale to the minimum zoom scale we calculated
//    //this mean that the image cant me smaller than full screen
//    self.scrollview.minimumZoomScale = minZoomScale;
//    //allow up to 4x zoom
//    //self.scrollview.maximumZoomScale = 4;
//    //set the starting zoom scale
//    self.scrollview.zoomScale = minZoomScale;
//    }

    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return myUIImageView
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
