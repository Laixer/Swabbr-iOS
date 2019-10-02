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
    let queryItems: [URLQueryItem] = []
}

struct VlogResource: ApiResource {
    typealias ModelType = Vlog
    let methodPath = "/vlogs"
    let queryItems: [URLQueryItem] = []
}

struct SpecificVlogReactionResource: ApiResource {
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
}

// MARK: - ServerData
class ServerData {
    
    static var vlogs: [Vlog] = []
    static var users: [User] = []
    static var vlogReactions: [[VlogReaction]] = []
    
    enum Sort {
        case Old
        case New
    }
    
    /**
     This function handles the API call to retrieve the users.
     When the request has been completed the result will be send with the callback function.
     - parameter completionHandler: The callback function which will be run when the request has been completed.
     */
    func getUsers(onComplete completionHandler: @escaping ([User]?) -> Void) {
        // TODO: caching
        if ServerData.users.count > 0 {
            completionHandler(ServerData.users)
            return
        }
        let usersRequest = ApiRequest(resource: UserResource())
        usersRequest.load{(users: [User]?) in
            ServerData.users = users!
            completionHandler(users)
        }
    }

    /**
     This function handles the API call to retrieve the vlogs.
     When the request has been completed the result will be send with the callback function.
     - parameter completionHandler: The callback function which will be run when the request has been completed.
     */
    func getVlogs(onComplete completionHandler: @escaping ([Vlog]?) -> Void) {
        // TODO: caching
        if ServerData.vlogs.count > 0 {
            completionHandler(ServerData.vlogs)
            return
        }
        let vlogRequest = ApiRequest(resource: VlogResource())
        vlogRequest.load{(vlogs: [Vlog]?) in
            for vlog in vlogs! {
                if let existingUser = ServerData.users.first(where: {$0.id == vlog.ownerId}){
                    vlog.owner = existingUser
                }
            }
            ServerData.vlogs = vlogs!
            completionHandler(vlogs)
        }
    }
    
    func getVlogReactions(_ vlogId: Int, onComplete completionHandler: @escaping ([VlogReaction]?) -> Void) {
        // TODO: caching
        let specificVlogRequest = ApiRequest(resource: SpecificVlogReactionResource(vlogId: vlogId))
        specificVlogRequest.load {(vlogReactions: [VlogReaction]?) in
            for reactions in vlogReactions! {
                if let existingUser = ServerData.users.first(where: {$0.id == reactions.ownerId}){
                    reactions.owner = existingUser
                }
            }
            completionHandler(vlogReactions)
        }
    }
}
