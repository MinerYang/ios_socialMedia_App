//
//  Post.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/14/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    var description: String!
    var likes: Int!
    var imageUrl: String!
    var ownerUid: String!
    var creationDate: Date!
    var postId: String!
    var user: User?
    var didLike = false
    
    init(postId: String!, user: User, dictionary: Dictionary<String, AnyObject>) {
        
        self.postId = postId
        
        self.user = user
        
        if let description = dictionary["description"] as? String {
            self.description = description
        }
        
        if let likes = dictionary["likes"] as? Int {
            self.likes = likes
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let ownerUid = dictionary["ownerUid"] as? String {
            self.ownerUid = ownerUid
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
    
    init(postId: String!, dictionary: Dictionary<String, AnyObject>) {
        
        self.postId = postId
        
        if let description = dictionary["description"] as? String {
            self.description = description
        }
        
        if let likes = dictionary["likes"] as? Int {
            self.likes = likes
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let ownerUid = dictionary["ownerUid"] as? String {
            self.ownerUid = ownerUid
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
    
    func adjustLikes(addLike:Bool){
        if addLike{
            likes = likes+1
            didLike = true
        }else{
            guard likes > 0 else{return}
            likes = likes - 1
            didLike = false
        }
        //print("this post has String(describing: \(lik)es) likes")
        
        // update Post structure likes value
        POSTS_REF.child(postId).child("likes").setValue(likes)
        
    }

    //
}

