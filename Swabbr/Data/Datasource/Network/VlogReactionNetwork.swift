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
        AF.request(buildUrl(path: id)).responseDecodable { (response: DataResponse<VlogReaction>) in
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
        AF.request(buildUrl(path: "vlogs/\(id)")).responseDecodable { (response: DataResponse<[VlogReaction]>) in
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
    
    func createReaction(vlogReaction: CreatedVlogReaction, completionHandler: @escaping (String?) -> Void) {
        var request = buildUrl(path: "create")
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(vlogReaction)
        AF.request(request).response { (response) in
            switch response.result {
            case .success:
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error.localizedDescription)
                // failure handling
            }
        }
    }
}
