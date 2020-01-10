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
    
    var endPoint: String = "followrequests"
    
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
        AF.request(buildUrl(path: "outgoing/\(id)", authorization: true)).responseDecodable { (response: DataResponse<UserFollowRequest>) in
            switch response.result {
            case .success(let userFollowRequest):
                completionHandler(userFollowRequest)
            case .failure(let error):
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
    
    func createFollowRequest(for userId: String, completionHandler: @escaping (UserFollowRequest?, String?) -> Void) {
        let queryItems = [URLQueryItem(name: "receiverId", value: userId)]
        var request = buildUrl(queryItems: queryItems, path: "send", authorization: true)
        request.httpMethod = "POST"
        AF.request(request).validate().responseDecodable { (response: DataResponse<UserFollowRequest>) in
            switch response.result {
            case .success(let userFollowRequest):
                completionHandler(userFollowRequest, nil)
            case .failure:
                completionHandler(nil, String.init(format: "%d: %@", response.response!.statusCode, String.init(data: response.data!, encoding: .utf8)!))
            }
        }
    }
    
    func destroyFollowRequest(for userId: String, completionHandler: @escaping (String?) -> Void) {
        let queryItems = [URLQueryItem(name: "followRequestId", value: userId)]
        var request = buildUrl(queryItems: queryItems, path: "\(userId)/cancel", authorization: true)
        request.httpMethod = "DELETE"
        AF.request(request).validate().response { (response) in
            switch response.result {
            case .success:
                completionHandler(nil)
            case .failure:
                completionHandler(String.init(format: "%d: %@", response.response!.statusCode, String.init(data: response.data!, encoding: .utf8)!))
            }
        }
    }
    
    func acceptFollowRequest(from userId: String, completionHandler: @escaping (String?) -> Void) {
        completionHandler(nil)
    }
    
    func declineFollowRequest(from userId: String, completionHandler: @escaping (String?) -> Void) {
        completionHandler(nil)
    }
    
}
