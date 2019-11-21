//
//  VlogReactionDataRetriever.swift
//  Swabbr
//
//  Created by James Bal on 18-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class VlogReactionDataRetriever: RepositoryMultipleProtocol {
    typealias Model = VlogReactionModel
    
    static let shared = VlogReactionDataRetriever()
    
    private let repository = VlogReactionRepository.shared
    
    func get(refresh: Bool, completionHandler: @escaping ([VlogReactionModel]?) -> Void) {
        repository.get(refresh: refresh, completionHandler: completionHandler)
    }
    
    func get(id: Int, refresh: Bool, completionHandler: @escaping (VlogReactionModel?) -> Void) {
        repository.get(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
    func get(id: Int, refresh: Bool, multiple completionHandler: @escaping ([VlogReactionModel]?) -> Void) {
        repository.get(id: id, refresh: refresh, multiple: completionHandler)
    }
    
    
}
