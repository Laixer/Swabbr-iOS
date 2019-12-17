//
//  VlogRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol VlogRepositoryProtocol {
    typealias SetHandler = (Int) -> Void
    func get(id: String, refresh: Bool, completionHandler: @escaping (VlogModel?) -> Void)
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping ([VlogModel]) -> Void)
    func getAll(refresh: Bool, completionHandler: @escaping ([VlogModel]) -> Void)
    func createLike(id: String, completionHandler: @escaping SetHandler)
    func createVlog(completionHandler: @escaping SetHandler)
}
