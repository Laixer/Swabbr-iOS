//
//  User.swift
//  Swabbr
//
//  Created by James Bal on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
//  Base class of an user

import Foundation

struct User: Decodable {
    
    var id: String
    var firstName: String
    var lastName: String
    var gender: String
    var country: String
    var email: String
    var birthdate: String
    var timezone: String
    var username: String
    var profileImageUrl: String
    var interests: [String]
    var totalVlogs: Int
    var totalFollowers: Int
    var totalFollowing: Int
    var longitude: String
    var latitude: String
    
}
