//
//  VlogItem.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct VlogItem: Equatable {
    
    let id: String
    let duration: String
    let totalLikes: Int
    let totalReactions: Int
    let totalViews: Int
    let videoUrl: String
    
    init(vlogModel: VlogModel) {
        id = vlogModel.id
        duration = vlogModel.duration
        totalLikes = vlogModel.totalLikes
        totalReactions = vlogModel.totalReactions
        totalViews = vlogModel.totalViews
        videoUrl = vlogModel.videoUrl
    }
    
}

extension VlogItem {
    static func mapToPresentation(vlogModel: VlogModel) -> VlogItem {
        return VlogItem(vlogModel: vlogModel)
    }
}
