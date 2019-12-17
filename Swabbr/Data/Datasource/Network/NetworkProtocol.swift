//
//  NetworkProtocol.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
protocol NetworkProtocol {
    var endPoint: String {get}
}

extension NetworkProtocol {
    /**
     This will build up the url with possible queries if required.
     - parameter queryItems: This represents the possible parameters that will be given to an url, default is nil.
     - Returns: An URL object.
    */
    internal func buildUrl(queryItems: [URLQueryItem]? = nil, path: String = "") -> URL {
        var components = URLComponents(string: ApiPreferences.shared.api_url)!
        components.path = ApiPreferences.shared.url_path + "/"  + endPoint
        components.path += "/" + path
        components.queryItems = queryItems
        return components.url!
    }
}
