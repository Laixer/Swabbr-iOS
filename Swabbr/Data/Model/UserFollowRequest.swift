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
    var requesterId: Int
    var receiverId: Int
    var status: Status
    var timestamp: Date
    
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
        case id, requesterId, receiverId, status, timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        requesterId = try container.decodeToType(Int.self, key: .requesterId)
        receiverId = try container.decodeToType(Int.self, key: .receiverId)
        
        status = try container.decode(Status.self, forKey: .status)
        
        timestamp = DateFormatter().stringToBaseDate(format: "yyyy-MM-dd HH:mm", value: try container.decode(String.self, forKey: .timestamp))!
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(String(requesterId), forKey: .requesterId)
        try container.encode(String(receiverId), forKey: .receiverId)
        try container.encode(status, forKey: .status)
        try container.encode(timestamp, forKey: .timestamp)
        
    }
}

public enum Status: String, Codable {
    case accepted = "accepted"
    case pending = "pending"
    case declined = "declined"
}
