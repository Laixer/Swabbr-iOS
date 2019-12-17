//
//  VlogReactionRepository.swift
//  Swabbr
//
//  Created by James Bal on 18-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

class VlogReactionRepository: VlogReactionRepositoryProtocol {
    
    private let network: VlogReactionDataSourceProtocol
    private let cache: VlogReactionCacheDataSourceProtocol
    
    init(network: VlogReactionDataSourceProtocol = VlogReactionNetwork(), cache: VlogReactionCacheDataSourceProtocol = VlogReactionCacheHandler.shared) {
        self.network = network
        self.cache = cache
    }
    
    func getAll(refresh: Bool, completionHandler: @escaping ([VlogReactionModel]) -> Void) {
        if refresh {
            network.getAll(completionHandler: { (vlogReactions) -> Void in
                self.cache.setAll(objects: vlogReactions)
                completionHandler(
                    vlogReactions.map({ (vlogReaction) -> VlogReactionModel in
                        vlogReaction.mapToBusiness()
                    })
                )
            })
        } else {
            do {
                try cache.getAll { (vlogReactions) in
                    completionHandler(
                        vlogReactions.map({ (vlogReaction) -> VlogReactionModel in
                            vlogReaction.mapToBusiness()
                        })
                    )
                }
            } catch {
                self.getAll(refresh: !refresh, completionHandler: completionHandler)
            }
        }
    }
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (VlogReactionModel?) -> Void) {
        if refresh {
            network.get(id: id, completionHandler: { (vlogReaction) -> Void in
                self.cache.set(object: vlogReaction)
                completionHandler(vlogReaction?.mapToBusiness())
            })
        } else {
            do {
                try cache.get(id: id) { (vlogReaction) in
                    completionHandler(vlogReaction.mapToBusiness())
                }
            } catch {
                self.get(id: id, refresh: !refresh, completionHandler: completionHandler)
            }
        }
    }
    
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping ([VlogReactionModel]) -> Void) {
        network.getSingleMultiple(id: id, completionHandler: { (vlogReactions) -> Void in
            completionHandler(
                vlogReactions.map({ (vlogReaction) -> VlogReactionModel in
                    vlogReaction.mapToBusiness()
                })
            )
        })
    }
}
