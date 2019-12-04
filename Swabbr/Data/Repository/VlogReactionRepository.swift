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
    private let cache = VlogReactionCacheHandler.shared
    
    func get(refresh: Bool, completionHandler: @escaping ([VlogReactionModel]) -> Void) {
        if refresh {
            network.get(completionHandler: { (vlogReactions) -> Void in
                guard let vlogReactions = vlogReactions else {
                    completionHandler([])
                    return
                }
                completionHandler(
                    vlogReactions.map({ (vlogReaction) -> Model in
                        vlogReaction.mapToBusiness()
                    })
                )
            })
        } else {
            cache.get { (vlogReactions) in
                guard let vlogReactions = vlogReactions else {
                    self.get(refresh: !refresh, completionHandler: completionHandler)
                    return
                }
                completionHandler(
                    vlogReactions.map({ (vlogReaction) -> Model in
                        vlogReaction.mapToBusiness()
                    })
                )
            }
        }
    }
    
    func get(id: Int, refresh: Bool, completionHandler: @escaping (VlogReactionModel?) -> Void) {
        if refresh {
            network.get(id: id, completionHandler: { (vlogReaction) -> Void in
                completionHandler(vlogReaction?.mapToBusiness())
            })
        } else {
            cache.get(id: id) { (vlogReaction) in
                if vlogReaction == nil {
                    self.get(id: id, refresh: !refresh, completionHandler: completionHandler)
                } else {
                    completionHandler(vlogReaction?.mapToBusiness())
                }
            }
        }
    }
    
    func get(id: Int, refresh: Bool, multiple completionHandler: @escaping ([VlogReactionModel]) -> Void) {
        network.get(id: id, multiple: { (vlogReactions) -> Void in
            guard let vlogReactions = vlogReactions else {
                completionHandler([])
                return
            }
            completionHandler(
                vlogReactions.map({ (vlogReaction) -> Model in
                    vlogReaction.mapToBusiness()
                })
            )
        })
    }
}
