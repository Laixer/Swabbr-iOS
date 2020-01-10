//
//  UserFollowRequest.swift
//  Swabbr
//
//  Created by James Bal on 02-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

struct UserFollowRequest {
    
    var id: String
    var requesterId: String
    var receiverId: String
    var status: Int
    var timestamp: String
    
    func mapToBusiness() -> UserFollowRequestModel {
        return UserFollowRequestModel(id: id,
                                      requesterId: requesterId,
                                      receiverId: receiverId,
                                      status: status,
                                      timestamp: timestamp)
    }
    
}

extension UserFollowRequest: Codable {
    
    /**
     Handles possible name convention differences.
     Put each value in their respected model variant.
     */
    enum CodingKeys: String, CodingKey {
        case id = "followRequestId", requesterId, receiverId, status
        case timestamp = "timeCreated"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        requesterId = try container.decode(String.self, forKey: .requesterId)
        receiverId = try container.decode(String.self, forKey: .receiverId)
        
        status = try container.decode(Int.self, forKey: .status)
        
        timestamp = try container.decode(String.self, forKey: .timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(requesterId, forKey: .requesterId)
        try container.encode(receiverId, forKey: .receiverId)
        try container.encode(status, forKey: .status)
        try container.encode(timestamp, forKey: .timestamp)
        
    }
}
