//
//  UserFollowRequestItem.swift
//  Swabbr
//
//  Created by James Bal on 13-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

struct UserFollowRequestItem {
    
    var followRequestId: String
    var userUsername: String
    var userProfileImageUrl: String
    var date: String
    
    init(userModel: UserModel, userFollowRequestModel: UserFollowRequestModel) {
        followRequestId = userFollowRequestModel.id
        userUsername = userModel.username
        userProfileImageUrl = userModel.profileImageUrl
        date = userFollowRequestModel.timestamp
    }
    
}

extension FollowRequestItem {
    static func mapToPresentation(userModel: UserModel, userFollowRequestModel: UserFollowRequestModel) -> UserFollowRequestItem {
        return UserFollowRequestItem(userModel: userModel, userFollowRequestModel: userFollowRequestModel)
    }
}
