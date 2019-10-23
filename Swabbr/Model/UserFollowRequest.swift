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
    
    /**
     This function makes the data conform to the model.
     It will try and parse the values to their correct value according to the model.
     - parameter decoder: The decoder built in swift to read the data from.
     - Throws: A decodingerror when the data can't be converted to their respective type.
     */
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeToType(Int.self, key: CodingKeys.id)
        requesterId = try container.decodeToType(Int.self, key: CodingKeys.requesterId)
        receiverId = try container.decodeToType(Int.self, key: CodingKeys.receiverId)
        
        status = try container.decode(Status.self, forKey: CodingKeys.status)
        
        timestamp = DateFormatter().stringToBaseDate(format: "yyyy-MM-dd HH:mm", value: try container.decode(String.self, forKey: CodingKeys.timestamp))!
    }
    
}
