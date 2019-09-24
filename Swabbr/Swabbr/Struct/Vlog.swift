//
//  Vlog.swift
//  Swabbr
//
//  Created by James Bal on 19-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

struct Vlog {
    
    var id: Int64
    var isPrivate: Bool
    var duration: Int
    var startDate: Date
    var totalLikes: Int
    var totalReactions: Int
    var totalViews: Int
    var isLive: Bool
    var owner: User
    
    init(id: Int64, isPrivate: Bool, duration: Int, startDate: Date, totalLikes: Int, totalReactions: Int, totalViews: Int, isLive: Bool, owner: User) {
        self.id = id
        self.isPrivate = isPrivate
        self.duration = duration
        self.startDate = startDate
        self.totalLikes = totalLikes
        self.totalReactions = totalReactions
        self.totalViews = totalViews
        self.isLive = isLive
        self.owner = owner
    }
    
    // add vlog related methods like "like" and "react"
    
}
