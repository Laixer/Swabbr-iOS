//
//  UserFollowRequest.swift
//  Swabbr
//
//  Created by James Bal on 02-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

struct UserFollowRequest: Codable {
    
    var id: Int
    var requesterId: Int
    var receiverId: Int
    var status: Status
    var timestamp: Date
    
    /**
     Converts the value of the status we get to conform our model.
    */
    enum Status: String, Codable {
        case Accepted = "accepted"
        case Pending = "pending"
        case Declined = "declined"
    }
    
    /**
     Handles possible name convention differences.
     Put each value in their respected model variant.
     */
    enum CodingKeys: String, CodingKey {
        case id, requesterId, receiverId, status, timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeToType(Int.self, key: .id)
        requesterId = try container.decodeToType(Int.self, key: .requesterId)
        receiverId = try container.decodeToType(Int.self, key: .receiverId)
        
        status = try container.decode(Status.self, forKey: .status)
        
        timestamp = DateFormatter().stringToBaseDate(format: "yyyy-MM-dd HH:mm", value: try container.decode(String.self, forKey: .timestamp))!
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(String(id), forKey: .id)
        try container.encode(String(requesterId), forKey: .requesterId)
        try container.encode(String(receiverId), forKey: .receiverId)
        try container.encode(status, forKey: .status)
        try container.encode(timestamp, forKey: .timestamp)
        
    }
    
}
