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
}

extension ApiResource {
    var url: URL {
        var components = URLComponents(string: "https://my-json-server.typicode.com")!
        components.path = "/pnobbe/swabbrdata" + methodPath
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
}
