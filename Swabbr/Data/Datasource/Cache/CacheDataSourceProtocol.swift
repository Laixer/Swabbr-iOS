//
//  CacheDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 02-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// MARK: UserCacheDataSourceProtocol
protocol UserCacheDataSourceProtocol {
    func get(id: String, completionHandler: @escaping (User) -> Void) throws
    func set(object: User?)
    func getAll(completionHandler: @escaping ([User]) -> Void) throws
    func setAll(objects: [User])
}

// MARK: VlogCacheDataSourceProtocol
protocol VlogCacheDataSourceProtocol {
    func get(id: String, completionHandler: @escaping (Vlog) -> Void) throws
    func set(object: Vlog?)
}

// MARK: VlogReactionCacheDataSourceProtocol
protocol VlogReactionCacheDataSourceProtocol {
    func get(id: String, completionHandler: @escaping (VlogReaction) -> Void) throws
    func set(object: VlogReaction?)
    func getAll(completionHandler: @escaping ([VlogReaction]) -> Void) throws
    func setAll(objects: [VlogReaction])
}

// MARK: UserSettingsCacheDataSourceProtocol
protocol UserSettingsCacheDataSourceProtocol {
    func get(completionHandler: @escaping (UserSettings) -> Void) throws
    func set(object: UserSettings?)
    func remove()
}

// MARK: AuthorizedUserCacheDataSourceProtocol
protocol AuthorizedUserCacheDataSourceProtocol {
    func get(completionHandler: @escaping (AuthorizedUser) -> Void) throws
    func set(object: AuthorizedUser?)
    func remove()
}
