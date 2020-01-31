//
//  createdVlogReaction.swift
//  Swabbr
//
//  Created by James Bal on 29-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

struct CreatedVlogReaction {
    
    let vlogId: String
    let data: Data
    let isPrivate: Bool
    
    func mapToBusiness() -> CreatedVlogReactionModel {
        return CreatedVlogReactionModel(vlogId: vlogId,
                                        data: data,
                                        isPrivate: isPrivate)
    }
    
}

extension CreatedVlogReaction: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case vlogId, data, isPrivate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(vlogId, forKey: .vlogId)
        try container.encode(data, forKey: .data)
        try container.encode(isPrivate, forKey: .isPrivate)
    }
    
}

// MARK: mapToEntity
extension CreatedVlogReaction {
    static func mapToEntity(model: CreatedVlogReactionModel) -> CreatedVlogReaction {
        return CreatedVlogReaction(vlogId: model.vlogId,
                                   data: model.data,
                                   isPrivate: model.isPrivate)
    }
}
