//
//  VlogRepositoryModel.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct VlogRepositoryModel {
    
    var id: Int
    var duration: String
    var totalLikes: String
    var totalReactions: String
    var totalViews: String
    
    init(vlogModel: VlogModel) {
        id = vlogModel.id
        duration = vlogModel.duration
        totalLikes = String(vlogModel.totalLikes)
        totalReactions = String(vlogModel.totalReactions)
        totalViews = String(vlogModel.totalViews)
    }
    
}

extension VlogRepositoryModel {
    static func mapToPresentation(vlogModel: VlogModel) -> VlogRepositoryModel {
        return VlogRepositoryModel(vlogModel: vlogModel)
    }
}
