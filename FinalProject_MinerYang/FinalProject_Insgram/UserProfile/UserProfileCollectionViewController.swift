//
//  UserProfileCollectionViewController.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/8/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import UIKit
import Firebase

private let headerIdentifier = "HeaderCell"
private let reuseIdentifier = "userPostCell"


class UserProfileCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    
    var posts = [Post]()
    var user : User?
    var userToLoad : User?
       
    func handleEditFollowTapped(for header: UserProfileHeaderCell) {
        print("Tapped function")
        guard let user = header.user else { return }
        print("user \(String(describing: user.username))")
        if header.editProfileFollowButton.titleLabel?.text == "Edit Profile" {
            
            let editProfileController = EditProfileController()
            editProfileController.user = user
            editProfileController.userProfileController = self
            let navigationController = UINavigationController(rootViewController: editProfileController)
            present(navigationController, animated: true, completion: nil)
            
        } else {
            // handles user follow/unfollow
            if header.editProfileFollowButton.titleLabel?.text == "Follow" {
                header.editProfileFollowButton.setTitle("Following", for: .normal)
                // FOLLOW USER
                print("click follow on user profile page")
                user.follow()
            } else {
                header.editProfileFollowButton.setTitle("Follow", for: .normal)
                // UNFOLLOW USER
                user.unfollow()
            }
        }
    }
    
    func setUserStats(for header: UserProfileHeaderCell) {
        print("set user stats")
        guard let uid = header.user?.uid else { return }
        print("stats uid \(uid)")
        var numberOfFollwers: Int!
        var numberOfFollowing: Int!
        
        // get number of followers
        USER_FOLLOWER_REF.child(uid).observe(.value) { (snapshot) in
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                numberOfFollwers = snapshot.count
            } else {
                numberOfFollwers = 0
            }
            print("number of followers : \(String(describing: numberOfFollwers))")
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollwers!)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            header.followerLabel.attributedText = attributedText
        }
        
        // get number of following
        USER_FOLLOWING_REF.child(uid).observe(.value) { (snapshot) in
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                numberOfFollowing = snapshot.count
            } else {
                numberOfFollowing = 0
            }
            print("number of followings : \(String(describing: numberOfFollowing))")
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowing!)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            header.followingLabel.attributedText = attributedText
        }
        
//        // get number of posts
//        USER_POSTS_REF.child(uid).observeSingleEvent(of: .value) { (snapshot) in
//            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
//            let postCount = snapshot.count
//
//            let attributedText = NSMutableAttributedString(string: "\(postCount)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
//            attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
//
//            header.postsLabel.attributedText = attributedText
//        }
    }
    
    
    // MARK: UserProfileHeaderDelegate Protocols
    func handleFollowersTapped(for header: UserProfileHeaderCell) {
    }
    
    func handleFollowingTapped(for header: UserProfileHeaderCell) {
        // todo
    }
    
    
//    var user : User?
//    var userToLoad : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("user profile view loaded")
        self.collectionView.backgroundColor = .white
        //self.collectionView.isUserInteractionEnabled = false
        /*
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.widestCellWidth, height: 200)
         
       //print("widestcellwidth : \(collectionView.widestCellWidth)")
        collectionView.collectionViewLayout = layout
         */
        
        print(" view width:\(collectionView.frame.width)")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UserPostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView!.register(UserProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        

        // Do any additional setup after loading the view.
//        if self.user == nil {
//            fetchCurrentUserData()
//        }
        if userToLoad == nil {
            fetchCurrentUserData()
        }
        
        // fetch Posts
        fetchPost()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UICollectionViewFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let width = (view.frame.width - 2) / 3
           return CGSize(width: width, height: width)
       }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        print("into resize collection view")
        return CGSize(width: collectionView.frame.width, height: 200)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }

//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserProfileHeaderCell
//
//        // Configure the cell
//        print("into register collection cell view")
//        // set the user in header view
//        if let user = self.user {
//            cell.user = user
//        } else if let userToLoad = self.userToLoad{
//            cell.user = userToLoad
//            self.navigationItem.title = userToLoad.username
//        }
//        cell.delegate = self
//        return cell
//    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableCell(withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeaderCell
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeaderCell
        // Configure the cell
        print("into register collection header")
        // set the user in header view
//        header.user = self.user
//        navigationItem.title = user?.username
        
        if let user = self.user {
            header.user = user
        } else if let userToLoad = self.userToLoad{
            header.user = userToLoad
            self.navigationItem.title = userToLoad.username
        }
        header.delegate = self
        return header

    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("into register post cell ")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserPostCell
        
        cell.post = posts[indexPath.item]
        //print("#####cell view current user:\(user?.uid)")
        return cell
    }
    
    // get the post we need
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let homevc = HomeCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        homevc.viewsinglePost = true
        homevc.singlePost = posts[indexPath.row]
        navigationController?.pushViewController(homevc, animated: true)
        
    }
    
    
    
    
    
    
//    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
//        print("into header view")
//        let header = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//        view.addSubview(header)
//    }
    
    
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    //
//    @objc func handleEditFollwBtn(_ sender: UIButton){
//           print("handle edit / follow button")
//    }
    
    // MARK -API
    func fetchCurrentUserData(){
        guard let currentuid  = Auth.auth().currentUser?.uid else{ return  }
        print("current uid is \(currentuid)")
    Database.database().reference().child("users").child(currentuid).observeSingleEvent(of: .value) { (snapshot) in
            //print("snapshot \(snapshot)")
        guard let dic = snapshot.value as? Dictionary<String, AnyObject> else{ return }
        let id = snapshot.key
        let user = User(uid: id, dictionary: dic )
        self.user = user
        self.navigationItem.title = user.username
        self.collectionView?.reloadData()

        }
        
    }
    
    func fetchPost(){
//        guard let currentuid = Auth.auth().currentUser?.uid else{
//            return
//        }
        var uid = ""
        if let usertoload = self.userToLoad{
            uid = usertoload.uid
        }else{
            guard let currenuid = Auth.auth().currentUser?.uid else{
                return
            }
            uid = currenuid
        }
        
        print("uid: \(uid)")
        USER_POSTS_REF.child(uid).observe(.childAdded) { (snapshot) in
            //print(snapshot)
            let postId = snapshot.key
            POSTS_REF.child(postId).observeSingleEvent(of: .value) { (snapshot) in
                //print(snapshot)
                guard let dic = snapshot.value as? Dictionary<String , AnyObject> else{
                    return
                }
                let  post = Post(postId: postId, dictionary: dic)
                self.posts.append(post)

                // sort by post date
                self.posts.sort { (post1, post2) -> Bool in
                    return post1.creationDate > post2.creationDate
                }
                self.collectionView.reloadData()
            }

        }
    }

}




extension UICollectionView {
    var widestCellWidth: CGFloat {
        let insets = contentInset.left + contentInset.right
        return bounds.width - insets
    }
}


