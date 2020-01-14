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
     - parameter path: Optional string which will redirect to a specific path in the domain.
     - parameter authorization: Set to true to require the access token to be added, default is false.
     - Returns: An URLRequest object.
    */
    internal func buildUrl(queryItems: [URLQueryItem]? = nil, path: String = "", authorization: Bool = false) -> URLRequest {
        var components = URLComponents(string: ApiPreferences.shared.api_url)!
        components.path = ApiPreferences.shared.url_path + "/"  + endPoint
        components.path += "/" + path
        components.queryItems = queryItems
        var urlRequest = URLRequest(url: components.url!)
        if authorization {
            urlRequest.addValue(String.init(format: "Bearer %@",
                                            KeychainService.shared.get(key: "access_token")!),
                                            forHTTPHeaderField: "Authorization")
        }
        return urlRequest
    }
}
