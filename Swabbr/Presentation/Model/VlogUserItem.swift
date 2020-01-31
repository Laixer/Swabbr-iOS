//
//  VlogUserItem.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct VlogUserItem {
    
    var vlogId: String
    var vlogTotalLikes: Int
    var vlogTotalReactions: Int
    var vlogTotalViews: Int
    var vlogIsLive: Bool
    var vlogUrl: String
    var userId: String
    var userUsername: String
    var userProfileImageUrl: String
    
    init(vlogModel: VlogModel, userModel: UserModel) {
        vlogId = vlogModel.id
        vlogTotalLikes = vlogModel.totalLikes
        vlogTotalReactions = vlogModel.totalReactions
        vlogTotalViews = vlogModel.totalViews
        vlogIsLive = vlogModel.isLive
        vlogUrl = vlogModel.videoUrl
        userId = userModel.id
        userUsername = userModel.username
        userProfileImageUrl = userModel.profileImageUrl
    }
}

extension VlogUserItem {
    static func mapToPresentation(vlogModel: VlogModel, userModel: UserModel) -> VlogUserItem {
        return VlogUserItem(vlogModel: vlogModel, userModel: userModel)
    }
}
