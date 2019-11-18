//
//  VlogUserRepositoryModel.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

struct VlogUserRepositoryModel {
    
    var vlogTotalLikes: Int
    var vlogTotalReactions: Int
    var vlogTotalViews: Int
    var vlogIsLive: Bool
    var userUsername: String
    var userProfileImageUrl: String
    
    init(vlogUserModel: VlogUserModel) {
        vlogTotalLikes = vlogUserModel.vlog.totalLikes
        vlogTotalReactions = vlogUserModel.vlog.totalReactions
        vlogTotalViews = vlogUserModel.vlog.totalViews
        vlogIsLive = vlogUserModel.vlog.isLive
        userUsername = vlogUserModel.user.username
        userProfileImageUrl = vlogUserModel.user.profileImageUrl
    }
    
}

extension VlogUserRepositoryModel {
    static func mapToPresentation(vlogUserModel: VlogUserModel) -> VlogUserRepositoryModel {
        return VlogUserRepositoryModel(vlogUserModel: vlogUserModel)
    }
}
