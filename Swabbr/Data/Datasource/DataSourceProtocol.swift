//
//  DataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol DataSourceProtocol {
    associatedtype Entity: Decodable
    
    func get(completionHandler: @escaping ([Entity]?) -> Void)
    func get(id: Int, completionHandler: @escaping (Entity?) -> Void)
}

protocol DataSourceMultipleProtocol: DataSourceProtocol {
    func get(id: Int, multiple completionHandler: @escaping ([Entity]?) -> Void)
}
