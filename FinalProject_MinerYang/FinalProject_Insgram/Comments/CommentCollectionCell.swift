//
//  CommentCollectionCell.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/15/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import UIKit

class CommentCollectionCell: UICollectionViewCell {
    // MARK: properties
    var comment : Comment? {
        didSet{
            guard let user = comment?.user else{return}
            guard let imgurl = user.profileImageUrl else{return}
            guard let username = user.username else {return}
            guard let commenttext = comment?.commentText else{return}
            
            profileImageView.loadImage(with: imgurl)
            let attributedText = NSMutableAttributedString(string: "\(username) ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
            attributedText.append(NSAttributedString(string: commenttext, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
            commentLabel.attributedText = attributedText
            
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    let commentLabel: UILabel = {
        let label = UILabel()
//        let attributedText = NSMutableAttributedString(string: "username", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
//        attributedText.append(NSAttributedString(string: "comments ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
//        label.attributedText = attributedText
        return label
    }()
    
    
    // MARK: INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        //print("init comment cell")
        //self.contentView.backgroundColor = .systemPink
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0 , width: 48, height: 48)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 48 / 2
        
        //
        addSubview(commentLabel)
        commentLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8 , width: 0, height: 0)
        commentLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
