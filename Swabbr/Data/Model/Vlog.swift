//
//  Vlog.swift
//  Swabbr
//
//  Created by James Bal on 19-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

struct Vlog {
    
    var id: Int
    var isPrivate: Bool
    var duration: String
    var startDate: String
    var totalLikes: Int
    var totalReactions: Int
    var totalViews: Int
    var isLive: Bool
    var ownerId: Int
    
    func mapToBusiness() -> VlogModel {
        return VlogModel(id: id,
                         isPrivate: isPrivate,
                         duration: duration,
                         startDate: DateFormatter().stringToBaseDate(format: "yyyy-MM-dd HH:mm", value: startDate)!,
                         totalLikes: totalLikes,
                         totalReactions: totalReactions,
                         totalViews: totalViews,
                         isLive: isLive,
                         ownerId: ownerId)
    }
    
}

extension Vlog: Codable {
    
    /**
     Handles possible name convention differences.
     Put each value in their respected model variant.
     */
    enum CodingKeys: String, CodingKey {
        case id
        case isPrivate = "private"
        case duration, startDate, totalLikes, totalReactions, totalViews, isLive, owner
        case ownerId = "userId"
        
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeToType(Int.self, key: .id)
        
        isPrivate = try container.decode(Bool.self, forKey: .isPrivate)
        duration = try container.decode(String.self, forKey: .duration)
        
        startDate = try container.decode(String.self, forKey: .startDate)
        
        totalLikes = try container.decode(Int.self, forKey: .totalLikes)
        totalReactions = try container.decode(Int.self, forKey: .totalReactions)
        totalViews = try container.decode(Int.self, forKey: .totalViews)
        isLive = try container.decode(Bool.self, forKey: .isLive)
        
        ownerId = try container.decode(Int.self, forKey: .ownerId)
        
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(String(id), forKey: .id)
        try container.encode(isPrivate, forKey: .isPrivate)
        try container.encode(ownerId, forKey: .ownerId)
        try container.encode(duration, forKey: .duration)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(totalLikes, forKey: .totalLikes)
        try container.encode(totalReactions, forKey: .totalReactions)
        try container.encode(totalViews, forKey: .totalViews)
        try container.encode(isLive, forKey: .isLive)
        
    }
    
}
