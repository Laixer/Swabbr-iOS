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
    private let followRequestUseCase = UserFollowRequestUseCase()
    
    public private(set) var user: UserItem? {
        didSet {
            delegate?.didRetrieveUser(self)
        }
    }
    
    public private(set) var followRequest: FollowRequestItem? {
        didSet {
            delegate?.setFollowStatus(followRequest?.status)
        }
    }
    
    /**
     Get certain user. Runs a callback when ready.
     - parameter userId: An user id.
     - parameter refresh: A boolean when true will retrieve data from remote.
    */
    func getUser(userId: String, refresh: Bool = false) {
        userUseCase.get(id: userId, refresh: refresh) { (userModel) in
            self.user = UserItem.mapToPresentation(model: userModel!)
        }
    }
    
    /**
     Get the follow status of the selected user.
     - parameter userId: A user id.
     - parameter refresh: A boolean when true will retrieve data from remote.
    */
    func getFollowStatus(userId: String, refresh: Bool = false) {
        followRequestUseCase.get(id: userId, refresh: refresh, completionHandler: { (followRequestModel) in
            guard let followRequestModel = followRequestModel else {
                self.followRequest = nil
                return
            }
            self.followRequest = FollowRequestItem.mapToPresentation(userFollowRequestModel: followRequestModel)
        })
    }
    
    /**
     Perform the action of following related actions.
     The action is dependent on the current follow state.
    */
    func createFollowRequest(userId: String) {
        followRequestUseCase.createFollowRequest(for: userId) { (followRequest, errorString) in
            self.delegate?.performedFollowRequestCall(errorString)
            guard let followRequest = followRequest else {
                return
            }
            self.followRequest = FollowRequestItem.mapToPresentation(userFollowRequestModel: followRequest)
        }
    }
    
    /**
     Remove the follow request.
    */
    func removeFollowRequest() {
        followRequestUseCase.destroyFollowRequest(followRequestId: followRequest!.id) { (errorString) in
            self.delegate?.performedFollowRequestCall(errorString)
            guard errorString == nil else {
                return
            }
            self.followRequest = nil
        }
    }
    
    /**
     Get the current authenticated user.
    */
    func getCurrentUser(refresh: Bool = false) {
        userUseCase.current(refresh: refresh) { (userModel, errorString) in
            guard errorString == nil else {
                return
            }
            self.user = UserItem.mapToPresentation(model: userModel!)
        }
    }
    
}

protocol ProfileViewControllerServiceDelegate: class {
    func didRetrieveUser(_ sender: ProfileViewControllerService)
    func setFollowStatus(_ followStatus: Int?)
    func performedFollowRequestCall(_ errorString: String?)
}
