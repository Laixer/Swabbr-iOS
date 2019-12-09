//
//  VlogReactionRepository.swift
//  Swabbr
//
//  Created by James Bal on 18-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

class VlogReactionRepository: RepositorySingleMultipleProtocol, RepositoryAllProtocol {
    
    typealias Model = VlogReactionModel
    
    private let network: DataSourceFactory<VlogReaction>
    private let cache: DataSourceFactory<VlogReaction>
    
    init(network: DataSourceFactory<VlogReaction> = DataSourceFactory(VlogReactionNetwork.shared), cache: DataSourceFactory<VlogReaction> = DataSourceFactory(VlogReactionCacheHandler.shared)) {
        self.network = network
        self.cache = cache
    }
    
    func getAll(refresh: Bool, completionHandler: @escaping ([VlogReactionModel]) -> Void) {
        if refresh {
            network.getAll(completionHandler: { (vlogReactions) -> Void in
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
            cache.getAll { (vlogReactions) in
                guard let vlogReactions = vlogReactions else {
                    self.getAll(refresh: !refresh, completionHandler: completionHandler)
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
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (VlogReactionModel?) -> Void) {
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
    
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping ([VlogReactionModel]) -> Void) {
        network.getSingleMultiple(id: id, completionHandler: { (vlogReactions) -> Void in
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
