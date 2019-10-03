//
//  API.swift
//  Swabbr
//
//  Created by James Bal on 24-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
//  This class handles all api calls accordingly

import Foundation
import UIKit

protocol ApiResource {
    associatedtype ModelType: Decodable
    var methodPath: String {get}
    var queryItems: [URLQueryItem] {get}
}

extension ApiResource {
    var url: URL {
        var components = URLComponents(string: "https://my-json-server.typicode.com")!
        components.path = "/pnobbe/swabbrdata" + methodPath
        components.queryItems = queryItems
        return components.url!
    }
}

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func load(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequest {
    /**
     It handles the network transfer,
     it will make a call to the given url and it will handle the data accordingly and send it out to the callback function.
     The function accepts a URL and a callback function.
     - parameter url: An URL value representing the url to make the request to.
     - parameter completion: A callback function that takes a ModelType as parameter.
    */
    fileprivate func load(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(self.decode(data))
        })
        task.resume()
    }
    
}

class ApiRequest<Resource: ApiResource> {
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
}

extension ApiRequest: NetworkRequest {
    
    /**
     It decodes the data from the server to the set modeltype.
     This methode accepts a data value representing the bytes of the data.
     - parameter data: A data value representing the bytes of the data.
     - Returns: An array of objects according to the given modeltype.
    */
    func decode(_ data: Data) -> [Resource.ModelType]? {
        let wrapper = try? JSONDecoder().decode([Resource.ModelType].self, from: data)
        return wrapper
    }
    
    /**
     It will call the load function of the NetworkRequest class.
     This methode accepts a callback function to handle the results accordingly.
     - parameter completion: A callback function.
    */
    func load(withCompletion completion: @escaping ([Resource.ModelType]?) -> Void) {
        load(resource.url, withCompletion: completion)
    }
}

struct UserResource: ApiResource {
    typealias ModelType = User
    let methodPath = "/users"
    var queryItems: [URLQueryItem] = []
    
    /**
     Ask for a certain user by giving the user id to search for.
     - parameter userId: An int value representing an user id.
    */
    init(userId: Int) {
        queryItems.append(URLQueryItem(name: "id", value: String(userId)))
    }
}

struct VlogResource: ApiResource {
    typealias ModelType = Vlog
    let methodPath = "/vlogs"
    var queryItems: [URLQueryItem] = []
    
    init() {
        
    }
    
    /**
     Get all vlogs that comply with the given user id.
     It will try and fill all vlogs where the owner has the given id.
     - parameter userId: An int value which represents the user id we need to find the vlogs from.
    */
    init(userId: Int) {
        queryItems.append(URLQueryItem(name: "userId", value: String(userId)))
    }
}

struct VlogReactionResource: ApiResource {
    typealias ModelType = VlogReaction
    let methodPath = "/reactions"
    var queryItems: [URLQueryItem] = []
    
    /**
     Ask for a certain vlog by giving the vlog id to search for.
     It will make the REST API call using the given id as a parameter.
     - parameter vlogId: An int value which represents an id of the vlog that is requested.
    */
    init(vlogId: Int) {
        queryItems.append(URLQueryItem(name: "vlogId", value: String(vlogId)))
    }
}

struct UserFollowRequestsResource: ApiResource {
    typealias ModelType = UserFollowRequest
    let methodPath = "/followRequests"
    var queryItems: [URLQueryItem] = []
    
    init() {
        
    }
    
    /**
     Find the users that the user is currently following.
     - parameter requesterId: An int value representing the current user id.
    */
    init(requesterId: Int) {
        queryItems.append(URLQueryItem(name: "requesterId", value: String(requesterId)))
        queryItems.append(URLQueryItem(name: "status", value: UserFollowRequest.Status.ACCEPTED.rawValue))
    }
    
    /**
     Find the users that the user is currently followed by.
     - parameter receiverId: An int value representing the current user id.
     */
    init(receiverId: Int) {
        queryItems.append(URLQueryItem(name: "receiverId", value: String(receiverId)))
        queryItems.append(URLQueryItem(name: "status", value: UserFollowRequest.Status.ACCEPTED.rawValue))
    }
}

// MARK: ServerData
class ServerData {
    
    static var vlogs: [Vlog] = []
    static var users: [User] = []
    
    /**
     This function handles the API call to retrieve a user.
     When the request has been completed the result will be send with the callback function.
     - parameter completionHandler: The callback function which will be run when the request has been completed.
     */
    func getSpecificUser(id: Int, onComplete completionHandler: @escaping (User?) -> Void) {
        if let existingUser = ServerData.users.first(where: {$0.id == id}){
            completionHandler(existingUser)
            return
        }
        let usersRequest = ApiRequest(resource: UserResource(userId: id))
        usersRequest.load{(users: [User]?) in
            if users == nil {
                completionHandler(nil)
                return
            }
            ServerData.users.append(users![0])
            completionHandler(users![0])
        }
    }

    /**
     This function handles the API call to retrieve the vlogs.
     When the request has been completed the result will be send with the callback function.
     - parameter completionHandler: The callback function which will be run when the request has been completed.
     */
    func getVlogs(onComplete completionHandler: @escaping ([Vlog]?) -> Void) {
        // TODO: caching
        let vlogRequest = ApiRequest(resource: VlogResource())
        vlogRequest.load{(vlogs: [Vlog]?) in
            
            if vlogs == nil {
                completionHandler(nil)
                return
            }
            
            let vlogGroup = DispatchGroup()
            
            for vlog in vlogs! {
                vlogGroup.enter()
                self.getSpecificUser(id: vlog.ownerId, onComplete: {user in
                    if user == nil {
                        return
                    }
                    vlog.owner = user!
                    vlogGroup.leave()
                })
            }
            
            vlogGroup.notify(queue: .main) {
                ServerData.vlogs = vlogs!
                completionHandler(vlogs)
            }
        }
    }
    
    /**
     Ask the API to retrieve all vlogs of a certain user.
     This call will be made with a userId which will be used to identify the owner of the vlog.
     - parameter userId: An int value which represents the user id.
     - parameter completionHandler: The callback function which will be run when the request has been completed.
    */
    func getUserSpecificVlogs(_ userId: Int, onComplete completionHandler: @escaping ([Vlog]?) -> Void) {
        // TODO: caching
        let specificVlogRequest = ApiRequest(resource: VlogResource(userId: userId))
        specificVlogRequest.load {(vlogs: [Vlog]?) in
            completionHandler(vlogs)
        }
    }
    
    /**
     This function handles the API call to retrieve the reactions of a vlog.
     When the request has been completed the result will be send with the callback function.
     - parameter vlogId: The id of the vlog the reactions need to come from.
     - parameter completionHandler: The callback function which will be run when the request has been completed.
     */
    func getVlogReactions(_ vlogId: Int, onComplete completionHandler: @escaping ([VlogReaction]?) -> Void) {
        // TODO: caching
        let specificVlogRequest = ApiRequest(resource: VlogReactionResource(vlogId: vlogId))
        specificVlogRequest.load {(vlogReactions: [VlogReaction]?) in
            
            if vlogReactions == nil {
                completionHandler(nil)
                return
            }
            
            let reactionGroup = DispatchGroup()
            
            for reactions in vlogReactions! {
                reactionGroup.enter()
                self.getSpecificUser(id: reactions.ownerId, onComplete: {user in
                    if user == nil {
                        return
                    }
                    reactions.owner = user!
                    reactionGroup.leave()
                })
            }
            
            reactionGroup.notify(queue: .main) {
                completionHandler(vlogReactions)
            }
        }
    }
    
    /**
     Get the followers a certain user has using the user id of that user.
     When the request has been completed the result will be send with the callback function.
     - parameter userId: An int value representing the user id.
     - parameter completionHandler: The callback function which will be run when the request has been completed.
    */
    func getUserFollowers(_ userId: Int, onComplete completionHandler: @escaping ([User]) -> Void) {
        
        let getFollowersRequest = ApiRequest(resource: UserFollowRequestsResource(receiverId: userId))
        getFollowersRequest.load {(followers: [UserFollowRequest]?) in
            
            if followers == nil {
                completionHandler([])
                return
            }
            
            let followerGroup = DispatchGroup()
            
            var users: [User] = []
            
            for follower in followers! {
                followerGroup.enter()
                self.getSpecificUser(id: follower.requesterId, onComplete: {user in
                    if user == nil {
                        return
                    }
                    users.append(user!)
                    followerGroup.leave()
                })
            }
            
            followerGroup.notify(queue: .main) {
                completionHandler(users)
            }
            
        }
        
    }
    
}
