//
//  VlogNetwork.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
class VlogNetwork: NetworkProtocol {
    typealias Entity = Vlog
    
    static let shared = VlogNetwork()
    
    var endPoint: String = "/vlogs"
    
    func get(completionHandler: @escaping ([Vlog]?) -> Void) {
        load(buildUrl()) { (vlogs) in
            completionHandler(vlogs)
        }
    }
    
    func get(id: Int, completionHandler: @escaping (Vlog?) -> Void) {
        let queryItems = [URLQueryItem(name: "id", value: String(id))]
        load(buildUrl(queryItems: queryItems)) { (vlogs) in
            completionHandler((vlogs != nil) ? vlogs![0] : nil)
        }
    }
}

