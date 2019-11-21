//
//  VlogRepository.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

class VlogRepository: RepositoryProtocol {
    typealias Model = VlogModel
    
    static let shared = VlogRepository()
    
    private let network = VlogNetwork.shared
    
    func get(refresh: Bool, completionHandler: @escaping ([VlogModel]?) -> Void) {
        network.get(completionHandler: { (vlogs) -> Void in
            completionHandler(
                vlogs?.map({ (vlog) -> Model in
                    vlog.mapToBusiness()
                })
            )
        })
    }
    
    func get(id: Int, refresh: Bool, completionHandler: @escaping (VlogModel?) -> Void) {
        network.get(id: id, completionHandler: { (vlog) -> Void in
            completionHandler(vlog?.mapToBusiness())
        })
    }
}
