//
//  UserFollowersNetwork.swift
//  Swabbr
//
//  Created by James Bal on 05-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Alamofire

class UserFollowNetwork: NetworkProtocol, UserFollowDataSourceProtocol {
    
    var endPoint: String = "users"
    
    func getFollowers(id: String, completionHandler: @escaping ([User]) -> Void) {
        AF.request(buildUrl(path: "\(id)/followers")).responseDecodable { (response: DataResponse<[User]>) in
            switch response.result {
            case .success(let users):
                completionHandler(users)
            case .failure:
                completionHandler([])
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
            }
        }
    }
    
    func unfollowUser(userId: String, completionHandler: @escaping (String?) -> Void) {
        var request = buildUrl(path: "\(userId)/unfollow")
        request.httpMethod = "DELETE"
        AF.request(request).response(completionHandler: { (response) in
            switch response.result {
            case .success:
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error.localizedDescription)
            }
        })
    }
}
