//
//  UserFollowRequestModel.swift
//  Swabbr
//
//  Created by James Bal on 10-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

struct UserFollowRequestItem {
    
    var id: String
    var receiverId: String
    var status: Int
    
    init(userFollowRequestModel: UserFollowRequestModel) {
        id = userFollowRequestModel.id
        receiverId = userFollowRequestModel.receiverId
        status = userFollowRequestModel.status
    }
    
}

extension UserFollowRequestItem {
    static func mapToPresentation(userFollowRequestModel: UserFollowRequestModel) -> UserFollowRequestItem {
        return UserFollowRequestItem(userFollowRequestModel: userFollowRequestModel)
    }
}
