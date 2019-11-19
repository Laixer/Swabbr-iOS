//
//  VlogVlogReactionDataRetriever.swift
//  Swabbr
//
//  Created by James Bal on 18-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserVlogReactionsDataRetriever {
    
    private let userRepository = UserRepository.shared
    private let vlogReactionRepository = VlogReactionRepository.shared
    
    // id = vlogId
    func get(id: Int, refresh: Bool, completionHandler: @escaping ([UserVlogReactionModel]?) -> Void) {
        vlogReactionRepository.get(id: id, refresh: refresh, multiple: { (vlogReactionModels) -> Void in
            let userVlogReactionGroup = DispatchGroup()
            var userVlogReactionModels: [UserVlogReactionModel] = []
            for vlogReactionModel in vlogReactionModels! {
                userVlogReactionGroup.enter()
                self.userRepository.get(id: vlogReactionModel.ownerId, refresh: refresh, completionHandler: { (userModel) -> Void in
                    userVlogReactionModels.append(UserVlogReactionModel(user: userModel!, reaction: vlogReactionModel))
                    userVlogReactionGroup.leave()
                })
            }
            userVlogReactionGroup.notify(queue: .main) {
                completionHandler(userVlogReactionModels)
            }
        })
    }
}
