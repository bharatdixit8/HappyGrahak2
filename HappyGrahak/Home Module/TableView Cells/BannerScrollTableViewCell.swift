//
//  BannerScrollTableViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 24/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class BannerScrollTableViewCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet var bannerScroll: UIScrollView!
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    var imagesArray: NSArray = NSArray()
    //var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
//    var pageControl : UIPageControl = UIPageControl(frame:CGRect(x: 50, y: 20, width: 200, height: 50))
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var imgView1: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        configurePageControl()
        bannerScroll.delegate = self
        bannerScroll.isPagingEnabled = true
        bannerScroll.contentSize = CGSize(width: bannerScroll.frame.size.width * CGFloat((imagesArray.count)), height: bannerScroll.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
        // Initialization code
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        //let count: Int = (imagesArray?.count)!
        
        
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.currentPageIndicatorTintColor = UIColor.green
        contentView.addSubview(pageControl)
        var timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.update(sender:)), userInfo: nil, repeats: true)
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * bannerScroll.frame.size.width
        bannerScroll.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    
    @objc func update(sender: AnyObject) -> () {
        if(pageControl.currentPage<3){
            pageControl.currentPage+=1
            let x = CGFloat(pageControl.currentPage) * bannerScroll.frame.size.width
            bannerScroll.setContentOffset(CGPoint(x: x,y :0), animated: true)
        }else{
            pageControl.currentPage = 0
            let x = CGFloat(pageControl.currentPage) * bannerScroll.frame.size.width
            bannerScroll.setContentOffset(CGPoint(x: x,y :0), animated: true)
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
