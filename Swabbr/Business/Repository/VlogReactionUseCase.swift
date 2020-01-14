//
//  VlogReactionUseCase.swift
//  Swabbr
//
//  Created by James Bal on 18-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class VlogReactionUseCase {
    
    private let repository: VlogReactionRepositoryProtocol
    
    init(_ repository: VlogReactionRepositoryProtocol = VlogReactionRepository()) {
        self.repository = repository
    }
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (VlogReactionModel?) -> Void) {
        repository.get(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
    func getVlogReactions(id: String, refresh: Bool, completionHandler: @escaping ([VlogReactionModel]) -> Void) {
        repository.getVlogReactions(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
}
