//
//  VlogRepository.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

class VlogRepository: RepositorySingleMultipleProtocol, RepositoryAllProtocol {
    
    typealias Model = VlogModel
    
    private let network: DataSourceFactory<Vlog>
    private let cache: DataSourceFactory<Vlog>
    
    init(network: DataSourceFactory<Vlog> = DataSourceFactory(VlogNetwork.shared), cache: DataSourceFactory<Vlog> = DataSourceFactory(VlogCacheHandler.shared)) {
        self.network = network
        self.cache = cache
    }
    
    func getAll(refresh: Bool, completionHandler: @escaping ([VlogModel]) -> Void) {
        if refresh {
            network.getAll(completionHandler: { (vlogs) -> Void in
                guard let vlogs = vlogs else {
                    completionHandler([])
                    return
                }
                completionHandler(
                    vlogs.map({ (vlog) -> Model in
                        vlog.mapToBusiness()
                    })
                )
            })
        } else {
            cache.getAll { (vlogs) in
                guard let vlogs = vlogs else {
                    self.getAll(refresh: !refresh, completionHandler: completionHandler)
                    return
                }
                completionHandler(
                    vlogs.map({ (vlog) -> Model in
                        vlog.mapToBusiness()
                    })
                )
            }
        }
    }
    
    func get(id: Int, refresh: Bool, completionHandler: @escaping (VlogModel?) -> Void) {
        if refresh {
            network.get(id: id, completionHandler: { (vlog) -> Void in
                completionHandler(vlog?.mapToBusiness())
            })
        } else {
            cache.get(id: id) { (vlog) in
                if vlog == nil {
                    self.get(id: id, refresh: !refresh, completionHandler: completionHandler)
                } else {
                    completionHandler(vlog?.mapToBusiness())
                }
            }
        }
    }
    
    func getSingleMultiple(id: Int, refresh: Bool, completionHandler: @escaping ([VlogModel]) -> Void) {
        network.getSingleMultiple(id: id, completionHandler: { (vlogs) -> Void in
            guard let vlogs = vlogs else {
                completionHandler([])
                return
            }
            completionHandler(
                vlogs.map({ (vlog) -> Model in
                    vlog.mapToBusiness()
                })
            )
        })
    }
}
