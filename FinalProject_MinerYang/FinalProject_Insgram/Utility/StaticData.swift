//
//  StaticData.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/10/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import Foundation
import Firebase

// MARK: - Root References

let DB_REF = Database.database().reference()
let STORAGE_REF = Storage.storage().reference()

// MARK: - Storage References

let STORAGE_PROFILE_IMAGES_REF = STORAGE_REF.child("profile_images")

// MARK: - Database References

let USER_REF = DB_REF.child("users")

let USER_FOLLOWER_REF = DB_REF.child("user-followers")
let USER_FOLLOWING_REF = DB_REF.child("user-following")

let POSTS_REF = DB_REF.child("posts")
let USER_POSTS_REF = DB_REF.child("user-posts")

//

let USER_LIKES_REF = DB_REF.child("user-likes")
let POST_LIKES_REF = DB_REF.child("post-likes")
//
let COMMENT_REF = DB_REF.child("comments")
//

