//
//  VlogReactionDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol VlogReactionDataSourceProtocol {
    func get(id: String, completionHandler: @escaping (VlogReaction?) -> Void)
    func getSingleMultiple(id: String, completionHandler: @escaping ([VlogReaction]) -> Void)
    func getAll(completionHandler: @escaping ([VlogReaction]) -> Void)
}
