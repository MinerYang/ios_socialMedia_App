//
//  SelectPhotoCell.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/12/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import UIKit

class SelectPhotoCell: UICollectionViewCell {
    // MARK: -Properties
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    
    // INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("into select photo cell ")
        
        //
        self.addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
