//
//  DataSourceFactory.swift
//  Swabbr
//
//  Created by James Bal on 06-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct DataSourceFactory<Entity: Decodable>{
    
    typealias GetHandler = ([Entity]?) -> Void
    typealias SetHandler = (Int) -> Void
    
    private var _getAll: ((@escaping GetHandler) -> Void)?
    private var _getSingleMultiple: ((String, (@escaping GetHandler)) -> Void)?
    private var _get: ((String, (@escaping (Entity?) -> Void)) -> Void)?
    
    // datasource specific
    // MARK: Vlog
    private var _createLike: ((String, (@escaping SetHandler)) -> Void)?
    private var _createVlog: ((@escaping(Int) -> Void) -> Void)?
    
    // MARK: FollowRequest
    private var _createFollowRequest: ((String, (@escaping SetHandler)) -> Void)?
    private var _destroyFollowRequest: ((String, (@escaping SetHandler)) -> Void)?
    private var _acceptFollowRequest: ((String, (@escaping SetHandler)) -> Void)?
    private var _declineFollowRequest: ((String, (@escaping SetHandler)) -> Void)?
    
    // MARK: userSettings
    private var _updateUserSettings: ((Entity, (@escaping SetHandler)) -> Void)?
    
    init<DataSource: DataSourceProtocol>(_ dataSource: DataSource) where DataSource.Entity == Entity {
        _get = dataSource.get
    }
    
    init<DataSource: DataSourceSingleMultipleProtocol>(_ dataSource: DataSource) where DataSource.Entity == Entity {
        _get = dataSource.get
        _getSingleMultiple = dataSource.getSingleMultiple
    }
    
    init<DataSource: DataSourceAllProtocol>(_ dataSource: DataSource) where DataSource.Entity == Entity {
        _get = dataSource.get
        _getAll = dataSource.getAll
    }
    
    init<DataSource: DataSourceSingleMultipleProtocol & DataSourceAllProtocol>(_ dataSource: DataSource) where DataSource.Entity == Entity {
        _get = dataSource.get
        _getSingleMultiple = dataSource.getSingleMultiple
        _getAll = dataSource.getAll
    }
    
    init<DataSource: VlogDataSourceProtocol>(_ dataSource: DataSource) where DataSource.Entity == Entity {
        _get = dataSource.get
        _getSingleMultiple = dataSource.getSingleMultiple
        _getAll = dataSource.getAll
        _createLike = dataSource.createLike
        _createVlog = dataSource.createVlog
    }
    
    init<DataSource: FollowRequestDataSourceProtocol>(_ dataSource: DataSource) where DataSource.Entity == Entity {
        _get = dataSource.get
        _getSingleMultiple = dataSource.getSingleMultiple
        _getAll = dataSource.getAll
        _createFollowRequest = dataSource.createFollowRequest
        _destroyFollowRequest = dataSource.destroyFollowRequest
        _acceptFollowRequest = dataSource.acceptFollowRequest
        _declineFollowRequest = dataSource.destroyFollowRequest
    }
    init<DataSource: UserSettingsDataSourceProtocol>(_ dataSource: DataSource) where DataSource.Entity == Entity {
        _get = dataSource.get
        _updateUserSettings = dataSource.updateUserSettings
    }
    
    func getAll(completionHandler: @escaping GetHandler) {
        _getAll?(completionHandler)
    }
    
    func getSingleMultiple(id: String, completionHandler: @escaping GetHandler) {
        _getSingleMultiple?(id, completionHandler)
    }
    
    func get(id: String, completionHandler: @escaping (Entity?) -> Void) {
        _get?(id, completionHandler)
    }
}

// MARK: Vlog
extension DataSourceFactory {
    func createLike(id: String, completionHandler: @escaping(Int) -> Void) {
        _createLike?(id, completionHandler)
    }
    
    func createVlog(completionHandler: @escaping(Int) -> Void) {
        _createVlog?(completionHandler)
    }
}

// MARK: FollowRequests
extension DataSourceFactory {
    func createFollowRequest(id: String, completionHandler: @escaping SetHandler) {
        _createFollowRequest?(id, completionHandler)
    }
    
    func destroyFollowRequest(id: String, completionHandler: @escaping SetHandler) {
        _destroyFollowRequest?(id, completionHandler)
    }
    
    func acceptFollowRequest(id: String, completionHandler: @escaping SetHandler) {
        _acceptFollowRequest?(id, completionHandler)
    }
    
    func declineFollowRequest(id: String, completionHandler: @escaping SetHandler) {
        _declineFollowRequest?(id, completionHandler)
    }
}

// MARK: UserSettings
extension DataSourceFactory {
    func updateUserSettings(userSettings: Entity, completionHandler: @escaping SetHandler) {
        _updateUserSettings?(userSettings, completionHandler)
    }
}
