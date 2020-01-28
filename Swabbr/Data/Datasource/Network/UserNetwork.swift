//
//  Network.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Alamofire

class UserNetwork: NetworkProtocol, UserDataSourceProtocol {
    
    var endPoint: String = "users"

    func getAll(completionHandler: @escaping ([User]) -> Void) {
        AF.request(buildUrl()).responseDecodable { (response: DataResponse<[User]>) in
            switch response.result {
            case .success(let users):
                completionHandler(users)
            case .failure:
                completionHandler([])
                // failure handling
            }
        }
    }
    
    func get(id: String, completionHandler: @escaping (User?) -> Void) {
        AF.request(buildUrl(path: id, authorization: true)).responseDecodable { (response: DataResponse<User>) in
            switch response.result {
            case .success(let user):
                completionHandler(user)
            case .failure:
                completionHandler(nil)
                // failure handling
            }
        }
    }
    
    func getCurrent(completionHandler: @escaping (User?, String?) -> Void) {
        AF.request(buildUrl(path: "self", authorization: true)).responseDecodable(completionHandler: { (response: DataResponse<User>) in
            switch response.result {
            case .success(let user):
                completionHandler(user, nil)
            case .failure(let error):
                completionHandler(nil,
                                  error.localizedDescription)
            }
        })
    }
    
    func searchForUsers(searchTerm: String, completionHandler: @escaping ([User]) -> Void) {
        let searchQuery = [URLQueryItem(name: "query", value: searchTerm)]
        AF.request(buildUrl(queryItems: searchQuery,
                            path: "search",
                            authorization: true)).responseDecodable(completionHandler: { (response: DataResponse<[User]>) in
            switch response.result {
            case .success(let users):
                completionHandler(users)
            case .failure:
                completionHandler([])
            }
        })
    }
}
