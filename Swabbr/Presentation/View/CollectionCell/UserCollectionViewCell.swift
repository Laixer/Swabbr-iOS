//
//  UserCollectionViewCell.swift
//  Swabbr
//
//  Created by James Bal on 03-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation
import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    let usernameLabel = UILabel()
    let profileImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            
            // usernameLabel
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            usernameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            
            // profileImageView
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            profileImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
