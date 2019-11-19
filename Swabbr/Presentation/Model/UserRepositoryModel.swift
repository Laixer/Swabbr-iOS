//
//  UserModel.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct UserRepositoryModel {
    
    var firstName: String
    var lastName: String
    var totalVlogs: String
    var totalFollowers: String
    var totalFollowing: String
    var interests: [String]
    
    init(userModel: UserModel) {
        firstName = userModel.firstName
        lastName = userModel.lastName
        totalVlogs = String(userModel.totalVlogs)
        totalFollowers = String(userModel.totalFollowers)
        totalFollowing = String(userModel.totalFollowing)
        interests = userModel.interests
    }
    
}

extension UserRepositoryModel {
    static func mapToPresentation(model: UserModel) -> UserRepositoryModel {
        return UserRepositoryModel(userModel: model)
    }
}
