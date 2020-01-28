//
//  VlogItem.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct VlogItem: Equatable {
    
    var id: String
    var duration: String
    var totalLikes: Int
    var totalReactions: Int
    var totalViews: Int
    
    init(vlogModel: VlogModel) {
        id = vlogModel.id
        duration = vlogModel.duration
        totalLikes = vlogModel.totalLikes
        totalReactions = vlogModel.totalReactions
        totalViews = vlogModel.totalViews
    }
    
}

extension VlogItem {
    static func mapToPresentation(vlogModel: VlogModel) -> VlogItem {
        return VlogItem(vlogModel: vlogModel)
    }
}
