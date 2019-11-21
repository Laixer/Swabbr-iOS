//
//  ProfileCollectionOverviewControllerService.swift
//  Swabbr
//
//  Created by James Bal on 20-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class ProfileCollectionOverviewControllerService {
    
    weak var delegate: ProfileCollectionOverviewControllerServiceDelegate?
    
    let vlogDataRetriever = VlogDataRetriever.shared
    let userDataRetriever = UserDataRetriever.shared
    let userFollowRequestDataRetriever = UserFollowRequestDataRetriever.shared
    
    var vlogs: [VlogItem]! = [] {
        didSet {
            delegate?.didRetrieveItems(self)
        }
    }
    
    var users: [UserItem]! = [] {
        didSet {
            delegate?.didRetrieveItems(self)
        }
    }
    
    /**
     Get vlogs of a certain user. Runs a callback when ready.
     - parameter userId: An user id.
    */
    func getVlogs(userId: Int) {
        vlogDataRetriever.get(id: userId, refresh: true, multiple: { (vlogModels) in
            self.vlogs = vlogModels?.compactMap({ (vlogModel) -> VlogItem in
                VlogItem.mapToPresentation(vlogModel: vlogModel)
            })
        })
    }
    
    /**
     Get followers of a certain user. Runs a callback when ready.
     - parameter userId: An user id.
    */
    func getFollowers(userId: Int) {
        // get followers
        let dispatchGroup = DispatchGroup()
        userFollowRequestDataRetriever.get(id: userId, refresh: false, multiple: { (userFollowRequestModels) in
            var followers: [UserItem] = []
            for userFollowRequestModel in userFollowRequestModels! {
                dispatchGroup.enter()
                self.userDataRetriever.get(id: userFollowRequestModel.receiverId, refresh: false, completionHandler: { (userModel) in
                    followers.append(UserItem.mapToPresentation(model: userModel!))
                    dispatchGroup.leave()
                })
            }
            dispatchGroup.notify(queue: .main, execute: {
                self.users = followers
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
