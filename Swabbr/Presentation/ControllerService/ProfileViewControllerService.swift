//
//  ProfileViewControllerService.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class ProfileViewControllerService {
    
    weak var delegate: ProfileViewControllerServiceDelegate?
    
    private let userUseCase = UserUseCase()
    private let vlogUseCase = VlogUseCase()
    private let followStatusUseCase = FollowStatusUseCase()
    private let followRequestUseCase = UserFollowRequestUseCase()
    
    public private(set) var user: UserItem! {
        didSet {
            delegate?.didRetrieveUser(self)
        }
    }
    
    public private(set) var vlogs: [VlogItem]! = [] {
        didSet {
            delegate?.didRetrieveVlogs(self)
        }
    }
    
    /**
     Get certain user. Runs a callback when ready.
     - parameter userId: A user id.
     - parameter refresh: A boolean when true will retrieve data from remote.
    */
    func getUser(userId: String, refresh: Bool = false) {
        userUseCase.get(id: userId, refresh: refresh) { (userModel) in
            self.user = UserItem.mapToPresentation(model: userModel!)
        }
    }
    
    /**
     Get vlogs from a specific user. Runs a callback when ready.
     - parameter userId: A user id.
     - parameter refresh: A boolean when true will retrieve data from remote.
    */
    func getVlogs(userId: String, refresh: Bool = false) {
        vlogUseCase.getSingleMultiple(id: userId, refresh: refresh, completionHandler: { (vlogModels) -> Void in
            self.vlogs = vlogModels.compactMap({ (vlogModel) -> VlogItem in
                VlogItem.mapToPresentation(vlogModel: vlogModel)
            })
        })
    }
    
    /**
     Get the follow status of the selected user.
     - parameter userId: A user id.
     - parameter refresh: A boolean when true will retrieve data from remote.
    */
    func getFollowStatus(userId: String, refresh: Bool = false) {
        followStatusUseCase.get(id: userId, refresh: refresh, completionHandler: { (followStatusModel) in
            self.delegate?.setFollowStatus(followStatusModel!.status)
        })
    }
    
    /**
     Perform the action of following related actions.
     The action is dependent on the current follow state.
    */
    func performFollowAction(completionHandler: @escaping (Error) -> Void) {
        followStatusUseCase.get(id: user.id, refresh: true, completionHandler: { (followStatusModel) in
        })
    }
    
}

protocol ProfileViewControllerServiceDelegate: class {
    func didRetrieveUser(_ sender: ProfileViewControllerService)
    func didRetrieveVlogs(_ sender: ProfileViewControllerService)
    func setFollowStatus(_ followStatus: String)
}
