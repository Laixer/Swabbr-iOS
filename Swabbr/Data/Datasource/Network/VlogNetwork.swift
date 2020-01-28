//
//  VlogNetwork.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Alamofire

class VlogNetwork: NetworkProtocol, VlogDataSourceProtocol {
    
    var endPoint: String = "vlogs"
    
    func getFeatured(completionHandler: @escaping ([Vlog]) -> Void) {
        AF.request(buildUrl(path: "featured", authorization: true)).responseDecodable { (response: DataResponse<[Vlog]>) in
            switch response.result {
            case .success(let vlogs):
                completionHandler(vlogs)
            case .failure:
                completionHandler([])
                // failure handling
            }
        }
    }
    
    func get(id: String, completionHandler: @escaping (Vlog?) -> Void) {
        AF.request(buildUrl(path: id, authorization: true)).responseDecodable { (response: DataResponse<Vlog>) in
            switch response.result {
            case .success(let vlog):
                completionHandler(vlog)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil)
                // failure handling
            }
        }
    }
    
    func getUserVlogs(id: String, completionHandler: @escaping ([Vlog]) -> Void) {
        AF.request(buildUrl(path: "users/\(id)", authorization: true)).responseDecodable { (response: DataResponse<[Vlog]>) in
            switch response.result {
            case .success(let vlogs):
                completionHandler(vlogs)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler([])
                // failure handling
            }
        }
    }
    
    func createLike(id: String, completionHandler: @escaping (String?) -> Void) {
        var request = buildUrl(path: "like/\(id)", authorization: true)
        request.httpMethod = "POST"
        AF.request(request).validate().response(completionHandler: { (response) in
            completionHandler(response.error?.localizedDescription)
        })
    }
    
    func createVlog(completionHandler: @escaping (String?) -> Void) {
        completionHandler(nil)
    }
}
