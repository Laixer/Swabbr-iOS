//
//  UserVlogReactionItem.swift
//  Swabbr
//
//  Created by James Bal on 18-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct UserVlogReactionItem {
    
    var userUsername: String
    var reactionDate: Date
    var reactionDuration: String
    
    init(userModel: UserModel, vlogReactionModel: VlogReactionModel) {
        userUsername = userModel.username
        reactionDate = vlogReactionModel.postDate
        reactionDuration = vlogReactionModel.duration
    }
    
}

extension UserVlogReactionItem {
    static func mapToPresentation(userModel: UserModel, vlogReactionModel: VlogReactionModel) -> UserVlogReactionItem {
        return UserVlogReactionItem(userModel: userModel, vlogReactionModel: vlogReactionModel)
    }
}
