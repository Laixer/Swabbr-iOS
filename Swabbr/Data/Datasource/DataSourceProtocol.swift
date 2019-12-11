//
//  DataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol DataSourceProtocol {
    typealias SetHandler = (Int) -> Void
    associatedtype Entity: Decodable
    /**
     Get a specifc entity by a certain id.
     - parameter id: An int value of an specific id.
     - parameter completionHandler: A callback returning the entity or nil.
     */
    func get(id: String, completionHandler: @escaping (Entity?) -> Void)
}

// MARK: VlogDataSourceProtocol
protocol VlogDataSourceProtocol: DataSourceSingleMultipleProtocol, DataSourceAllProtocol {
    func createLike(id: String, completionHandler: @escaping SetHandler)
    func createVlog(completionHandler: @escaping SetHandler)
}

// MARK: FollowRequestDataSourceProtocol
protocol FollowRequestDataSourceProtocol: DataSourceSingleMultipleProtocol, DataSourceAllProtocol {
    func createFollowRequest(for userId: String, completionHandler: @escaping SetHandler)
    func destroyFollowRequest(for userId: String, completionHandler: @escaping SetHandler)
    func acceptFollowRequest(from userId: String, completionHandler: @escaping SetHandler)
    func declineFollowRequest(from userId: String, completionHandler: @escaping SetHandler)
}

// MARK: UserSettingsDataSourceProtocol
protocol UserSettingsDataSourceProtocol: DataSourceProtocol {
    func updateUserSettings(userSettings: Entity, completionHandler: @escaping SetHandler)
}
