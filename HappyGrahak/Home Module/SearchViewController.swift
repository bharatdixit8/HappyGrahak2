//
//  SearchViewController.swift
//  HappyGrahak
//
//  Created by IOS on 06/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    
    let kCellIdentifier = "Cell"
    
    var searchController: UISearchDisplayController!
    var tableView: UITableView!
    var nameArray: NSMutableArray = NSMutableArray() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var tableDataFiltered = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchProducts()
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        self.view.addSubview(tableView)
        
        let searchBar = UISearchBar.init(frame: CGRect(x: 0, y: 64.0, width: self.view.frame.size.width, height: 50.0))
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.barTintColor = UIColor.init(red: 23.0/255.0, green: 39.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        self.view.addSubview(searchBar)
        self.extendedLayoutIncludesOpaqueBars = true
//        searchController = UISearchDisplayController(searchBar: searchBar, contentsController: self)
//        searchController.searchResultsDataSource = self
//        searchController.searchResultsDelegate = self
//        searchController.searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellIdentifier)
        
        //tableData = ["Foo", "Bar", "Baz"]
        tableView.frame = self.view.bounds
        var frame: CGRect = tableView.frame
        frame.origin.y = searchBar.frame.origin.y+searchBar.frame.size.height
        tableView.frame = frame
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = self.view.bounds
//        tableView.frame.origin.y = 64.0
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //searchController.displaysSearchBarInNavigationBar = true
        //searchController.dismiss(animated: false, completion: nil)
    }
    
    @objc func searchProducts(){
        var params: String = ""
        let query: String = ""
        params =  "query=\(query)"
        
        
        let urlString = BASE_URL + "product-search-autocomplete?" + params
        print(urlString)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        
        var request = URLRequest(url: url! as URL)
        //let token: String = UserDefaults.standard.value(forKey:"token") as! String
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
                            //var nameArray: NSMutableArray = NSMutableArray()
                            
                            var  data: NSArray?
                            
                            error = result["error"] as? Bool
                            message = result["msg"] as? NSArray
                            data = result["data"] as? NSArray
                            //                            print("Error:- \(error!)")
                            //                            print("Message:- \(message!)")
                            //print("Data:- \(data!)")
                            if (!(error!)){
                                print("\(data!)")
                                for index in data! {
                                    let object = index as! NSDictionary
                                    self.nameArray.add(object.value(forKey: "name"))
                                    self.tableView.reloadData()
                                }
                            }else{
                            }
                        }
                    }
                    else if responseStatus == ServerErr
                    {
                        MAIN_QUEUE {
                            //APP_DELEGATE.hideHud()
                            //                            ConveienceClass.showSimpleAlert(title: "Error!", message: result?.value(forKey: "Message") as! String, controller: self)
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
                        //                        ConveienceClass.showSimpleAlert(title: "Error!", message: (error?.localizedDescription)!, controller: self)
                    }
                }
            })
            
        }
    }
    
    // UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tableDataFiltered.count>0 {
            return self.tableDataFiltered.count
        }
        
        if let count: Int = nameArray.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView!, cellForRowAt indexPath: IndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier)
        
        var data: String
        if self.tableDataFiltered.count>0 {
            data = tableDataFiltered[indexPath.row]
        } else {
            data = nameArray[indexPath.row] as! String
        }
        
        cell?.textLabel?.text = data
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let currentCell = tableView.cellForRow(at: indexPath!) as! UITableViewCell
        
        print(currentCell.textLabel!.text)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
        nextViewController.flag = true
        nextViewController.searchString = currentCell.textLabel!.text
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
        var pre:NSPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchText)
        print((nameArray.filtered(using: pre) as NSArray) as! [String])
        tableDataFiltered = (nameArray.filtered(using: pre) as NSArray) as! [String]
        self.tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(searchBar.text)")
    }
    
}
