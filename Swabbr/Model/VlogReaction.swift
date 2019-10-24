//
//  VlogReaction.swift
//  Swabbr
//
//  Created by James Bal on 30-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

class VlogReaction: Codable {
    
    var id: Int
    var isPrivate: Bool
    var owner: User?
    var ownerId: Int
    var duration: String
    var postDate: Date
    var vlogId: Int
    
    /**
     Handles possible name convention differences.
     Put each value in their respected model variant.
     */
    enum CodingKeys: String, CodingKey {
        case id
        case isPrivate = "private"
        case owner, duration, postDate, vlogId
        case ownerId = "userId"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeToType(Int.self, key: .id)
        
        isPrivate = try container.decode(Bool.self, forKey: .isPrivate)
        duration = try container.decode(String.self, forKey: .duration)
        
        postDate = DateFormatter().stringToBaseDate(format: "yyyy-MM-dd HH:mm", value: try container.decode(String.self, forKey: .postDate))!

        owner = nil
        ownerId = try container.decode(Int.self, forKey: .ownerId)

        vlogId = try container.decodeToType(Int.self, key: .vlogId)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(String(id), forKey: .id)
        try container.encode(isPrivate, forKey: .isPrivate)
        try container.encode(ownerId, forKey: .ownerId)
        try container.encode(duration, forKey: .duration)
        try container.encode(postDate, forKey: .postDate)
        try container.encode(String(vlogId), forKey: .vlogId)
        
    }
    
}
