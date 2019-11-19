//
//  VlogReactionsRepositoryModel.swift
//  Swabbr
//
//  Created by James Bal on 18-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct UserVlogReactionRepositoryModel {
    
    var userUsername: String
    var reactionDate: Date
    var reactionDuration: String
    
    init(userModel: UserModel, vlogReactionModel: VlogReactionModel) {
        userUsername = userModel.username
        reactionDate = vlogReactionModel.postDate
        reactionDuration = vlogReactionModel.duration
    }
    
}

extension UserVlogReactionRepositoryModel {
    static func mapToPresentation(userModel: UserModel, vlogReactionModel: VlogReactionModel) -> UserVlogReactionRepositoryModel {
        return UserVlogReactionRepositoryModel(userModel: userModel, vlogReactionModel: vlogReactionModel)
    }
}
