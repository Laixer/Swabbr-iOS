//
//  UserFollowersNetwork.swift
//  Swabbr
//
//  Created by James Bal on 05-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// swiftlint:disable force_try

import Alamofire

class UserFollowNetwork: NetworkProtocol, UserFollowDataSourceProtocol {
    
    var endPoint: String = "users/users"
    
    func getFollowers(id: String, completionHandler: @escaping ([User]) -> Void) {
        AF.request(buildUrl(path: "\(id)/followers")).responseDecodable { (response: DataResponse<[User]>) in
            switch response.result {
            case .success(let users):
                completionHandler(users)
            case .failure:
                completionHandler([])
                // failure handling
            }
        }
    }
    
    func getFollowing(id: String, completionHandler: @escaping ([User]) -> Void) {
        AF.request(buildUrl(path: "\(id)/following")).responseDecodable { (response: DataResponse<[User]>) in
            switch response.result {
            case .success(let users):
                completionHandler(users)
            case .failure:
                completionHandler([])
                // failure handling
            }
        }
    }
    
    func get(id: String, completionHandler: @escaping (FollowStatus?) -> Void) {
        AF.request(buildUrl()).responseDecodable { (response: DataResponse<FollowStatus>) in
            switch response.result {
            case .success(let followStatus):
                completionHandler(followStatus)
            case .failure(let error):
                completionHandler(nil)
                // failure handling
            }
        }
    }
}
