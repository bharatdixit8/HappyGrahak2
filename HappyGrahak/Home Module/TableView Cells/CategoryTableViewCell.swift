//
//  CategoryTableViewCell.swift
//  HappyGrahak
//
//  Created by IOS on 24/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var nameLabel: CustomLabel!
    var  data: NSArray?
    var sub_category: SubCategoryModel?
    
    @IBOutlet var footerLabel: UILabel!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if((sub_category) != nil){
            print(sub_category?.id?.count)
            return (sub_category?.id?.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "CollectionViewCell"
        
        var collectionCell: CategoryCollectionViewCell! = self.collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CategoryCollectionViewCell
        if collectionCell == nil {
            self.collectionView!.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
            collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CategoryCollectionViewCell
        }
        print(sub_category)
        if((sub_category) != nil){
            collectionCell.productName.text = sub_category?.name?.object(at: indexPath.row) as? String
            let url = URL(string: (sub_category?.image_path?.object(at: indexPath.row) as? String)!)
            DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            if data==nil{
                collectionCell.productIcon.image = UIImage(named: "default_product_icon")
            }else{
                DispatchQueue.main.async() {
                    collectionCell.productIcon.image = UIImage(data: data!)
                }
            }
            }
            
            collectionCell.accessibilityIdentifier = sub_category?.id?.object(at: indexPath.row) as? String
        }
        
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.size.width/2.15, height: collectionView.frame.size.width/2.15);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        print(sub_category?.id?.object(at: indexPath.row) as Any)
       
        UserDefaults.standard.set(sub_category?.id?.object(at: indexPath.row) as! Int, forKey: "sub_category_id")
        let cell: CategoryCollectionViewCell = self.collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
         print((cell.superview?.superview?.superview?.superview?.superview?.superview?.next)!)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
        nextViewController.headerTitle = cell.productName.text
        let view: UIViewController = (cell.superview?.superview?.superview?.superview?.superview?.superview?.next)! as! UIViewController
        view.navigationController?.pushViewController(nextViewController, animated: true)
        //self.getSubCategory(id: sub_category?.id?.object(at: indexPath.row) as! Int, index: indexPath)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        nameLabel.attributedText = nameLabel.labelColor(text: "SHOP BY CATEGORY", range: NSRange(location: 0, length: 7))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        self.collectionView!.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction(sender:)))
        self.footerLabel.addGestureRecognizer(tap)
        
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
//        print(sender.s)
    }
    
}
