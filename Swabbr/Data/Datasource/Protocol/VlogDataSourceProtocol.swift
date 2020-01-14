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
    func getUserVlogs(id: String, completionHandler: @escaping ([Vlog]) -> Void)
    func getFeatured(completionHandler: @escaping ([Vlog]) -> Void)
    func createLike(id: String, completionHandler: @escaping SetHandler)
    func createVlog(completionHandler: @escaping SetHandler)
}
