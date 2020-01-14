//
//  VlogCollectionViewCell.swift
//  Swabbr
//
//  Created by James Bal on 02-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class VlogCollectionViewCell: UICollectionViewCell {
    
    let durationLabel = UILabel()
    let player = AVPlayer(url: URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!)
    let playerView = AVPlayerViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        playerView.view.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // TODO: set dynamic video url
        playerView.player = player
        playerView.videoGravity = .resizeAspectFill
        playerView.showsPlaybackControls = false
        
        contentView.addSubview(playerView.view)
        contentView.addSubview(durationLabel)
        
        NSLayoutConstraint.activate([
            
            // playerView
            playerView.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            playerView.view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            playerView.view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            playerView.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // durationLabel
            durationLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            durationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor)
            
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
