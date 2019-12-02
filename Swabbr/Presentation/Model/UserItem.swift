//
//  UserModel.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct UserItem {
    
    var id: Int
    var username: String
    var totalVlogs: Int
    var totalFollowers: Int
    var totalFollowing: Int
    var interests: [String]
    var profileImageUrl: String
    
    init(userModel: UserModel) {
        id = userModel.id
        username = userModel.username
        totalVlogs = userModel.totalVlogs
        totalFollowers = userModel.totalFollowers
        totalFollowing = userModel.totalFollowing
        interests = userModel.interests
        profileImageUrl = userModel.profileImageUrl
    }
    
}

extension UserItem {
    static func mapToPresentation(model: UserModel) -> UserItem {
        return UserItem(userModel: model)
    }
}
