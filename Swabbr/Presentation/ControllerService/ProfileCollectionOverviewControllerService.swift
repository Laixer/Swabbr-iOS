//
//  ProfileCollectionOverviewControllerService.swift
//  Swabbr
//
//  Created by James Bal on 20-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class ProfileCollectionOverviewControllerService {
    
    weak var delegate: ProfileCollectionOverviewControllerServiceDelegate?
    
    private let vlogUseCase = VlogUseCase()
    private let userUseCase = UserUseCase()
    private let userFollowRequestUseCase = UserFollowerUseCase()
    
    public private(set) var vlogs: [VlogItem]! = [] {
        didSet {
            delegate?.didRetrieveItems(self)
        }
    }
    
    public private(set) var users: [UserItem]! = [] {
        didSet {
            delegate?.didRetrieveItems(self)
        }
    }
    
    /**
     Get vlogs of a certain user. Runs a callback when ready.
     - parameter userId: An user id.
    */
    func getVlogs(userId: Int) {
        vlogUseCase.getSingleMultiple(id: userId, refresh: true, completionHandler: { (vlogModels) in
            self.vlogs = vlogModels.compactMap({ (vlogModel) -> VlogItem in
                VlogItem.mapToPresentation(vlogModel: vlogModel)
            })
        })
    }
    
    /**
     Get followers of a certain user. Runs a callback when ready.
     - parameter userId: An user id.
    */
    func getFollowers(userId: Int) {
        userFollowRequestUseCase.get(refresh: false, completionHandler: { (userModels) in
            self.users = userModels.compactMap({ (userModel) -> UserItem in
                UserItem.mapToPresentation(model: userModel)
            })
        })
    }
    
    func getFollowing(userId: Int) {
        // get following
    }
    
}

protocol ProfileCollectionOverviewControllerServiceDelegate: class {
    func didRetrieveItems(_ sender: ProfileCollectionOverviewControllerService)
}
