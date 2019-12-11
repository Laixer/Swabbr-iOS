//
//  FollowStatus.swift
//  Swabbr
//
//  Created by James Bal on 04-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct FollowStatus {
    
    let id: String
    let status: String
    
    func mapToBusiness() -> FollowStatusModel {
        return FollowStatusModel(id: id,
                                 status: status)
    }
    
}

extension FollowStatus: Codable {
    
    /**
     Handles possible name convention differences.
     Put each value in their respected model variant.
     */
    enum CodingKeys: String, CodingKey {
        case id, status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        status = try container.decode(String.self, forKey: .status)
        
    }
    
}
