//
//  RepositoryFactory.swift
//  Swabbr
//
//  Created by James Bal on 06-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct RepositoryFactory<Model>: RepositoryProtocol, RepositorySingleMultipleProtocol, RepositoryAllProtocol {
    
    private var _getAll: ((Bool, (@escaping ([Model]) -> Void)) -> Void)?
    private var _getSingleMultiple: ((String, Bool, (@escaping ([Model]) -> Void)) -> Void)?
    private var _get: ((String, Bool, (@escaping (Model?) -> Void)) -> Void)?
    
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
    
    func getAll(refresh: Bool, completionHandler: @escaping ([Model]) -> Void) {
        _getAll?(refresh, completionHandler)
    }
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (Model?) -> Void) {
        _get?(id, refresh, completionHandler)
    }
    
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping ([Model]) -> Void) {
        _getSingleMultiple?(id, refresh, completionHandler)
    }
}

