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
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler([])
                // failure handling
            }
        }
    }
    
    func get(id: String, completionHandler: @escaping (User?) -> Void) {
        AF.request(buildUrl(path: id)).responseDecodable { (response: DataResponse<User>) in
            switch response.result {
            case .success(let user):
                completionHandler(user)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil)
                // failure handling
            }
        }
    }
    
    func get(term: String, completionHandler: @escaping ([User]) -> Void) {
        // TODO: search for the user
        completionHandler([])
    }
}
