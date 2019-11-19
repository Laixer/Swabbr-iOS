//
//  VlogReactionDataRetriever.swift
//  Swabbr
//
//  Created by James Bal on 18-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class VlogReactionDataRetriever {
    
    static let shared = VlogReactionDataRetriever()
    
    private let repository = VlogReactionRepository.shared
    
    func get(vlogId: Int, refresh: Bool, completionHandler: @escaping ([VlogReactionModel]?) -> Void) {
        repository.get(id: vlogId, refresh: refresh, multiple: completionHandler)
    }
    
    
}
