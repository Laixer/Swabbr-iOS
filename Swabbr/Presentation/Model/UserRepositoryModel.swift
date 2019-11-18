//
//  UserModel.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

// useritem
struct UserRepositoryModel {
    
    var fullname: String
    var interests: [String]
    
    init(userModel: UserModel) {
        fullname = userModel.firstName + " " + userModel.lastName
        interests = userModel.interests
    }
    
}

extension UserRepositoryModel {
    static func mapToPresentation(model: UserModel) -> UserRepositoryModel {
        return UserRepositoryModel(userModel: model)
    }
}
