//
//  VlogReactionDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol VlogReactionDataSourceProtocol {
    /**
     Get a specific user reaction.
     - parameter id: The id of the reaction.
     - parameter completionHandler: The callback will return an optional VlogReaction
     */
    func get(id: String, completionHandler: @escaping (VlogReaction?) -> Void)
    
    /**
     Get all reactions from a vlog.
     - parameter id: The id of the vlog.
     - parameter completionHandler: The callback will return an list of VlogReactionModel
     */
    func getVlogReactions(id: String, completionHandler: @escaping ([VlogReaction]) -> Void)
}
