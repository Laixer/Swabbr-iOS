//
//  VlogPageViewController.swift
//  Swabbr
//
//  Created by James Bal on 19-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
//  This handles all things related the vlog page

import UIKit
import AVFoundation

class VlogPageViewController : UIViewController {
    
    private let likesLabel = UILabel()
    private let viewsLabel = UILabel()
    private let userProfileImageView = UIImageView()
    private let userUsernameLabel = UILabel()
    
    private let vlog: Vlog
    
    init(vlog: Vlog) {
        self.vlog = vlog
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = video.uid
        view.backgroundColor = UIColor.white
        
        userProfileImageView.contentMode = .scaleAspectFill
        userProfileImageView.clipsToBounds = true
        
        // set values
        likesLabel.text = String(vlog.likes)
        viewsLabel.text = String(vlog.views)
        userUsernameLabel.text = video.owner.username
        do {
            let url = URL(string: "https://cdn.mos.cms.futurecdn.net/yJaNqkw6JPf2QuXiYobcY3.jpg")
            let data = try Data(contentsOf: url!)
            userProfileImageView.image = UIImage(data: data)
        } catch {
            print(error)
        }
        
        // add ui components to current view
        view.addSubview(likesLabel)
        view.addSubview(viewsLabel)
        view.addSubview(userProfileImageView)
        view.addSubview(userUsernameLabel)
        
        // disable auto constraint to override with given constraints
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        userUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // apply constraints
        NSLayoutConstraint.activate([
            
            // likesLabel
            likesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            likesLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            // viewsLabel
            viewsLabel.topAnchor.constraint(equalTo: likesLabel.bottomAnchor),
            viewsLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            // userUsernameLabel
            userUsernameLabel.topAnchor.constraint(equalTo: viewsLabel.bottomAnchor),
            userUsernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            // userProfileImageView
            userProfileImageView.topAnchor.constraint(equalTo: userUsernameLabel.bottomAnchor),
            userProfileImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 100),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 100)
            
        ])
        
        // add tap event on imageview
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(clickedProfilePicture))
        userProfileImageView.isUserInteractionEnabled = true
        userProfileImageView.addGestureRecognizer(singleTap)
    }
    
    @objc func clickedProfilePicture() {
        navigationController?.pushViewController(ProfileViewController(user: video.owner), animated: true)
    }
    
}
