//
//  ReactionViewControllerService.swift
//  Swabbr
//
//  Created by James Bal on 20-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class ReactionViewControllerService {
    
    weak var delegate: ReactionViewControllerServiceDelegate?
    
    private let vlogReactionUseCase = VlogReactionUseCase()
    private let userUseCase = UserUseCase()

    public private(set) var reactions: [UserVlogReactionItem]! = [] {
        didSet {
            delegate?.didRetrieveReactions(self)
        }
    }
    
    /**
     Get reactions of certain vlog. Runs a callback when ready.
     - parameter vlogId: A vlog id.
     - parameter refresh: A boolean when true will retrieve data from remote.
    */
    func getReactions(vlogId: String, refresh: Bool = false) {
        let dispatchGroup = DispatchGroup()
        vlogReactionUseCase.getSingleMultiple(id: vlogId, refresh: refresh, completionHandler: { (vlogReactionModels) -> Void in
            var userVlogReactionRepositoryModels: [UserVlogReactionItem] = []
            for vlogReactionModel in vlogReactionModels {
                dispatchGroup.enter()
                self.userUseCase.get(id: vlogReactionModel.ownerId, refresh: false, completionHandler: { (userModel) in
                    userVlogReactionRepositoryModels.append(UserVlogReactionItem.mapToPresentation(userModel: userModel!, vlogReactionModel: vlogReactionModel))
                    dispatchGroup.leave()
                })
            }
            dispatchGroup.notify(queue: .main, execute: {
                self.reactions = userVlogReactionRepositoryModels
            })
        })
    }
    
}

protocol ReactionViewControllerServiceDelegate: class {
    func didRetrieveReactions(_ sender: ReactionViewControllerService)
}
