//
//  VlogTests.swift
//  SwabbrTests
//
//  Created by James Bal on 14-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import XCTest
@testable import Swabbr

class VlogTests: XCTestCase {
    
    private var vlog: Vlog!
    
    private class MockServer: VlogDataSourceProtocol {
        
        private let vlog: Vlog
        
        init(vlog: Vlog) {
            self.vlog = vlog
        }
        
        func get(id: String, completionHandler: @escaping (Vlog?) -> Void) {
            do {
                let _ = try JSONEncoder().encode(vlog)
                completionHandler(vlog)
            } catch {
                completionHandler(nil)
            }
        }
        
        func getUserVlogs(id: String, completionHandler: @escaping ([Vlog]) -> Void) {
            completionHandler([vlog])
        }
        
        func getFeatured(completionHandler: @escaping ([Vlog]) -> Void) {
            completionHandler([vlog])
        }
        
        func createLike(id: String, completionHandler: @escaping (Int) -> Void) {
            completionHandler(200)
        }
        
        func createVlog(completionHandler: @escaping (Int) -> Void) {
            completionHandler(200)
        }
        
        func get(id: String, completionHandler: @escaping (Int) -> Void) {
            completionHandler(200)
        }
    }
    
    private class MockCache: VlogCacheDataSourceProtocol {
        
        private var vlog: Vlog?
        
        func get(id: String, completionHandler: @escaping (Vlog) -> Void) throws {
            guard let vlog = vlog else {
                throw NSError(domain: "cache", code: 400, userInfo: nil)
            }
            completionHandler(vlog)
        }
        
        func set(object: Vlog?) {
            guard var object = object else {
                return
            }
            object.id = "2"
            vlog = object
        }
        
        
    }

    override func setUp() {
        vlog = Vlog(id: "1",
                    isPrivate: true,
                    duration: "00:00",
                    startDate: "08-08-08 16:45",
                    totalLikes: 10,
                    totalReactions: 10,
                    totalViews: 10,
                    isLive: true,
                    ownerId: "1")
    }

    override func tearDown() {
        vlog = nil
    }

    func testDataSourceEntityToPresentationItem() {
    
        let vlogMockDS = MockServer(vlog: vlog)
        let vlogUseCase = VlogUseCase(VlogRepository(network: vlogMockDS))
    
        vlogUseCase.get(id: "1", refresh: true) { (vlogModel) in
            guard let vlogModel = vlogModel else {
                XCTFail("The vlog object could not be converted to model")
                return
            }
            XCTAssertNotNil(VlogItem.mapToPresentation(vlogModel: vlogModel), "The VlogUseCase returns an incorrect Model which can't be converted to the item")
        }
    
    }
    
    func testIfCacheDataIsUsed() {
        
        let vlogMockDS = MockServer(vlog: vlog)
        let vlogMockCache = MockCache()
        let vlogUseCase = VlogUseCase(VlogRepository(network: vlogMockDS, cache: vlogMockCache))
        
        vlogUseCase.get(id: "1", refresh: false) { (vlogModel) in
            
            guard let vlogModel = vlogModel else {
                XCTFail("The vlog object could not be converted to model")
                return
            }
            
            XCTAssertEqual(vlogModel.id, self.vlog.id)
            
            vlogUseCase.get(id: "1", refresh: false) { (vlogModel) in
                
                XCTAssertEqual(vlogModel!.id, "2")
                
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
