//
//  VlogUseCase.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class VlogUseCase: RepositoryMultipleProtocol {
    typealias Model = VlogModel
    
    static let shared = VlogUseCase()
    
    private let repository = VlogRepository.shared
    
    func get(refresh: Bool, completionHandler: @escaping ([VlogModel]) -> Void) {
        repository.get(refresh: refresh, completionHandler: completionHandler)
    }
    
    func get(id: Int, refresh: Bool, completionHandler: @escaping (VlogModel?) -> Void) {
        repository.get(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
    func get(id: Int, refresh: Bool, multiple completionHandler: @escaping ([VlogModel]) -> Void) {
        repository.get(id: id, refresh: refresh, multiple: completionHandler)
    }
}
