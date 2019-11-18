//
//  VlogNetwork.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
class VlogNetwork: INetwork {
    typealias Entity = Vlog
    
    static let shared = VlogNetwork()
    
    var endPoint: String = "/vlogs"
    
    func get(completionHandler: @escaping ([Vlog]?) -> Void) {
        load(urlComponents().url!) { (vlogs) in
            completionHandler(vlogs)
        }
    }
    
    func get(id: Int, completionHandler: @escaping (Vlog?) -> Void) {
        let queryItems = [URLQueryItem(name: "id", value: String(id))]
        load(urlComponents(queryItems: queryItems).url!) { (vlogs) in
            completionHandler(vlogs![0])
        }
    }
}

