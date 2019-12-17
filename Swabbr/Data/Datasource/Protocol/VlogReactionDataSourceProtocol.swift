//
//  VlogReactionDataSourceProtocol.swift
//  
//
//  Created by James Bal on 17-12-19.
//

protocol VlogReactionDataSourceProtocol {
    func get(id: String, completionHandler: @escaping (VlogReaction?) -> Void)
    func getSingleMultiple(id: String, completionHandler: @escaping ([VlogReaction]) -> Void)
    func getAll(completionHandler: @escaping ([VlogReaction]) -> Void)
}
