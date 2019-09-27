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
    
    private let updateProfileButton = UIButton()

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
        
        usernameLabel.text = user.username
        
        view.addSubview(usernameLabel)
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
    }
    
}
