//
//  FollowRequestRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol FollowRequestRepositoryProtocol {
    typealias SetHandler = (Int) -> Void
    func get(id: String, refresh: Bool, completionHandler: @escaping (UserFollowRequestModel?) -> Void)
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping ([UserFollowRequestModel]) -> Void)
    func getAll(refresh: Bool, completionHandler: @escaping ([UserFollowRequestModel]) -> Void)
    func createFollowRequest(for userId: String, completionHandler: @escaping SetHandler)
    func destroyFollowRequest(for userId: String, completionHandler: @escaping SetHandler)
    func acceptFollowRequest(from userId: String, completionHandler: @escaping SetHandler)
    func declineFollowRequest(from userId: String, completionHandler: @escaping SetHandler)
}
