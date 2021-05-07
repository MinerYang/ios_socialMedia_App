//
//  HomeProfileCell.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/15/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import UIKit
import Firebase

class HomeProfileCell: UICollectionViewCell {
    
    // MARK: Properties
    var delegate: HomeCellDelegate?
    
    var post : Post? {
        didSet{
            guard let owneruid = post? .ownerUid else{return}
            guard let imgurl = post?.imageUrl else{return}
            guard let likes = post?.likes else{return}
//            if(likes>0){
//                self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//            }
            
            Database.fetchUser(with: owneruid) { (user) in
                self.profileImageView.loadImage(with: user.profileImageUrl)
                self.usernameButton.setTitle(user.username, for: .normal )
                self.configurePostDescription(user: user)
                
            }
            self.postImageView.loadImage(with: imgurl)
            self.likesLabel.text = "\(likes) likes "
        }
        
    }
    
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Username", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.addTarget(self, action: #selector(handleUsernameTapped) , for: .touchUpInside)
        return button
    }()
    
    
    lazy var postImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleLikeTapped) , for: .touchUpInside)
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "message"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleCommentTapped) , for: .touchUpInside)
        return button
    }()
    
    lazy var viewCommentButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleViewCommentsTapped) , for: .touchUpInside)
        return button
    }()
    
    
    func configurActionButtons(){
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, viewCommentButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
                
    }
    
    lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "3 likes"
        
        // add gesture recognizer to label
//        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleShowLikes))
//        likeTap.numberOfTapsRequired = 1
//        label.isUserInteractionEnabled = true
//        label.addGestureRecognizer(likeTap)
        
        return label
    }()
    
    let descriptionLabel: UILabel  = {
//        let label = ActiveLabel()
        let label = UILabel()
        let text = NSMutableAttributedString(string: "UserName", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
        text.append(NSAttributedString(string: "Testtest", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
        //label.numberOfLines = 0
        label.attributedText = text 
        return label
    }()
    
    
    
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        //
        self.addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0 , width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        //
        self.addSubview(usernameButton)
        usernameButton.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        //
        self.addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor , paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        //
        configurActionButtons()
        
        //
        self.addSubview(likesLabel)
        likesLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: -4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        self.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: likesLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft:   8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0 )
        
       //
    }
    
    
    // MARK: API
    func configurePostDescription(user : User){
        guard let post = self.post else {return}
        guard let description = post.description else{return}
        let text = NSMutableAttributedString(string: user.username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
        text.append(NSAttributedString(string: " \(description)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
        
        descriptionLabel.attributedText = text
        
    }
    
    
    
    // MARK: Handller
    @objc func handleUsernameTapped(){
        delegate?.handleUsernameTapped(for: self)
    }
    
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(for: self)
    }
    @objc func handleCommentTapped() {
        delegate?.handleCommentTapped(for: self)
    }
    
    @objc func handleViewCommentsTapped(){
        delegate?.handleViewCommentsTappeed(for: self)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
