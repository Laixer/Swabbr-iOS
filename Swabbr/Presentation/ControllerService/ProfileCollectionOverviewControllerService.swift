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
    private let userFollowUseCase = UserFollowUseCase()
    
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
     - parameter refresh: A boolean when true will retrieve data from remote.
    */
    func getVlogs(userId: String, refresh: Bool = false) {
        vlogUseCase.getSingleMultiple(id: userId, refresh: refresh, completionHandler: { (vlogModels) in
            self.vlogs = vlogModels.compactMap({ (vlogModel) -> VlogItem in
                VlogItem.mapToPresentation(vlogModel: vlogModel)
            })
        })
    }
    
    /**
     Get followers of a certain user. Runs a callback when ready.
     - parameter userId: An user id.
     - parameter refresh: A boolean when true will retrieve data from remote.
    */
    func getFollowers(userId: String, refresh: Bool = false) {
        userFollowUseCase.getFollowers(id: userId, refresh: refresh, completionHandler: { (userModels) in
            self.users = userModels.compactMap({ (userModel) -> UserItem in
                UserItem.mapToPresentation(model: userModel)
            })
        })
    }
    
    /**
     Get the accounts the user is following. Runs a callback when ready.
     - parameter userId: An user id.
     - parameter refresh: A boolean when true will retrieve data from remote.
    */
    func getFollowing(userId: String, refresh: Bool = false) {
        userFollowUseCase.getFollowing(id: userId, refresh: refresh, completionHandler: { (userModels) in
            self.users = userModels.compactMap({ (userModel) -> UserItem in
                UserItem.mapToPresentation(model: userModel)
            })
        })
    }
    
}

protocol ProfileCollectionOverviewControllerServiceDelegate: class {
    func didRetrieveItems(_ sender: ProfileCollectionOverviewControllerService)
}
