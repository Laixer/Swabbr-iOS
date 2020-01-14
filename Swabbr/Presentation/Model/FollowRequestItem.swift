//
//  FollowRequestModel.swift
//  Swabbr
//
//  Created by James Bal on 10-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

struct FollowRequestItem {
    
    var id: String
    var receiverId: String
    var requesterId: String
    var status: Int
    
    init(userFollowRequestModel: UserFollowRequestModel) {
        id = userFollowRequestModel.id
        receiverId = userFollowRequestModel.receiverId
        requesterId = userFollowRequestModel.requesterId
        status = userFollowRequestModel.status
    }
    
}

extension FollowRequestItem {
    static func mapToPresentation(userFollowRequestModel: UserFollowRequestModel) -> FollowRequestItem {
        return FollowRequestItem(userFollowRequestModel: userFollowRequestModel)
    }
}
