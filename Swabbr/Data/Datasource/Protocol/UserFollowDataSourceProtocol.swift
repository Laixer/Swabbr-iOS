//
//  UserFollowDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol UserFollowDataSourceProtocol {
    func getFollowers(id: String, completionHandler: @escaping ([User]) -> Void)
    func getFollowing(id: String, completionHandler: @escaping ([User]) -> Void)
    func get(id: String, completionHandler: @escaping (FollowStatus?) -> Void)
}
