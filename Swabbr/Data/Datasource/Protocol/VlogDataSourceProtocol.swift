//
//  VlogDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol VlogDataSourceProtocol {
    typealias SetHandler = (Int) -> Void
    func get(id: String, completionHandler: @escaping (Vlog?) -> Void)
    func getSingleMultiple(id: String, completionHandler: @escaping ([Vlog]) -> Void)
    func getAll(completionHandler: @escaping ([Vlog]) -> Void)
    func createLike(id: String, completionHandler: @escaping SetHandler)
    func createVlog(completionHandler: @escaping SetHandler)
}
