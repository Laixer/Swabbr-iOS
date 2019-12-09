//
//  UserFollowRequestModel.swift
//  Swabbr
//
//  Created by James Bal on 20-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct UserFollowRequestModel {
    
    var id: String
    var requesterId: Int
    var receiverId: Int
    var status: Status
    var timestamp: Date
    
}
