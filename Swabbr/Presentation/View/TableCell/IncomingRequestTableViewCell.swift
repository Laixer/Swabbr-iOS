//
//  IncomingRequestTableViewCell.swift
//  Swabbr
//
//  Created by James Bal on 13-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

class IncomingRequestTableViewCell: UITableViewCell {
    
    let userUsernameLabel = UILabel()
    let profileImageView = UIImageView()
    let timeLabel = UILabel()
    let acceptButton = UIButton()
    let denyButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        denyButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(userUsernameLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(acceptButton)
        contentView.addSubview(denyButton)
        
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.tintColor = UIColor.blue
        acceptButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        denyButton.setTitle("Deny", for: .normal)
        denyButton.tintColor = UIColor.blue
        denyButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        // apply constraints
        NSLayoutConstraint.activate([
            
            // profileImageView
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImageView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 150),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            
            // userUsernameLabel
            userUsernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            userUsernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor),
            
            // timeLabel
            timeLabel.topAnchor.constraint(equalTo: userUsernameLabel.bottomAnchor),
            timeLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor),
            
            // denyButton
            denyButton.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor),
            denyButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            // acceptButton
            acceptButton.rightAnchor.constraint(equalTo: denyButton.leftAnchor),
            acceptButton.topAnchor.constraint(equalTo: contentView.topAnchor)
            
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
