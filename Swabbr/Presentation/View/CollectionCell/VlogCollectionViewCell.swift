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
    let thumbView = UIImageView()
    
    var vlogUrl: String? {
        didSet {
            guard let vlogUrl = vlogUrl else {
                return
            }
            
            // TODO HANDLE IMAGE
            thumbView.image = UIImage()
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbView.backgroundColor = UIColor.black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        thumbView.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(thumbView)
        thumbView.backgroundColor = UIColor.blue
        contentView.addSubview(durationLabel)
        
        NSLayoutConstraint.activate([
            
            // thumbView
            thumbView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            thumbView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            thumbView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // durationLabel
            durationLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            durationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor)
            
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
