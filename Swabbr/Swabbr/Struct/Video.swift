//
//  Video.swift
//  Swabbr
//
//  Created by James Bal on 19-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

struct Video {
    
    var uid: String
    var views: Int
    var likes: Int
    var owner: User
    
    init(uid: String, views: Int, likes: Int, owner: User) {
        self.uid = uid
        self.views = views
        self.likes = likes
        self.owner = owner
    }
    
    // add video related methods like "like" and "react"
    
}
