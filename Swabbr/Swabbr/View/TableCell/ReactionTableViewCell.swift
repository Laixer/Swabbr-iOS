//
//  ReactionTableViewCell.swift
//  Swabbr
//
//  Created by James Bal on 19-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit

class ReactionTableViewCell : UITableViewCell {
    
    let userUsernameLabel = UILabel()
    let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // disable auto constraints to overwrite with own constraints
        userUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // add ui components to view
        contentView.addSubview(userUsernameLabel)
        contentView.addSubview(dateLabel)
        
        // apply constraints
        NSLayoutConstraint.activate([
            
            // userUsernameLabel
            userUsernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            userUsernameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            
            // dateLabel
            dateLabel.topAnchor.constraint(equalTo: userUsernameLabel.bottomAnchor),
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor)
            
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
