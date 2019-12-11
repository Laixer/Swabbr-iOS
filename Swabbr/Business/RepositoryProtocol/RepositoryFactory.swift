//
//  RepositoryFactory.swift
//  Swabbr
//
//  Created by James Bal on 06-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct RepositoryFactory<Model> {
    
    typealias GetHandler = ([Model]) -> Void
    typealias SetHandler = (Int) -> Void
    
    private var _getAll: ((Bool, (@escaping GetHandler)) -> Void)?
    private var _getSingleMultiple: ((String, Bool, (@escaping GetHandler)) -> Void)?
    private var _get: ((String, Bool, (@escaping (Model?) -> Void)) -> Void)?
    
    // repository specific
    // MARK: vlog
    private var _createLike: ((String, (@escaping SetHandler)) -> Void)?
    private var _createVlog: ((@escaping SetHandler) -> Void)?
    
    // MARK: followrequests
    private var _createFollowRequest: ((String, (@escaping SetHandler)) -> Void)?
    private var _destroyFollowRequest: ((String, (@escaping SetHandler)) -> Void)?
    private var _acceptFollowRequest: ((String, (@escaping SetHandler)) -> Void)?
    private var _declineFollowRequest: ((String, (@escaping SetHandler)) -> Void)?
    
    // MARK: userSettings
    private var _updateUserSettings: ((Model, (@escaping SetHandler)) -> Void)?
    
    init<Repository: RepositoryProtocol>(_ repository: Repository) where Repository.Model == Model {
        _get = repository.get
    }
    
    init<Repository: RepositorySingleMultipleProtocol>(_ repository: Repository) where Repository.Model == Model {
        _get = repository.get
        _getSingleMultiple = repository.getSingleMultiple
    }
    
    init<Repository: RepositoryAllProtocol>(_ repository: Repository) where Repository.Model == Model {
        _get = repository.get
        _getAll = repository.getAll
    }
    
    init<Repository: RepositorySingleMultipleProtocol & RepositoryAllProtocol>(_ repository: Repository) where Repository.Model == Model {
        _get = repository.get
        _getSingleMultiple = repository.getSingleMultiple
        _getAll = repository.getAll
    }
    
    init<Repository: VlogRepositoryProtocol>(_ repository: Repository) where Repository.Model == Model {
        _get = repository.get
        _getSingleMultiple = repository.getSingleMultiple
        _getAll = repository.getAll
        _createLike = repository.createLike
        _createVlog = repository.createVlog
    }
    
    init<Repository: FollowRequestRepositoryProtocol>(_ repository: Repository) where Repository.Model == Model {
        _get = repository.get
        _getSingleMultiple = repository.getSingleMultiple
        _getAll = repository.getAll
        _createFollowRequest = repository.createFollowRequest
        _destroyFollowRequest = repository.destroyFollowRequest
        _acceptFollowRequest = repository.acceptFollowRequest
        _declineFollowRequest = repository.destroyFollowRequest
    }
    
    init<Repository: UserSettingsRepositoryProtocol>(_ repository: Repository) where Repository.Model == Model {
        _get = repository.get
        _updateUserSettings = repository.updateUserSettings
    }
    
    func getAll(refresh: Bool, completionHandler: @escaping GetHandler) {
        _getAll?(refresh, completionHandler)
    }
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (Model?) -> Void) {
        _get?(id, refresh, completionHandler)
    }
    
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping GetHandler) {
        _getSingleMultiple?(id, refresh, completionHandler)
    }
}

// MARK: Vlog
extension RepositoryFactory {
    func createLike(id: String, completionHandler: @escaping SetHandler) {
        _createLike?(id, completionHandler)
    }
    
    func createVlog(completionHandler: @escaping SetHandler) {
        _createVlog?(completionHandler)
    }
}

// MARK: FollowRequest
extension RepositoryFactory {
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
extension RepositoryFactory {
    func updateUserSettings(userSettings: Model, completionHandler: @escaping SetHandler) {
        _updateUserSettings?(userSettings, completionHandler)
    }
}

