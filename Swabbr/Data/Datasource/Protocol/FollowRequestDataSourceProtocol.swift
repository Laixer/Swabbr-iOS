//
//  FollowRequestDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol FollowRequestDataSourceProtocol {
    func get(id: String, completionHandler: @escaping (UserFollowRequest?) -> Void)
    func createFollowRequest(for userId: String, completionHandler: @escaping (UserFollowRequest?, String?) -> Void)
    func destroyFollowRequest(for userId: String, completionHandler: @escaping (String?) -> Void)
    func acceptFollowRequest(from userId: String, completionHandler: @escaping (String?) -> Void)
    func declineFollowRequest(from userId: String, completionHandler: @escaping (String?) -> Void)
}
