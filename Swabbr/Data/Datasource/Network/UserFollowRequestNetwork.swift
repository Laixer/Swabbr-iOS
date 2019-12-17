//
//  UserFollowRequestNetwork.swift
//  Swabbr
//
//  Created by James Bal on 20-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Alamofire

class UserFollowRequestNetwork: NetworkProtocol, FollowRequestDataSourceProtocol {
    
    static let shared = UserFollowRequestNetwork()
    
    var endPoint: String = "followRequests"
    
    func getAll(completionHandler: @escaping ([UserFollowRequest]) -> Void) {
        AF.request(buildUrl()).responseDecodable { (response: DataResponse<[UserFollowRequest]>) in
            switch response.result {
            case .success(let userFollowRequests):
                completionHandler(userFollowRequests)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler([])
                // failure handling
            }
        }
    }
    
    func get(id: String, completionHandler: @escaping (UserFollowRequest?) -> Void) {
        let queryItems = [URLQueryItem(name: "id", value: id)]
        AF.request(buildUrl(queryItems: queryItems)).responseDecodable { (response: DataResponse<UserFollowRequest>) in
            switch response.result {
            case .success(let userFollowRequest):
                completionHandler(userFollowRequest)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil)
                // failure handling
            }
        }
    }
    
    func getSingleMultiple(id: String, completionHandler: @escaping ([UserFollowRequest]) -> Void) {
        let queryItems = [URLQueryItem(name: "userId", value: id)]
        AF.request(buildUrl(queryItems: queryItems)).responseDecodable { (response: DataResponse<[UserFollowRequest]>) in
            switch response.result {
            case .success(let userFollowRequests):
                completionHandler(userFollowRequests)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler([])
                // failure handling
            }
        }
    }
    
    func createFollowRequest(for userId: String, completionHandler: @escaping (Int) -> Void) {
        completionHandler(200)
    }
    
    func destroyFollowRequest(for userId: String, completionHandler: @escaping (Int) -> Void) {
        completionHandler(200)
    }
    
    func acceptFollowRequest(from userId: String, completionHandler: @escaping (Int) -> Void) {
        completionHandler(200)
    }
    
    func declineFollowRequest(from userId: String, completionHandler: @escaping (Int) -> Void) {
        completionHandler(200)
    }
    
}
