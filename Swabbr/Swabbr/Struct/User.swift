//
//  User.swift
//  Swabbr
//
//  Created by Anonymous on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// Base class of an user

import Foundation

struct User {
    
    var uid: Int64
    var username: String
    var profileImage: Int64
    var followersCount: Int
    
    init(uid: Int64, username: String, profileImage: Int64, followersCount: Int) {
        self.uid = uid
        self.username = username
        self.profileImage = profileImage
        self.followersCount = followersCount
    }
    
}
