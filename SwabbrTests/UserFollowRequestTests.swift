//
//  UserFollowRequestTests.swift
//  SwabbrTests
//
//  Created by James Bal on 22-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import XCTest
@testable import Swabbr

class UserFollowRequestTests: XCTestCase {
    
    var userFollowRequest: UserFollowRequest!
    
    private class MockServer: FollowRequestDataSourceProtocol {

        private let userFollowRequest: UserFollowRequest
        
        init(userFollowRequest: UserFollowRequest) {
            self.userFollowRequest = userFollowRequest
        }
        
        func get(id: String, completionHandler: @escaping (UserFollowRequest?) -> Void) {
            do {
                let _ = try JSONEncoder().encode(userFollowRequest)
                completionHandler(userFollowRequest)
            } catch {
                completionHandler(nil)
            }
        }
        
        func getIncomingRequests(completionHandler: @escaping ([UserFollowRequest]) -> Void) {
            
        }
        
        func getOutgoingRequests(completionHandler: @escaping ([UserFollowRequest]) -> Void) {
            
        }
        
        func createFollowRequest(for userId: String, completionHandler: @escaping (UserFollowRequest?, String?) -> Void) {
            
        }
        
        func destroyFollowRequest(followRequestId: String, completionHandler: @escaping (String?) -> Void) {
            completionHandler(nil)
        }
        
        func acceptFollowRequest(followRequestId: String, completionHandler: @escaping (String?) -> Void) {
            completionHandler(nil)
        }
        
        func declineFollowRequest(followRequestId: String, completionHandler: @escaping (String?) -> Void) {
            completionHandler(nil)
        }
        
    }

    override func setUp() {
        
        userFollowRequest = UserFollowRequest(id: "1",
                                              requesterId: "1",
                                              receiverId: "1",
                                              status: 0,
                                              timestamp: "12345")
        
    }

    override func tearDown() {
        userFollowRequest = nil
    }
    
    func testDataSourceEntityToPresentationItem() {
        
        let followRequestMockDS = MockServer(userFollowRequest: userFollowRequest)
        let repository = UserFollowRequestRepository(network: followRequestMockDS)
        let followRequestUseCase = UserFollowRequestUseCase(repository)
        
        followRequestUseCase.get(id: "1", refresh: true) { (followRequestModel) in
            guard let followRequestModel = followRequestModel else {
                XCTFail("The followrequest object could not be converted to model")
                return
            }
            XCTAssertNotNil(FollowRequestItem.mapToPresentation(userFollowRequestModel: followRequestModel), "The FollowRequestUseCase returns an incorrect Model which can't be converted to the item")
        }
        
    }

}
