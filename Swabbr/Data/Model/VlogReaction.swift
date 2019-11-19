//
//  VlogReaction.swift
//  Swabbr
//
//  Created by James Bal on 30-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

struct VlogReaction {
    
    var id: Int
    var isPrivate: Bool
    var ownerId: Int
    var duration: String
    var postDate: Date
    var vlogId: Int
    
    func mapToBusiness() -> VlogReactionModel {
        return VlogReactionModel(id: id,
                                 isPrivate: isPrivate,
                                 ownerId: ownerId,
                                 duration: duration,
                                 postDate: postDate,
                                 vlogId: vlogId)
    }
    
}

extension VlogReaction: Codable {
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeToType(Int.self, key: .id)
        
        isPrivate = try container.decode(Bool.self, forKey: .isPrivate)
        duration = try container.decode(String.self, forKey: .duration)
        
        postDate = DateFormatter().stringToBaseDate(format: "yyyy-MM-dd HH:mm", value: try container.decode(String.self, forKey: .postDate))!

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

public enum CodingKeys: String, CodingKey {
    case id
    case isPrivate = "private"
    case owner, duration, postDate, vlogId
    case ownerId = "userId"
}
