//
//  VlogRepository.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

class VlogRepository: RepositoryMultipleProtocol {
    typealias Model = VlogModel
    
    static let shared = VlogRepository()
    
    private let network = VlogNetwork.shared
    private let cache = VlogCacheHandler.shared
    
    func get(refresh: Bool, completionHandler: @escaping ([VlogModel]) -> Void) {
        if refresh {
            network.get(completionHandler: { (vlogs) -> Void in
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
            cache.get { (vlogs) in
                guard let vlogs = vlogs else {
                    self.get(refresh: !refresh, completionHandler: completionHandler)
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
    
    func get(id: Int, refresh: Bool, multiple completionHandler: @escaping ([VlogModel]) -> Void) {
        network.get(id: id, multiple: { (vlogs) -> Void in
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
