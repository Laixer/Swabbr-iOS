//
//  ProfileViewController.swift
//  Swabbr
//
//  Created by James Bal on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController : UIViewController {

    private let user: User
    
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let countVlogsLabel = UILabel()
    private let countFollowersLabel = UILabel()
    private let countFollowingLabel = UILabel()
    private var followButton = UIButton()
    private let updateProfileButton = UIButton()
    
    private var isCurrentUser = false

    /**
     Initializes with a user value.
     It will fill up the view with the user information that is stored in the given object.
     - parameter user: An User object.
    */
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        
        initElements()
        applyConstraints()
        
    }
    
    /**
     Initialize all UI elements that will appear on the screen.
    */
    private func initElements() {
        
        usernameLabel.text = user.username
        countVlogsLabel.text = String(user.totalVlogs)
        countFollowersLabel.text = String(user.totalFollowers)
        countFollowingLabel.text = String(user.totalFollowing)
        
        view.addSubview(usernameLabel)
        view.addSubview(countVlogsLabel)
        view.addSubview(countFollowersLabel)
        view.addSubview(countFollowingLabel)
        
        if (UIApplication.shared.delegate as! AppDelegate).currentUser!.id == user.id {
            isCurrentUser = true
            updateProfileButton.setTitle("Update", for: .normal)
            updateProfileButton.tintColor = UIColor.white
            updateProfileButton.backgroundColor = UIColor.black
            view.addSubview(updateProfileButton)
        } else {
            followButton.setTitle("Follow", for: .normal)
            followButton.tintColor = UIColor.white
            followButton.backgroundColor = UIColor.black
            view.addSubview(followButton)
        }
        
    }
    
    /**
     Apply all constraints to show the initialized elements correctly on the screen.
    */
    private func applyConstraints() {
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        countVlogsLabel.translatesAutoresizingMaskIntoConstraints = false
        countFollowersLabel.translatesAutoresizingMaskIntoConstraints = false
        countFollowingLabel.translatesAutoresizingMaskIntoConstraints = false
        if isCurrentUser {
            updateProfileButton.translatesAutoresizingMaskIntoConstraints = false
        } else {
            followButton.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // usernameLabel
            usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            //countVlogsLabel
            countVlogsLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor),
            countVlogsLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            // countFollowersLabel
            countFollowersLabel.topAnchor.constraint(equalTo: countVlogsLabel.bottomAnchor),
            countFollowersLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            // countFollowingLabel
            countFollowingLabel.topAnchor.constraint(equalTo: countFollowersLabel.bottomAnchor),
            countFollowingLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
        ])
        
        if isCurrentUser {
            
            NSLayoutConstraint.activate([
                updateProfileButton.topAnchor.constraint(equalTo: countFollowingLabel.bottomAnchor),
                updateProfileButton.leftAnchor.constraint(equalTo: view.leftAnchor)
            ])
            
        } else {
            
            NSLayoutConstraint.activate([
                followButton.topAnchor.constraint(equalTo: countFollowingLabel.bottomAnchor),
                followButton.leftAnchor.constraint(equalTo: view.leftAnchor)
            ])
            
        }
        
    }
    
}
