//
//  CreatedVlogReactionItem.swift
//  Swabbr
//
//  Created by James Bal on 29-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

struct CreatedVlogReactionItem {
    
    let vlogId: String
    let data: Data
    let isPrivate: Bool
    
    func mapToBusiness() -> CreatedVlogReactionModel {
        return CreatedVlogReactionModel(vlogId: vlogId,
                                        data: data,
                                        isPrivate: isPrivate)
    }
    
}
