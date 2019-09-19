//
//  ProfileViewController.swift
//  Swabbr
//
//  Created by Anonymous on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController : UIViewController {

    private let user: User
    
    // set the user to use for profile information
    init(user: User) {
        self.user = user
        super.init(nibName: "ProfileViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        usernameLabel.text = user.username
        followersLabel.text = String(user.followersCount)
    }
    
}
