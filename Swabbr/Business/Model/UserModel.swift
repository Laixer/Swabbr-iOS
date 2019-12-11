//
//  UserModel.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

struct UserModel {
    
    var id: String
    var firstName: String
    var lastName: String
    var gender: Int
    var country: String
    var email: String
    var birthdate: Date
    var timezone: String
    var username: String
    var profileImageUrl: String
    var interests: [String]
    var totalVlogs: Int
    var totalFollowers: Int
    var totalFollowing: Int
    var longitude: Float
    var latitude: Float
    
}
