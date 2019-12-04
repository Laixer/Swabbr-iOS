//
//  VlogReaction.swift
//  Swabbr
//
//  Created by James Bal on 18-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

class VlogReactionNetwork: NetworkProtocol, DataSourceMultipleProtocol {
    typealias Entity = VlogReaction
    
    static let shared = VlogReactionNetwork()
    
    var endPoint: String = "/reactions"
    
    func get(completionHandler: @escaping ([VlogReaction]?) -> Void) {
        load(buildUrl()) { (vlogReactions) in
            completionHandler(vlogReactions)
        }
    }
    
    func get(id: Int, completionHandler: @escaping (VlogReaction?) -> Void) {
        let queryItems = [URLQueryItem(name: "vlogId", value: String(id))]
        load(buildUrl(queryItems: queryItems)) { (vlogReactions) in
            completionHandler((vlogReactions != nil) ? vlogReactions![0] : nil)
        }
    }
    
    func get(id: Int, multiple completionHandler: @escaping ([VlogReaction]?) -> Void) {
        let queryItems = [URLQueryItem(name: "vlogId", value: String(id))]
        load(buildUrl(queryItems: queryItems)) { (vlogReactions) in
            completionHandler(vlogReactions)
        }
    }
}
