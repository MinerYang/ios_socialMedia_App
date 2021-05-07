//
//  UserProfileHeaderCell.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/9/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeaderCell: UICollectionViewCell {
    
    weak var delegate: UserProfileHeaderDelegate?
    var user: User? {
        
        didSet {
            
            // configure edit profile button
            configureEditProfileFollowButton()
            
            // set user stats
            setUserStats(for: user)
            
            let fullName = user?.name
            nameLabel.text = fullName
            
            guard let profileImageUrl = user?.profileImageUrl else{
                print("profile image url is empty")
                return
            }
//            print("profile image url \(profileImageUrl)")
            profileImageView.loadImage(with: profileImageUrl)
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Lily Ellen"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    let postLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        return label
    }()
    lazy var followerLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
//        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
//        attributedText.append(NSAttributedString(string: "follwers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
//        label.attributedText = attributedText
        return label
    }()
   lazy var followingLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
//        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
//        attributedText.append(NSAttributedString(string: "follwings", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
//        label.attributedText = attributedText
   
    return label
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        //button.isUserInteractionEnabled = true
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleEditFollow), for: .touchUpInside)
        return button
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle.grid.3x3"), for: .normal)
        return button
    }()


    
    
    
    // MARK: -INIT
    override init(frame: CGRect) {
        super.init(frame : frame)
        print("into header view class")
        
        //
        self.contentView.isUserInteractionEnabled = false
        
        //self.backgroundColor = .red
        //
        self.addSubview(profileImageView)
        adjustImageView()
        //
        self.addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //
        configureUserStat()
        //
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postLabel.bottomAnchor, left: postLabel.leftAnchor, bottom: nil, right: self.rightAnchor , paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 12, width: 0, height: 30)
//         editProfileFollowButton.addTarget(self, action: #selector(handleEditFollwBtn), for: .touchUpOutside)
        
        configureBottomToolBar()
        //
    }
    
    //
    func configureBottomToolBar() {
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    //
    func configureUserStat(){
        let stackView = UIStackView(arrangedSubviews:  [postLabel, followerLabel, followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        //stackView.spacing = 25.0
        
        self.addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    func setAnchor(){
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        editProfileFollowButton.anchor(top: postLabel.bottomAnchor, left: postLabel.leftAnchor, bottom: nil, right: self.rightAnchor , paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 12, width: 0, height: 30)
    }
    
    func adjustImageView(){
//        let width = profileImageView.frame.width
//        let height = profileImageView.frame.height
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        //profileImageView.frame = CGRect(x: width, y: height, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80/2.0

    }
    
    
    
    
    
    // - API
    func configureEditProfileFollowButton() {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            print("no currentuser")
            return }
        guard let user = self.user else { return }
        print("current user\(String(describing: user.username))")
        if currentUid == user.uid {
            // configure button as edit profile
            editProfileFollowButton.setTitle("Edit Profile", for: .normal)
        } else {
            // configure button as follow button
            editProfileFollowButton.setTitleColor(.white, for: .normal)
            editProfileFollowButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            user.checkIfUserIsFollowed(completion: { (followed) in
                if followed {
                    self.editProfileFollowButton.setTitle("Following", for: .normal)
                } else {
                    self.editProfileFollowButton.setTitle("Follow", for: .normal)
                }
            })
        }
    }
    
    func setUserStats(for header: User?) {
        print("set user stats")
        guard let uid = user?.uid else { return }
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
            print("number of followers : \(numberOfFollwers!)")
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollwers!)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            self.followerLabel.attributedText = attributedText
        }
            
            // get number of following
        USER_FOLLOWING_REF.child(uid).observe(.value) { (snapshot) in
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                    numberOfFollowing = snapshot.count
            } else {
                    numberOfFollowing = 0
            }
            print("number of followings : \(numberOfFollowing!)")
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowing!)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            self.followingLabel.attributedText = attributedText
        }
            
            // get number of posts
            USER_POSTS_REF.child(uid).observeSingleEvent(of: .value) { (snapshot) in
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
                let postCount = snapshot.count
    
                let attributedText = NSMutableAttributedString(string: "\(postCount)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
                attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
    
                //
                self.postLabel.attributedText = attributedText
            }
        }
    
    
    // HANDLERS
    @objc func handleEditFollow(){
        print("handle edit profile follow")
        delegate?.handleEditFollowTapped(for: self)
    }
    
    
    
//    func setUserStats(for user: User?) {
//        delegate?.setUserStats(for: self)
//    }
    
   
    
    
    
    
    //
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

