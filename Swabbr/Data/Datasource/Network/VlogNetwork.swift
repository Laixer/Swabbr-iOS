//
//  VlogNetwork.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
class VlogNetwork: NetworkProtocol, VlogDataSourceProtocol {
    
    typealias Entity = Vlog
    
    static let shared = VlogNetwork()
    
    var endPoint: String = "vlogs"
    
    func getAll(completionHandler: @escaping ([Vlog]?) -> Void) {
        load(buildUrl()) { (vlogs) in
            completionHandler(vlogs)
        }
    }
    
    func get(id: String, completionHandler: @escaping (Vlog?) -> Void) {
        let queryItems = [URLQueryItem(name: "id", value: id)]
        load(buildUrl(queryItems: queryItems)) { (vlogs) in
            completionHandler((vlogs != nil) ? vlogs![0] : nil)
        }
    }
    
    func getSingleMultiple(id: String, completionHandler: @escaping ([Vlog]?) -> Void) {
        let queryItems = [URLQueryItem(name: "userId", value: String(id))]
        load(buildUrl(queryItems: queryItems)) { (vlogs) in
            completionHandler(vlogs)
        }
    }
    
    func createLike(id: String, completionHandler: @escaping (Int) -> Void) {
        post(buildUrl(), withCompletion: { (responseCode) in
            completionHandler(responseCode)
        })
    }
    
    func createVlog(completionHandler: @escaping (Int) -> Void) {
        completionHandler(200)
    }
}

