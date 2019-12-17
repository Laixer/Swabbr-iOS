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
    
    func getAll(completionHandler: @escaping ([Vlog]) -> Void) {
        AF.request(buildUrl()).responseDecodable { (response: DataResponse<[Vlog]>) in
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
    
    func get(id: String, completionHandler: @escaping (Vlog?) -> Void) {
        AF.request(buildUrl(path: id)).responseDecodable { (response: DataResponse<Vlog>) in
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
    
    func getSingleMultiple(id: String, completionHandler: @escaping ([Vlog]) -> Void) {
        let queryItems = [URLQueryItem(name: "userId", value: id)]
        AF.request(buildUrl(queryItems: queryItems)).responseDecodable { (response: DataResponse<[Vlog]>) in
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
    
    func createLike(id: String, completionHandler: @escaping (Int) -> Void) {
        completionHandler(200)
    }
    
    func createVlog(completionHandler: @escaping (Int) -> Void) {
        completionHandler(200)
    }
}

