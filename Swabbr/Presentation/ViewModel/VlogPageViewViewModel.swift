//
//  VlogPageViewViewModel.swift
//  Swabbr
//
//  Created by James Bal on 18-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class VlogPageViewViewModel {
    
    weak var delegate: VlogPageViewViewModelDelegate?
    
    let vlogReactionDataRetriever = VlogReactionDataRetriever.shared
    let userDataRetriever = UserDataRetriever.shared

    var vlog: VlogUserRepositoryModel!
    var reactions: [UserVlogReactionRepositoryModel]! = [] {
        didSet {
            delegate?.didRetrieveReactions(self)
        }
    }
    
    private let dispatchGroup = DispatchGroup()
    
    func getReactions(vlogId: Int) {
        vlogReactionDataRetriever.get(vlogId: vlogId, refresh: false, completionHandler: { (vlogReactionModels) -> Void in
            var userVlogReactionRepositoryModels: [UserVlogReactionRepositoryModel] = []
            for vlogReactionModel in vlogReactionModels! {
                self.dispatchGroup.enter()
                self.userDataRetriever.get(id: vlogReactionModel.ownerId, refresh: false, completionHandler: { (userModel) in
                    userVlogReactionRepositoryModels.append(UserVlogReactionRepositoryModel.mapToPresentation(userModel: userModel!, vlogReactionModel: vlogReactionModel))
                    self.dispatchGroup.leave()
                })
            }
            self.dispatchGroup.notify(queue: .main, execute: {
                self.reactions = userVlogReactionRepositoryModels
            })
        })
    }
    
}

protocol VlogPageViewViewModelDelegate: class {
    func didRetrieveReactions(_ sender: VlogPageViewViewModel)
}
