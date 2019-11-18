//
//  Network.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

protocol INetwork: IDataSource {
    var endPoint: String {get}
}

extension INetwork {
    /**
     It handles the network transfer,
     it will make a call to the given url and it will handle the data accordingly and send it out to the callback function.
     The function accepts a URL and a callback function.
     - parameter url: An URL value representing the url to make the request to.
     - parameter completion: A callback function that takes a ModelType as parameter.
     */
    internal func load(_ url: URL, withCompletion completion: @escaping ([Entity]?) -> Void) {
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
    
    /**
     It decodes the data from the server to the set modeltype.
     This methode accepts a data value representing the bytes of the data.
     - parameter data: A data value representing the bytes of the data.
     - Returns: An array of objects according to the given modeltype.
     */
    private func decode(_ data: Data) -> [Entity]? {
        let wrapper = try? JSONDecoder().decode([Entity].self, from: data)
        return wrapper
    }
    
    internal func urlComponents(queryItems: [URLQueryItem]? = nil) -> URLComponents {
        var components = URLComponents(string: ApiPreferences.shared.api_url)!
        components.path = ApiPreferences.shared.url_path + endPoint
        components.queryItems = queryItems
        return components
    }
    
}
