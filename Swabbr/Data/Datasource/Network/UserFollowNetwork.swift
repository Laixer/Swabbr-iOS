//
//  UserFollowersNetwork.swift
//  Swabbr
//
//  Created by James Bal on 05-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Alamofire

class UserFollowNetwork: NetworkProtocol, UserFollowDataSourceProtocol {
    
    var endPoint: String = "followers"
    
    func getFollowers(id: String, completionHandler: @escaping ([User]) -> Void) {
        endPoint = "followers"
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
    
    // following
    func getFollowing(id: String, completionHandler: @escaping ([User]) -> Void) {
        endPoint = "following"
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
    
    // followstatus
    func get(id: String, completionHandler: @escaping (FollowStatus?) -> Void) {
        endPoint = "followStatus"
        AF.request(buildUrl(path: id)).responseDecodable { (response: DataResponse<FollowStatus>) in
            switch response.result {
            case .success(let followStatus):
                completionHandler(followStatus)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil)
                // failure handling
            }
        }
    }
}
