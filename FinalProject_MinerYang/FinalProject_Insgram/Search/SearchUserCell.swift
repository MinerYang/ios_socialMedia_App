//
//  SearchUserCell.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/10/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell {
    
    var user : User? {
        didSet{
            guard let profileImageUrl = user?.profileImageUrl else{
                return
            }
            guard let username = user?.username else{
                return
            }
            guard let fullname = user?.name else{return}
            
            profileImageView.loadImage(with: profileImageUrl)
            self.textLabel?.text =  username
            self.detailTextLabel?.text = fullname
            
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 48/2.0
        profileImageView.clipsToBounds = true
        
        self.textLabel?.text =  "username"
        self.detailTextLabel?.text = " full name"
//        setlayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setlayout(){
        //textLabel.frame
//
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
