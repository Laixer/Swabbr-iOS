//
//  FollowRequestViewControllerService.swift
//  Swabbr
//
//  Created by James Bal on 13-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

class FollowRequestViewControllerService {
    
    weak var delegate: FollowRequestViewControllerServiceDelegate?
    
    private let userUseCase = UserUseCase()
    private let followRequestUseCase = UserFollowRequestUseCase()
    
    public private(set) var followRequests: [UserFollowRequestItem] = [] {
        didSet {
            self.delegate?.retrievedFollowRequests()
        }
    }
    
    /**
     Retrieve the list of the request that the current user has received.
    */
    func getIncomingFollowRequests() {
        followRequestUseCase.getIncomingRequests { (followRequestModels) in
            let followRequestGroup = DispatchGroup()
            var userFollowRequestItems: [UserFollowRequestItem] = []
            for followRequestModel in followRequestModels {
                followRequestGroup.enter()
                self.userUseCase.get(id: followRequestModel.requesterId, refresh: false, completionHandler: { (userModel) -> Void in
                    userFollowRequestItems.append(UserFollowRequestItem(userModel: userModel!, userFollowRequestModel: followRequestModel))
                    followRequestGroup.leave()
                })
            }
            followRequestGroup.notify(queue: .main) {
                self.followRequests = userFollowRequestItems
            }
        }
    }
    
    /**
     Retrieve the list of the request that the current user has sent.
     */
    func getOutgoingFollowRequests() {
        followRequestUseCase.getOutgoingRequests { (followRequestModels) in
            let followRequestGroup = DispatchGroup()
            var userFollowRequestItems: [UserFollowRequestItem] = []
            for followRequestModel in followRequestModels {
                followRequestGroup.enter()
                self.userUseCase.get(id: followRequestModel.receiverId, refresh: false, completionHandler: { (userModel) -> Void in
                    userFollowRequestItems.append(UserFollowRequestItem(userModel: userModel!, userFollowRequestModel: followRequestModel))
                    followRequestGroup.leave()
                })
            }
            followRequestGroup.notify(queue: .main) {
                self.followRequests = userFollowRequestItems
            }
        }
    }
    
    /**
     Remove the follow request.
     - parameter followRequestId: The id of the FollowRequest.
     */
    func removeFollowRequest(followRequestId: String) {
        followRequestUseCase.destroyFollowRequest(followRequestId: followRequestId) { (errorString) in
            self.delegate?.performedFollowRequestCall(errorString: errorString)
            guard errorString == nil else {
                return
            }
            self.followRequests = self.followRequests.filter({$0.followRequestId != followRequestId})
        }
    }
    
    /**
     Accept a specific follow request.
     - parameter followRequestId: The id of the FollowRequest.
    */
    func acceptFollowRequest(followRequestId: String) {
        followRequestUseCase.acceptFollowRequest(followRequestId: followRequestId) { (errorString) in
            // TODO: implementation
        }
    }
    
    /**
     Deny a specific follow request.
     - parameter followRequestId: The id of the FollowRequest.
     */
    func denyFollowRequest(followRequestId: String) {
        followRequestUseCase.declineFollowRequest(followRequestId: followRequestId) { (errorString) in
            // TODO: implementation
        }
    }
    
}

protocol FollowRequestViewControllerServiceDelegate: class {
    func performedFollowRequestCall(errorString: String?)
    func retrievedFollowRequests()
}
