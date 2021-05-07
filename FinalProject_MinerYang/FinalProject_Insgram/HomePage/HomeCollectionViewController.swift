//
//  HomeCollectionViewController.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/8/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class HomeCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout, HomeCellDelegate {
    
    // MARK: -properties
    var posts = [Post]()
    var viewsinglePost = false
    var singlePost : Post?
    var post : Post?

    // MARK: -INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        print("into home page controller")
        self.collectionView.backgroundColor = .white
        self.navigationItem.title = "Home"

        // Register cell classes
        self.collectionView!.register(HomeProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        if !viewsinglePost{
            fetchPosts()
        }
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
        let width = view.frame.width 
        var height = width + 8 + 40 + 8
        // stackview
        height += 50
        // labels and description
        height += 60
        return CGSize(width: width, height: height)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //return posts.count
        if viewsinglePost {
            return 1
        }
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeProfileCell
    
        // Configure the cell
        cell.delegate =  self
        
        if viewsinglePost {
            if let post =  self.singlePost {
                cell.post = post
            }
        } else {
            cell.post = posts[indexPath.row]
        }
//        self.post = cell.post
        
        return cell
    }

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
    
    @IBAction func handleSignOut(_ sender: UIBarButtonItem) {
        print("click logout button")
        do{
            try Auth.auth().signOut()
            print("log out successfully")
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }catch{
            print("failed to sign out")
    }
        
        //
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        // add alert action
//        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (_) in
//            do{
//                try Auth.auth().signOut()
//                print("log out successfully")
//            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//            }catch{
//                print("failed to sign out")
//            }
//        }))
//
//        // add cancel action
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(alert, animated: true, completion: nil)
       
        
    }
    
    // MARK: HomeCellDelegate protocol
    func handleUsernameTapped(for cell: HomeProfileCell) {
        //print("user name clicked")
        // fetch User and navi to the user profile page
        guard let post = cell.post else {return}
        let uservc = UserProfileCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        uservc.user = post.user
        uservc.userToLoad = post.user
        navigationController?.pushViewController(uservc, animated: true)
        
    }
       
       
    func handleLikeTapped(for cell: HomeProfileCell) {
//        print("user likes clicked")
        guard let post = cell.post else{return}
        // like to unlike
        if post.didLike {
            post.adjustLikes(addLike: false)
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            updateLikesStructure(postid: post.postId, addLike: false)
        }else{
        // unlike to like
            // change the likes data into firebase
            post.adjustLikes(addLike: true)
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            updateLikesStructure(postid: post.postId, addLike: true)
        }
        
        // update likes labels text
        guard let likes = post.likes else{return}
        cell.likesLabel.text = "\(likes) likes"
    }
       
    func handleCommentTapped(for cell: HomeProfileCell) {
        print("user comment clicked")
        let editvc = EditCommentViewController()
        guard let postid = cell.post?.postId else{return}
        editvc.postId = postid
        //
        guard let ownerUid = cell.post?.ownerUid else {return}
        Database.fetchUser(with: ownerUid) { (user) in
            editvc.postOwner = user
        }
        navigationController?.pushViewController(editvc, animated: true)
    }
    
    func handleViewCommentsTappeed(for cell: HomeProfileCell) {
        print("View comments clicked")
        let vc = CommentViewController(collectionViewLayout: UICollectionViewFlowLayout())
        guard let postid = cell.post?.postId else{return}
        vc.postId = postid
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // MARK: API
    func fetchPosts(){
        POSTS_REF.observe(.childAdded) { (snapshot) in
            let postid =  snapshot.key
            
            Database.fetchPost(with: postid) { (post) in
                self.posts.append(post)
                self.posts.sort { (post1, post2) -> Bool in
                    return post1.creationDate > post2.creationDate
                }
                //print("post description:\(post.description)")
                self.collectionView.reloadData()
            }
            //
        }
    }
    
    // update likes to USER-LIKES and POST-LIEKS structure
    func updateLikesStructure(postid: String, addLike: Bool){
        guard let currentUid = Auth.auth().currentUser?.uid else{return}
        
        if addLike{
            // upadte USER_LIKES
            USER_LIKES_REF.child(currentUid).updateChildValues([postid:1 ])
            // upadte POST_LIKES
            POST_LIKES_REF.child(postid).updateChildValues([currentUid:1])
        }else{
            // remove like from USER_LIKES
            USER_LIKES_REF.child(currentUid).child(postid).removeValue()
            // remove likes from POST_LIKES
            POST_LIKES_REF.child(postid).child(currentUid).removeValue()
        }
        
    }
    
    
}
