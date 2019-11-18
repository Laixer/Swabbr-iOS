//
//  IDataSource.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol IDataSource {
    associatedtype Entity: Decodable
    
    func get(completionHandler: @escaping ([Entity]?) -> Void)
    func get(id: Int, completionHandler: @escaping (Entity?) -> Void)
}
