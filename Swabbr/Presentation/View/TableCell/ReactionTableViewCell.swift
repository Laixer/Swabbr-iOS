//
//  ReactionTableViewCell.swift
//  Swabbr
//
//  Created by James Bal on 19-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import AVKit
import AVFoundation

class ReactionTableViewCell: UITableViewCell {
    
    let userUsernameLabel = UILabel()
    let likesLabel = UILabel()
    let durationLabel = UILabel()
    let dateLabel = UILabel()
    let player = AVPlayer(url: URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!)
    let playerView = AVPlayerViewController()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // disable auto constraints to overwrite with own constraints
        playerView.view.translatesAutoresizingMaskIntoConstraints = false
        userUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        playerView.player = player
        playerView.videoGravity = .resizeAspectFill
        playerView.showsPlaybackControls = false
        
        // add ui components to view
        contentView.addSubview(playerView.view)
        contentView.addSubview(likesLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(userUsernameLabel)
        contentView.addSubview(dateLabel)
        
        // apply constraints
        NSLayoutConstraint.activate([
            
            playerView.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            playerView.view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            playerView.view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            playerView.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // userUsernameLabel
            userUsernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            userUsernameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            
            // dateLabel
            dateLabel.topAnchor.constraint(equalTo: userUsernameLabel.bottomAnchor),
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            
            // likesLabel
            likesLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            likesLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            
            // durationLabel
            durationLabel.topAnchor.constraint(equalTo: likesLabel.bottomAnchor),
            durationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor)
            
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
