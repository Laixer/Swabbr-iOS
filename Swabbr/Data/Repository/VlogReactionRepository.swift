//
//  VlogReactionRepository.swift
//  Swabbr
//
//  Created by James Bal on 18-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

class VlogReactionRepository: RepositoryMultipleProtocol {
    
    typealias Model = VlogReactionModel
    
    static let shared = VlogReactionRepository()
    
    private let network = VlogReactionNetwork.shared
    
    func get(refresh: Bool, completionHandler: @escaping ([VlogReactionModel]) -> Void) {
        network.get(completionHandler: { (vlogReactions) -> Void in
            completionHandler(
                vlogReactions.map({ (vlogReaction) -> Model in
                    vlogReaction.mapToBusiness()
                })
            )
        })
    }
    
    func get(id: Int, refresh: Bool, completionHandler: @escaping (VlogReactionModel?) -> Void) {
        network.get(id: id, completionHandler: { (vlogReaction) -> Void in
            completionHandler(vlogReaction?.mapToBusiness())
        })
    }
    
    func get(id: Int, refresh: Bool, multiple completionHandler: @escaping ([VlogReactionModel]) -> Void) {
        network.get(id: id, multiple: { (vlogReactions) -> Void in
            completionHandler(
                vlogReactions.map({ (vlogReaction) -> Model in
                    vlogReaction.mapToBusiness()
                })
            )
        })
    }
}
