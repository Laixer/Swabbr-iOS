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
    
    func getOutgoingRequests(completionHandler: @escaping ([UserFollowRequest]) -> Void) {
        AF.request(buildUrl(path: "outgoing", authorization: true)).responseDecodable { (response: DataResponse<[UserFollowRequest]>) in
            switch response.result {
            case .success(let userFollowRequests):
                completionHandler(userFollowRequests)
            case .failure:
                completionHandler([])
                // failure handling
            }
        }
    }
    
    func getIncomingRequests(completionHandler: @escaping ([UserFollowRequest]) -> Void) {
        AF.request(buildUrl(path: "incoming", authorization: true)).responseDecodable { (response: DataResponse<[UserFollowRequest]>) in
            switch response.result {
            case .success(let userFollowRequests):
                completionHandler(userFollowRequests)
            case .failure:
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
            case .failure:
                completionHandler(nil)
                // failure handling
            }
        }
    }
    
    func createFollowRequest(for userId: String, completionHandler: @escaping (UserFollowRequest?, String?) -> Void) {
        let queryItems = [URLQueryItem(name: "receiverId", value: userId)]
        var request = buildUrl(queryItems: queryItems, path: "send", authorization: true)
        request.httpMethod = "POST"
        AF.request(request).responseData { response in
            guard let data = response.result.value else {
                completionHandler(nil, "Server Error")
                return
            }
            
            if let userFollowRequest = try? JSONDecoder().decode(UserFollowRequest.self, from: data) {
                completionHandler(userFollowRequest, nil)
            }
            
            if let error = try? JSONDecoder().decode(SError.self, from: data) {
                completionHandler(nil, error.message)
            }
        }
    }
    
    func destroyFollowRequest(followRequestId: String, completionHandler: @escaping (String?) -> Void) {
        let queryItems = [URLQueryItem(name: "followRequestId", value: followRequestId)]
        var request = buildUrl(queryItems: queryItems, path: "\(followRequestId)/cancel", authorization: true)
        request.httpMethod = "DELETE"
        AF.request(request).validate().response { (response) in
            switch response.result {
            case .success:
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error.localizedDescription)
            }
        }
    }
    
    func acceptFollowRequest(followRequestId: String, completionHandler: @escaping (String?) -> Void) {
        let queryItems = [URLQueryItem(name: "followRequestId", value: followRequestId)]
        var request = buildUrl(queryItems: queryItems, path: "\(followRequestId)/accept", authorization: true)
        request.httpMethod = "PUT"
        AF.request(request).validate().response { (response) in
            switch response.result {
            case .success:
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error.localizedDescription)
            }
        }
    }
    
    func declineFollowRequest(followRequestId: String, completionHandler: @escaping (String?) -> Void) {
        let queryItems = [URLQueryItem(name: "followRequestId", value: followRequestId)]
        var request = buildUrl(queryItems: queryItems, path: "\(followRequestId)/decline", authorization: true)
        request.httpMethod = "PUT"
        AF.request(request).validate().response { (response) in
            switch response.result {
            case .success:
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error.localizedDescription)
            }
        }
    }
    
}
