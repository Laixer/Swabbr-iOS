//
//  VlogNetwork.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
class VlogNetwork: NetworkProtocol, DataSourceSingleMultipleProtocol, DataSourceAllProtocol {
    
    typealias Entity = Vlog
    
    static let shared = VlogNetwork()
    
    var endPoint: String = "vlogs"
    
    func getAll(completionHandler: @escaping ([Vlog]?) -> Void) {
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
    
    func getSingleMultiple(id: Int, completionHandler: @escaping ([Vlog]?) -> Void) {
        let queryItems = [URLQueryItem(name: "userId", value: String(id))]
        load(buildUrl(queryItems: queryItems)) { (vlogs) in
            completionHandler(vlogs)
        }
    }
}

