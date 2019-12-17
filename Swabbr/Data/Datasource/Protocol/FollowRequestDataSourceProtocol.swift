//
//  FollowRequestDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol FollowRequestDataSourceProtocol {
    typealias SetHandler = (Int) -> Void
    func get(id: String, completionHandler: @escaping (UserFollowRequest?) -> Void)
    func getSingleMultiple(id: String, completionHandler: @escaping ([UserFollowRequest]) -> Void)
    func getAll(completionHandler: @escaping ([UserFollowRequest]) -> Void)
    func createFollowRequest(for userId: String, completionHandler: @escaping SetHandler)
    func destroyFollowRequest(for userId: String, completionHandler: @escaping SetHandler)
    func acceptFollowRequest(from userId: String, completionHandler: @escaping SetHandler)
    func declineFollowRequest(from userId: String, completionHandler: @escaping SetHandler)
}
