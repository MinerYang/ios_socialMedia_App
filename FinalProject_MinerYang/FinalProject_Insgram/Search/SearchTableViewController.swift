//
//  SearchTableViewController.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/8/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import UIKit
import Firebase


private let reuseIdentifier = "SearchUserCell"
class SearchTableViewController: UITableViewController,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout , UISearchBarDelegate{
    
    var users = [User]()
    var filteredUser = [User]()
    var searchBar  = UISearchBar()
    var inSearchMode = false
    
    // MARK: -INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = "Search"
        self.tableView.register(SearchUserCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.tableView.separatorInset = UIEdgeInsets(top:0, left:64, bottom:0, right:0 )
        
        //
        configureSearchBar()
        //
        fetchUsers()
    }
    
    // MARK: SearchBar
    func configureSearchBar(){
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.barTintColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        searchBar.tintColor = .black
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //
        //print("search bar edited")
        let text = searchText.lowercased()
        //print("text:\(text)")
        if searchText.isEmpty || searchText == " "{
            inSearchMode = false
            //self.tableView.reloadData()
        }else{
            inSearchMode = true
            filteredUser = users.filter({ (user) -> Bool in
                return user.username.lowercased().contains(text)
            })
            //self.tableView.reloadData()
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        inSearchMode = false
        searchBar.text = nil
        tableView.reloadData()
    }
    
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if inSearchMode {
            return filteredUser.count
        }else{
            return users.count
        }
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
       return 60
   }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("table view cell isSearchMode: \(inSearchMode)")
       
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchUserCell

        // Configure the cell...
        var user : User!
        if inSearchMode{
            print("filter size:\(filteredUser.count)")
            user = filteredUser[indexPath.row]
            //print(user.username)
        }else{
            print("size:\(users.count)")
            user = users[indexPath.row]
        }
        cell.user = user

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let user = users[indexPath.row]
        //print("username is \(user.username)")
        let user : User?
        if inSearchMode{
            user = filteredUser[indexPath.row]
        }else{
            user = users[indexPath.row]
        }
        
        //
        let userprofilevc = UserProfileCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        //pass value to userprofileVC
        userprofilevc.userToLoad = user
        // Push view controller
        self.navigationController?.pushViewController(userprofilevc, animated: true)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - API
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot ) in
            let uid = snapshot.key
            guard let dic = snapshot.value as? Dictionary<String ,AnyObject> else{
                return
            }
            // construct user
            let user = User(uid: uid, dictionary: dic)
            self.users.append(user)
            
            // reload tavbleview
            self.tableView.reloadData() 
        }
       
    }

}
