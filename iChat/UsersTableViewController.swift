//
//  UsersTableViewController.swift
//  iChat
//
//  Created by Anthony Howe on 12/26/19.
//  Copyright © 2019 Anthony Howe. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD


class UsersTableViewController: UITableViewController, UISearchResultsUpdating {
    
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var filterSegementedControl: UISegmentedControl!
    
    var allUsers: [FUser] = []
    var filteredUsers: [FUser] = []
    var allUsersGrouped = NSDictionary() as! [String : [FUser]]
    var sectionTitleList: [String] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Users"
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        loadUsers(filter: kCITY)
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != ""{
            return 1
            
        }else{
            return allUsersGrouped.count
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredUsers.count
            
        }else{
            
            //Find section title
            
            let sectionTitle = self.sectionTitleList[section]
            
            //User for given title
            let users = self.allUsersGrouped[sectionTitle]
            
            return users!.count
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
        
        var user: FUser
        
        if searchController.isActive && searchController.searchBar.text != ""{
            user = filteredUsers[indexPath.row]
        }else{
            let sectionTitle = self.sectionTitleList[indexPath.section]
            let users = self.allUsersGrouped[sectionTitle]
            user = users![indexPath.row]
        }
        
        cell.generateCellWith(fUser: user, indexPath: indexPath)
        
        return cell
        
    }
    //MARK: Table view delegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != ""{
            return ""
        }else{
            return sectionTitleList[section]
        }
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchController.isActive && searchController.searchBar.text != ""{
            
            return nil
        }else{
            
            return sectionTitleList
        }
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int{
        return index
    
    }
    
    func loadUsers(filter: String){
        
        ProgressHUD.show()
        
        var query: Query!
        
        switch filter {
        case kCITY:
            query = reference(.User).whereField(kCITY, isEqualTo: FUser.currentUser()!.city).order(by: kFIRSTNAME, descending: false)
        case kCOUNTRY:
            query = reference(.User).whereField(kCOUNTRY, isEqualTo: FUser.currentUser()!.country).order(by: kFIRSTNAME, descending: false)
        default:
            query = reference(.User).order(by: kFIRSTNAME, descending: false)
            
        }
        
        query.getDocuments { (snapshot, error) in
            
            self.allUsers = []
            self.sectionTitleList = []
            self.allUsersGrouped = [:]
            
            if error != nil {
                
                print(error!.localizedDescription)
                ProgressHUD.dismiss()
                self.tableView.reloadData()
                return
            }
            
            guard let snapshot = snapshot else {
                ProgressHUD.dismiss();return
            }
            if !snapshot.isEmpty{
                
                for userDictionary in snapshot.documents{
                    
                    let userDictionary = userDictionary.data() as NSDictionary
                    let fUser = FUser.init(_dictionary: userDictionary)
                    
                    if fUser.objectId != FUser.currentId(){
                        self.allUsers.append(fUser)
                    }
                }
                
                self.splitDataIntoSections()
                self.tableView.reloadData()
                
            }
            self.tableView.reloadData()
            ProgressHUD.dismiss()
        }
    }
    
    //MARK: IBActions
    
    @IBAction func filterSegmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadUsers(filter: kCITY)
        case 1:
            loadUsers(filter: kCOUNTRY)
        case 2:
            loadUsers(filter: "")
        default:
            return
        }
    }
    
    //MARK: Search controller functions
    
    func filterContentForSearchText(searchText : String, scope : String = "All"){
        
        filteredUsers = allUsers.filter({ (user) -> Bool in
            
            return user.firstname.lowercased().contains(searchText.lowercased())
            }
            
        )
        tableView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    //MARK: Helper functions
    
    fileprivate func splitDataIntoSections(){
        
        var sectionTitle: String = ""
        
        for i in 0..<self.allUsers.count{
            
            let currentUser = self.allUsers[i]
            
            let firstChar = currentUser.firstname.first!
            
            let firstCharString = "\(firstChar)"
            
            
            if firstCharString != sectionTitle{
                
                sectionTitle = firstCharString
                self.allUsersGrouped[sectionTitle] = []
                self.sectionTitleList.append(sectionTitle)
            }
            self.allUsersGrouped[firstCharString]?.append(currentUser)
            
        }
        
    }
}
