//
//  HomePageViewController.swift
//  HappyGrahak
//
//  Created by IOS on 24/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit
import CoreData

//protocol SlideMenuDelegate {
//    func slideMenuItemSelectedAtIndex(_ index : Int32)
//}

class HomePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var homeTableView: UITableView!
    var cell1: CategoryTableViewCell?
    var cell2: StaticBannerTableViewCell?
    var cell3: ViewMoreScrollTableViewCell?
    var cell4: TopBrandsTableViewCell?
    var cell5: MostPopularTableViewCell?
    var cell6: OffersTableViewCell?
    var sub: SubCategoryModel?
    var spinner: LLARingSpinnerView?
    var bannerImageArray: NSMutableArray = NSMutableArray()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == homeTableView {
            return 7
//        }else{
//            return arrayMenuOptions.count
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LabelCell"
        if indexPath.row==0 {
            var cell: BannerScrollTableViewCell! = self.homeTableView.dequeueReusableCell(withIdentifier: identifier) as? BannerScrollTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "BannerScrollTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BannerScrollTableViewCell
            }
            cell.pageControl.numberOfPages = self.bannerImageArray.count
                var Y: CGFloat = -1.0
            
            for i in self.bannerImageArray {
                
                    if let path = (i as? String)
                    {
                        let url = URL(string: path)
                        let data = try? Data(contentsOf: url!)
                        let imageView = UIImageView(frame: CGRect(x: Y, y: 0.0, width: homeTableView.frame.size.width+1, height: cell.bannerScroll.frame.size.height))
                        imageView.layer.borderWidth=1.0
                        imageView.layer.masksToBounds = true
                        imageView.layer.borderColor = UIColor.white.cgColor
                        //imageView.layer.cornerRadius = 50;// Corner radius should be half of the height and width.
                        if data != nil {
                            imageView.image = UIImage(data: data!)
                        }
                        cell.bannerScroll.addSubview(imageView)
                    }
                Y=(homeTableView.frame.size.width+Y)
                }
                cell.bannerScroll.contentSize = CGSize(width: Y, height: 140.0)
                return cell
        } else if indexPath.row==1 {
            cell1 = self.homeTableView.dequeueReusableCell(withIdentifier: identifier) as? CategoryTableViewCell
            if cell1 == nil {
                tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell1 = tableView.dequeueReusableCell(withIdentifier: identifier) as? CategoryTableViewCell
            }
            cell1?.sub_category = self.sub
            return cell1!
        }else if indexPath.row==2{
            cell2 = self.homeTableView.dequeueReusableCell(withIdentifier: "Cell") as? StaticBannerTableViewCell
            if cell2 == nil {
                tableView.register(UINib(nibName: "StaticBannerTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
                cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell") as? StaticBannerTableViewCell
            }
            return cell2!
        } else if indexPath.row==3 {
            cell3 = self.homeTableView.dequeueReusableCell(withIdentifier: "ViewMore") as? ViewMoreScrollTableViewCell
            if cell3 == nil {
                tableView.register(UINib(nibName: "ViewMoreScrollTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewMore")
                cell3 = tableView.dequeueReusableCell(withIdentifier: "ViewMore") as? ViewMoreScrollTableViewCell
            }
            return cell3!
        }else if indexPath.row == 4{
            cell4 = self.homeTableView.dequeueReusableCell(withIdentifier: "TopBrands") as? TopBrandsTableViewCell
            if cell4 == nil {
                tableView.register(UINib(nibName: "TopBrandsTableViewCell", bundle: nil), forCellReuseIdentifier: "TopBrands")
                cell4 = tableView.dequeueReusableCell(withIdentifier: "TopBrands") as? TopBrandsTableViewCell
            }
            return cell4!
        }else if indexPath.row == 5{
            cell5 = self.homeTableView.dequeueReusableCell(withIdentifier: "MostPopular") as? MostPopularTableViewCell
            if cell5 == nil {
                tableView.register(UINib(nibName: "MostPopularTableViewCell", bundle: nil), forCellReuseIdentifier: "MostPopular")
                cell5 = tableView.dequeueReusableCell(withIdentifier: "MostPopular") as? MostPopularTableViewCell
            }
            return cell5!
        }else{
            cell6 = self.homeTableView.dequeueReusableCell(withIdentifier: "Offers") as? OffersTableViewCell
            if cell6 == nil {
                tableView.register(UINib(nibName: "OffersTableViewCell", bundle: nil), forCellReuseIdentifier: "Offers")
                cell6 = tableView.dequeueReusableCell(withIdentifier: "Offers") as? OffersTableViewCell
            }
            
            return cell6!
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //if tableView == homeTableView {
        if(indexPath.row==0){
            return 130.0
        }else if(indexPath.row==1){
            //return 200.0
            var screenSize: CGRect!
            var screenWidth: CGFloat!
            //var screenHeight: CGFloat!
            screenSize = UIScreen.main.bounds
            screenWidth = screenSize.width
            //screenHeight = screenSize.height
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            layout.itemSize = CGSize(width: 117.5, height: 117.5)
            layout.minimumInteritemSpacing = 1
            layout.minimumLineSpacing = 1
            cell1?.collectionView!.collectionViewLayout = layout
            var frame: CGRect = cell1!.collectionView.frame
            if ((self.sub?.id) != nil) {
            if((self.sub?.id?.count)!%3==0) {
                frame.size.height = 125.0*CGFloat((self.sub?.id?.count)!)/3
            } else {
                frame.size.height = 125.0*CGFloat(((self.sub?.id?.count)!)/3+1)
            }
            }
            cell1?.collectionView.frame = frame
            var frame1: CGRect = cell1!.frame
            frame1.size.height = (cell1?.nameLabel.frame.size.height)!+(cell1?.collectionView.frame.size.height)!
            cell1?.frame = frame1
            if ((self.sub?.id) != nil) {
                print(cell1!.nameLabel.frame.height+(CGFloat((self.sub?.id?.count)!))*100)
                if((self.sub?.id?.count)!%3==0) {
                    return cell1!.nameLabel.frame.height+((CGFloat((self.sub?.id?.count)!)/3)*130)
                } else {
                    return cell1!.nameLabel.frame.height+(((CGFloat((self.sub?.id?.count)!)/3)+1)*110)
                }
            }
//            print(cell1?.nameLabel.frame.size.height)
//            
//            if ((self.sub?.id) != nil) {
//                print(100*CGFloat((self.sub?.id?.count)!/3))
//                print((cell1?.nameLabel.frame.size.height)!+(100*CGFloat((self.sub?.id?.count)!/3)))
//                print(self.sub?.id?.count)
//                return (cell1?.nameLabel.frame.size.height)!+(100*CGFloat((self.sub?.id?.count)!/3))
//            }
            return 0.0
        }else if indexPath.row == 2{
            return 140.0
        }else if indexPath.row == 3{
            return 200.0
        } else if indexPath.row == 4 {
            return 200.0
        }else if indexPath.row == 5{
            var screenSize: CGRect!
            var screenWidth: CGFloat!
            //var screenHeight: CGFloat!
            screenSize = UIScreen.main.bounds
            screenWidth = screenSize.width
//            //screenHeight = screenSize.height
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            layout.itemSize = CGSize(width: screenWidth/5, height: screenWidth/5)
           layout.minimumInteritemSpacing = 1
            layout.minimumLineSpacing = 1
            cell5?.collectionView!.collectionViewLayout = layout
//            var frame: CGRect = cell5!.collectionView.frame
//            frame.size.height = (cell5?.collectionView.frame.size.width)!/5*2
//            cell5?.collectionView.frame = frame
//            var frame1: CGRect = cell5!.frame
//            frame1.size.height = (cell5?.headerLabel.frame.size.height)!+(cell5?.collectionView.frame.size.height)!
//            cell5?.frame = frame1
            if ((cell5?.nameArray?.count) != nil) {
                print(cell5!.headerLabel.frame.height+(CGFloat((cell5?.nameArray?.count)!))*100)
                if((cell5?.nameArray?.count)!%2==0) {
                    return cell5!.headerLabel.frame.height+((CGFloat((cell5?.nameArray?.count)!)/2)*110)
                } else {
                    return cell5!.headerLabel.frame.height+(((CGFloat((cell5?.nameArray?.count)!)/2)+1)*100)
                }
            }
            return 0.0
        }else{
            print(cell6?.headerLabel.frame.size.height)
            print(cell6?.collectionView.frame.size.height)
            print(cell6?.nameArray?.count)
            print((cell6?.headerLabel.frame.size.height)!+((cell6?.collectionView.frame.size.height)!*CGFloat((cell6?.nameArray?.count)!)))
//            self.homeTableView.contentSize = CGSize(width: self.view.frame.size.width, height: (cell1?.frame.size.height)!+(cell2?.frame.size.height)!+(cell3?.frame.size.height)!+(cell4?.frame.size.height)!+(cell5?.frame.size.height)!+cell6?.headerLabel.frame.size.height+(85*CGFloat((cell6?.nameArray?.count)!+1))
            return (cell6?.headerLabel.frame.size.height)!+(85*CGFloat((cell6?.nameArray?.count)!+1))
        }

    }
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row==1 {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
            nextViewController.data = cell1?.data
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
    }
    
    
    @objc func getSubCategory(){
        let params: String
        
        params =  "category_id=9"
        
        let urlString = BASE_URL + "sub-category?" + params
        print(urlString)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        
        var request = URLRequest(url: url! as URL)
        //request.addValue("Bearer \(_token)", forHTTPHeaderField: "Authorization")
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
                            var  data: NSArray?
                            let idArray: NSMutableArray? = NSMutableArray()
                            let  ukeyArray: NSMutableArray? = NSMutableArray()
                            let nameArray: NSMutableArray? = NSMutableArray()
                            let  slugArray: NSMutableArray? = NSMutableArray()
                            let titleArray: NSMutableArray? = NSMutableArray()
                            let  imageArray: NSMutableArray? = NSMutableArray()
                            let image_pathArray: NSMutableArray? = NSMutableArray()
                            let  keywordsArray: NSMutableArray? = NSMutableArray()
                            let descripArray: NSMutableArray? = NSMutableArray()
                            let  typeArray: NSMutableArray? = NSMutableArray()
                            let parentArray: NSMutableArray? = NSMutableArray()
                            let  statusArray: NSMutableArray? = NSMutableArray()
                            let created_atArray: NSMutableArray? = NSMutableArray()
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                print("id:- \(data!)")
                                for i in data! {
                                    let object = i as? NSDictionary
                                    print(object?.value(forKey: "id"))
                                    idArray?.add(object?.value(forKey: "id"))
                                    ukeyArray?.add(object?.value(forKey: "ukey"))
                                    nameArray?.add(object?.value(forKey: "name"))
                                    slugArray?.add(object?.value(forKey: "slug"))
                                    titleArray?.add(object?.value(forKey: "title"))
                                    imageArray?.add(object?.value(forKey: "image"))
                                    image_pathArray?.add(object?.value(forKey: "image_path"))
                                    keywordsArray?.add(object?.value(forKey: "keywords"))
                                    descripArray?.add(object?.value(forKey: "description"))
                                    typeArray?.add(object?.value(forKey: "type"))
                                    parentArray?.add(object?.value(forKey: "parent"))
                                    statusArray?.add(object?.value(forKey: "status"))
                                    created_atArray?.add(object?.value(forKey: "created_at"))
                                }
                                
                                let sub_category = SubCategoryModel.init(id: idArray, ukey: ukeyArray, name: nameArray, slug: slugArray, title: titleArray, image: imageArray, image_path: image_pathArray, keywords: keywordsArray, descrip: descripArray, type: typeArray, parent: parentArray, status: statusArray, created_at: created_atArray)
                                self.sub = sub_category
                                self.homeTableView.reloadData()
                            }else{
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
    
//    /**
//     *  Array to display menu options
//     */
//    @IBOutlet var tblMenuOptions : UITableView!
//
//    /**
//     *  Transparent button to hide menu
//     */
//    @IBOutlet var btnCloseMenuOverlay : UIButton!
//
//    /**
//     *  Array containing menu options
//     */
//    var arrayMenuOptions = [Dictionary<String,String>]()
//
//    /**
//     *  Menu button which was tapped to display the menu
//     */
//    var btnMenu : UIButton!
//
//    /**
//     *  Delegate of the MenuVC
//     */
//    var delegate : SlideMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
//        spinner?.startAnimating()
        //self.navigationItem.setHidesBackButton(true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimating(view: self.view)
        
        //let height = CGFloat(80)
        //self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100.0)
        if (self.homeTableView.contentSize.height < self.homeTableView.frame.size.height) {
            self.homeTableView.alwaysBounceVertical = false
        }
        else {
            self.homeTableView.alwaysBounceVertical = true
        }
        if (UserDefaults.standard.value(forKey:"userId") != nil) {
            
            self.sendToken()
        }else{
            
            var myCarts: [MyCart] = []
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            myCarts = try! context.fetch(MyCart.fetchRequest())
            self.getAllBanners()
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func sendToken(){
        let params: String
        
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
                            var  data: NSDictionary?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSDictionary
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                let userDetails = UserDetailsModel(id: data!["id"] as? Int, roleId: data!["role_id"] as? Int, name: data!["name"] as? String, mobile: data!["mobile"] as? String, email: data!["email"] as? String, is_active: data!["is_active"] as? Bool, cartCount: data!["cart_count"] as? Int)
//                                UserDefaults.standard.set(data!["id"], forKey: "userId")
//                                UserDefaults.standard.set(data!["name"], forKey: "userName")
//                                UserDefaults.standard.set(data!["mobile"], forKey: "mobile")
//                                UserDefaults.standard.set(data!["avatar"], forKey: "img")
//                                UserDefaults.standard.set(data!["cart_count"], forKey: "cartCount")
                                
                                self.getAllBanners()
                            }else{
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
    
    @objc func getAllBanners(){
        let params: String
        
        params =  ""
        
        let urlString = BASE_URL + "slider?" + params
        print(urlString)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        
        var request = URLRequest(url: url! as URL)
       
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
                            var  data: NSArray?
                            self.bannerImageArray = NSMutableArray()
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSArray
                            print("Error:- \(error!)")
                            print("Message:- \(message!)")
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                for i in data! {
                                    let object = i as! NSDictionary
                                    self.bannerImageArray.add(object["image"])
                                }
                                
                                self.getSubCategory()
                                self.activityIndicator.stopAnimating()
                            }else{
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
