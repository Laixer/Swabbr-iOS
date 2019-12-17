//
//  VlogReactionRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol VlogReactionRepositoryProtocol {
    func get(id: String, refresh: Bool, completionHandler: @escaping (VlogReactionModel?) -> Void)
    func getSingleMultiple(id: String, refresh: Bool, completionHandler: @escaping ([VlogReactionModel]) -> Void)
    func getAll(refresh: Bool, completionHandler: @escaping ([VlogReactionModel]) -> Void)
}
