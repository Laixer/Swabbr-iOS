//
//  VlogReaction.swift
//  Swabbr
//
//  Created by James Bal on 18-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

class VlogReactionNetwork: NetworkProtocol, DataSourceSingleMultipleProtocol, DataSourceAllProtocol {
    typealias Entity = VlogReaction
    
    static let shared = VlogReactionNetwork()
    
    var endPoint: String = "reactions"
    
    func getAll(completionHandler: @escaping ([VlogReaction]?) -> Void) {
        load(buildUrl()) { (vlogReactions) in
            completionHandler(vlogReactions)
        }
    }
    
    func get(id: String, completionHandler: @escaping (VlogReaction?) -> Void) {
        let queryItems = [URLQueryItem(name: "vlogId", value: id)]
        load(buildUrl(queryItems: queryItems)) { (vlogReactions) in
            completionHandler((vlogReactions != nil) ? vlogReactions![0] : nil)
        }
    }
    
    func getSingleMultiple(id: String, completionHandler: @escaping ([VlogReaction]?) -> Void) {
        let queryItems = [URLQueryItem(name: "vlogId", value: id)]
        load(buildUrl(queryItems: queryItems)) { (vlogReactions) in
            completionHandler(vlogReactions)
        }
    }
}
