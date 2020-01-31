//
//  VlogReactionRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol VlogReactionRepositoryProtocol {
    /**
     Get a specific user reaction.
     - parameter id: The id of the reaction.
     - parameter refresh: When true retrieve data from remote.
     - parameter completionHandler: The callback will return an optional VlogReactionModel
    */
    func get(id: String, refresh: Bool, completionHandler: @escaping (VlogReactionModel?) -> Void)
    
    /**
     Get all reactions from a vlog.
     - parameter id: The id of the vlog.
     - parameter refresh: When true retrieve data from remote.
     - parameter completionHandler: The callback will return an list of VlogReactionModel
    */
    func getVlogReactions(id: String, refresh: Bool, completionHandler: @escaping ([VlogReactionModel]) -> Void)
    
    func createReaction(vlogReaction: CreatedVlogReactionModel, completionHandler: @escaping (String?) -> Void)
}
