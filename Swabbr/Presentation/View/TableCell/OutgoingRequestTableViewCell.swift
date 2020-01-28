//
//  OutgoingRequestTableViewCell.swift
//  Swabbr
//
//  Created by James Bal on 13-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

class OutgoingRequestTableViewCell: UITableViewCell {
    
    let userUsernameLabel = UILabel()
    let profileImageView = UIImageView()
    let timeLabel = UILabel()
    let removeButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(userUsernameLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(removeButton)
        
        removeButton.setTitle("Remove", for: .normal)
        removeButton.tintColor = UIColor.blue
        removeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
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
            
            // removeButton
            removeButton.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor),
            removeButton.topAnchor.constraint(equalTo: contentView.topAnchor)
            
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
