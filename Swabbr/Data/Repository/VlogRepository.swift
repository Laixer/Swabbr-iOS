//
//  VlogRepository.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

class VlogRepository: VlogRepositoryProtocol {
    
    private let network: VlogDataSourceProtocol
    private let cache: VlogCacheDataSourceProtocol
    
    init(network: VlogDataSourceProtocol = VlogNetwork(), cache: VlogCacheDataSourceProtocol = VlogCacheHandler.shared) {
        self.network = network
        self.cache = cache
    }
    
    func getFeatured(refresh: Bool, completionHandler: @escaping ([VlogModel]) -> Void) {
        network.getFeatured(completionHandler: { (vlogs) -> Void in
            completionHandler(
                vlogs.map({ (vlog) -> VlogModel in
                    vlog.mapToBusiness()
                })
            )
        })
    }
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (VlogModel?) -> Void) {
        if refresh {
            network.get(id: id, completionHandler: { (vlog) -> Void in
                self.cache.set(object: vlog)
                completionHandler(vlog?.mapToBusiness())
            })
        } else {
            do {
                try cache.get(id: id) { (vlog) in
                    completionHandler(vlog.mapToBusiness())
                }
            } catch {
                self.get(id: id, refresh: !refresh, completionHandler: completionHandler)
            }
        }
    }
    
    func getUserVlogs(id: String, refresh: Bool, completionHandler: @escaping ([VlogModel]) -> Void) {
        network.getUserVlogs(id: id, completionHandler: { (vlogs) -> Void in
            completionHandler(
                vlogs.map({ (vlog) -> VlogModel in
                    vlog.mapToBusiness()
                })
            )
        })
    }
    
    func createLike(id: String, completionHandler: @escaping (String?) -> Void) {
        network.createLike(id: id, completionHandler: completionHandler)
    }
    
    func createVlog(completionHandler: @escaping (String?) -> Void) {
        network.createVlog(completionHandler: completionHandler)
    }
}
