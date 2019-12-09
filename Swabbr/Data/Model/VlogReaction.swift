//
//  VlogReaction.swift
//  Swabbr
//
//  Created by James Bal on 30-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

struct VlogReaction {
    
    var id: String
    var isPrivate: Bool
    var ownerId: String
    var duration: String
    var postDate: String
    var vlogId: String
    
    func mapToBusiness() -> VlogReactionModel {
        return VlogReactionModel(id: id,
                                 isPrivate: isPrivate,
                                 ownerId: ownerId,
                                 duration: duration,
                                 postDate: DateFormatter().stringToBaseDate(format: "yyyy-MM-dd HH:mm", value: postDate)!,
                                 vlogId: vlogId)
    }
    
}

extension VlogReaction: Codable {
    
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        
        isPrivate = try container.decode(Bool.self, forKey: .isPrivate)
        duration = try container.decode(String.self, forKey: .duration)
        
        postDate = try container.decode(String.self, forKey: .postDate)

        ownerId = try container.decode(String.self, forKey: .ownerId)
        vlogId = try container.decode(String.self, forKey: .vlogId)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(isPrivate, forKey: .isPrivate)
        try container.encode(ownerId, forKey: .ownerId)
        try container.encode(duration, forKey: .duration)
        try container.encode(postDate, forKey: .postDate)
        try container.encode(vlogId, forKey: .vlogId)
        
    }
    
}
