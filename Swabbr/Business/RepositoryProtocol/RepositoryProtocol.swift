//
//  RepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol RepositoryProtocol {
    typealias SetHandler = (Int) -> Void
    associatedtype Model
    
    /**
     Get a specifc model by a certain id.
     - parameter id: An int value of an specific id.
     - parameter refresh: A boolean when false look in the cache first.
     - parameter completionHandler: A callback returning the model or nil.
     */
    func get(id: String, refresh: Bool, completionHandler: @escaping (Model?) -> Void)
}

// MARK: VlogRepositoryProtocol
protocol VlogRepositoryProtocol: RepositorySingleMultipleProtocol, RepositoryAllProtocol {
    func createLike(id: String, completionHandler: @escaping SetHandler)
    func createVlog(completionHandler: @escaping SetHandler)
}

// MARK: FollowRepositoryProtocol
protocol FollowRequestRepositoryProtocol: RepositorySingleMultipleProtocol, RepositoryAllProtocol {
    func createFollowRequest(for userId: String, completionHandler: @escaping SetHandler)
    func destroyFollowRequest(for userId: String, completionHandler: @escaping SetHandler)
    func acceptFollowRequest(from userId: String, completionHandler: @escaping SetHandler)
    func declineFollowRequest(from userId: String, completionHandler: @escaping SetHandler)
}

// MARK: UserSettingsRepositoryProtocol
protocol UserSettingsRepositoryProtocol: RepositoryProtocol {
    func updateUserSettings(userSettings: Model, completionHandler: @escaping SetHandler)
}
