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
    
    /**
     This function makes the data conform to the model.
     It will try and parse the values to their correct value according to the model.
     - parameter decoder: The decoder built in swift to read the data from.
     - Throws: A decodingerror when the data can't be converted to their respective type.
     */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeToType(Int.self, key: CodingKeys.id)
        
        isPrivate = try container.decode(Bool.self, forKey: CodingKeys.isPrivate)
        duration = try container.decode(String.self, forKey: CodingKeys.duration)
        
        postDate = DateFormatter().stringToBaseDate(format: "yyyy-MM-dd HH:mm", value: try container.decode(String.self, forKey: CodingKeys.postDate))!

        owner = nil
        ownerId = try container.decode(Int.self, forKey: CodingKeys.ownerId)

        vlogId = try container.decodeToType(Int.self, key: CodingKeys.vlogId)
    }
    
}
