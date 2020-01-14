//
//  VlogReaction.swift
//  Swabbr
//
//  Created by James Bal on 18-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Alamofire

class VlogReactionNetwork: NetworkProtocol, VlogReactionDataSourceProtocol {
    
    var endPoint: String = "reactions"
    
    func get(id: String, completionHandler: @escaping (VlogReaction?) -> Void) {
        let queryItems = [URLQueryItem(name: "vlogId", value: id)]
        AF.request(buildUrl(queryItems: queryItems)).responseDecodable { (response: DataResponse<VlogReaction>) in
            switch response.result {
            case .success(let vlogReaction):
                completionHandler(vlogReaction)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil)
                // failure handling
            }
        }
    }
    
    func getVlogReactions(id: String, completionHandler: @escaping ([VlogReaction]) -> Void) {
        let queryItems = [URLQueryItem(name: "vlogId", value: id)]
        AF.request(buildUrl(queryItems: queryItems)).responseDecodable { (response: DataResponse<[VlogReaction]>) in
            switch response.result {
            case .success(let vlogReactions):
                completionHandler(vlogReactions)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler([])
                // failure handling
            }
        }
    }
}
