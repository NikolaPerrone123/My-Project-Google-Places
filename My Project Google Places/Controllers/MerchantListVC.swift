//
//  MerchantListVC.swift
//  My Project Google Places
//
//  Created by Nikola Popovic on 4/2/18.
//  Copyright © 2018 Nikola Popovic. All rights reserved.
//

import UIKit
import EXTView
import TTSegmentedControl

class MerchantListVC: UIViewController {
    
    @IBOutlet weak var segment: TTSegmentedControl!
    @IBOutlet weak var searchView: EXTView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var segmentRoundView: UIView!
    @IBOutlet weak var merchantsTable : UITableView!
    @IBOutlet weak var heightSearchViewConstraints: NSLayoutConstraint!
    @IBOutlet weak var heightGrayLineConstraints: NSLayoutConstraint!
    
    private let cellIdentifier = "MerchantCell"
    private var listOfMerchants = [Merchant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       getNearByPlaces()
       setTable()
       segmentContorl()
       Utility.formatNavBar(navBar: (self.navigationController?.navigationBar)!)
       defaultConstraints()
       searchPlaces()
    }
    
    func setTable(){
        self.merchantsTable.dataSource = self
        self.merchantsTable.delegate = self
        self.merchantsTable.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func segmentContorl(){
        segment.itemTitles = ["CFC", "ALL"]
    }
    
    func animateSearchView(present : Bool) {
        self.heightSearchViewConstraints.constant = present == true ? 50.0 : 0.0
        self.heightGrayLineConstraints.constant = present == true ? 2.0 : 0.0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func defaultConstraints(){
        self.heightGrayLineConstraints.constant = 0.0
        self.heightSearchViewConstraints.constant = 0.0
    }
    
    @IBAction func searchAction(_ sender: UIBarButtonItem) {
        animateSearchView(present: true)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        animateSearchView(present: false)
    }
}

// MARK: API
extension MerchantListVC {
    func getNearByPlaces(){
        GoogleHelper.sharedInstance.getHoodPlaces { (error, merchants) in
            if error == nil {
                self.listOfMerchants = [Merchant]()
                self.listOfMerchants = merchants!
                self.merchantsTable.reloadData()
            } else {
                // Error
                print("GET HOOD ERROR!!! \(String(describing: error))")
            }
        }
    }
    
    func searchPlaces(){
        
        
        GoogleHelper.sharedInstance.searchPlacesSDK(text: "a") { (error, merchants) in
            if error == nil {
                print(merchants as Any)
            } else {
                print(error as Any)
            }
        }
        
//        APIClient.sharedInstance.searchPlaces { (code, error, response) in
//            if error == nil {
//                print(response as Any)
//            } else {
//                print(error as Any)
//            }
//        }
    }
}

//MARK: Table View Data Source
extension MerchantListVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfMerchants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MerchantCell
        let merchant = self.listOfMerchants[indexPath.row]
        cell.name.text = merchant.name
        cell.address.text = merchant.address
        cell.imageOfMerchant.image = merchant.image ?? UIImage(named: "merchant_logo")
        return cell
    }
}

// MARK: Table View Delegate
extension MerchantListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
