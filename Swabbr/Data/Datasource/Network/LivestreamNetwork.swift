//
//  LivestreamNetwork.swift
//  Swabbr
//
//  Created by James Bal on 20-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

import Alamofire

class LivestreamNetwork: NetworkProtocol, LivestreamDataSourceProtocol {
    
    var endPoint: String = "livestreams"
    
    func start(id: String, completionHandler: @escaping (String?) -> Void) {
        var request = buildUrl(path: "\(id)/start", authorization: true)
        request.httpMethod = "PUT"
        AF.request(request).response(completionHandler: { (response) in
            switch response.result {
            case .success:
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error.localizedDescription)
            }
        })
    }
    
    func stop(id: String, completionHandler: @escaping (String?) -> Void) {
        var request = buildUrl(path: "\(id)/stop", authorization: true)
        request.httpMethod = "PUT"
        AF.request(request).response(completionHandler: { (response) in
            switch response.result {
            case .success:
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error.localizedDescription)
            }
        })
    }
    
}
