//
//  VlogReactionTests.swift
//  SwabbrTests
//
//  Created by James Bal on 22-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import XCTest
@testable import Swabbr

class VlogReactionTests: XCTestCase {
    
    private var vlogReaction: VlogReaction!
    
    private class MockServer: VlogReactionDataSourceProtocol {
        
        private let vlogReaction: VlogReaction
        
        init(vlogReaction: VlogReaction) {
            self.vlogReaction = vlogReaction
        }
        
        func get(id: String, completionHandler: @escaping (VlogReaction?) -> Void) {
            do {
                let _ = try JSONEncoder().encode(vlogReaction)
                completionHandler(vlogReaction)
            } catch {
                completionHandler(nil)
            }
        }
        
        func getVlogReactions(id: String, completionHandler: @escaping ([VlogReaction]) -> Void) {
            
        }
        
    }
    
    private class MockCache: VlogReactionCacheDataSourceProtocol {
        
        private var vlogReaction: VlogReaction?
        
        func get(id: String, completionHandler: @escaping (VlogReaction) -> Void) throws {
            guard let vlogReaction = vlogReaction else {
                throw NSError(domain: "cache", code: 400, userInfo: nil)
            }
            completionHandler(vlogReaction)
        }
        
        func set(object: VlogReaction?) {
            guard var object = object else {
                return
            }
            object.id = "2"
            vlogReaction = object
        }
        
        func getAll(completionHandler: @escaping ([VlogReaction]) -> Void) throws {
            
        }
        
        func setAll(objects: [VlogReaction]) {
            
        }
    }

    override func setUp() {
        vlogReaction = VlogReaction(id: "1", isPrivate: true, ownerId: "1", duration: "12", postDate: "2020-04-02", vlogId: "2")
    }

    override func tearDown() {
        vlogReaction = nil
    }
    
    func testDataSourceEntityToModel() {
        
        let vlogReactionMockDS = MockServer(vlogReaction: vlogReaction)
        let vlogReactionMockCache = MockCache()
        let vlogReactionRepository = VlogReactionRepository(network: vlogReactionMockDS, cache: vlogReactionMockCache)
        let vlogReactionUseCase = VlogReactionUseCase(vlogReactionRepository)
        
        vlogReactionUseCase.get(id: "1", refresh: true) { (vlogReactionModel) in
            guard let vlogReactionModel = vlogReactionModel else {
                XCTFail("The vlogreaction object could not be converted to model")
                return
            }
            XCTAssertEqual(vlogReactionModel.id, self.vlogReaction.id)
        }
        
    }

    func testIfCacheDataIsUsed() {
        
        let vlogReactionMockDS = MockServer(vlogReaction: vlogReaction)
        let vlogReactionMockCache = MockCache()
        let vlogReactionRepository = VlogReactionRepository(network: vlogReactionMockDS, cache: vlogReactionMockCache)
        let vlogReactionUseCase = VlogReactionUseCase(vlogReactionRepository)
        
        vlogReactionUseCase.get(id: "1", refresh: false) { (vlogReactionModel) in
            
            guard let vlogReactionModel = vlogReactionModel else {
                XCTFail("The vlogreaction object could not be converted to model")
                return
            }
            
            XCTAssertEqual(vlogReactionModel.id, self.vlogReaction.id)
            
            vlogReactionUseCase.get(id: "1", refresh: false) { (vlogReactionModel) in
                
                XCTAssertEqual(vlogReactionModel!.id, "2")
                
            }
        }
        
    }

    func testCacheThrowingErrorWhenUserNotFound() {
        let vlogMockCache = MockCache()
        XCTAssertThrowsError(try vlogMockCache.get(id: "11111") { (vlog) in
            print(vlog)
        })
    }

}
