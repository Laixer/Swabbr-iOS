//
//  VlogUserDataRetriever.swift
//  Swabbr
//
//  Created by James Bal on 15-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class VlogUserDataRetriever: IRepository {
    typealias Model = VlogUserModel
    
    static let shared = VlogUserDataRetriever()
    
    private let vlogRepository = VlogRepository.shared
    private let userRepository = UserRepository.shared
    
    func get(refresh: Bool, completionHandler: @escaping ([VlogUserModel]?) -> Void) {
        vlogRepository.get(refresh: refresh, completionHandler: { (vlogModels) -> Void in
            let vlogUserGroup = DispatchGroup()
            var vlogUserModels: [VlogUserModel] = []
            for vlogModel in vlogModels! {
                vlogUserGroup.enter()
                self.userRepository.get(id: vlogModel.ownerId, refresh: refresh, completionHandler: { (userModels) -> Void in
                    vlogUserModels.append(VlogUserModel(user: userModels!, vlog: vlogModel))
                    vlogUserGroup.leave()
                })
            }
            vlogUserGroup.notify(queue: .main) {
                completionHandler(vlogUserModels)
            }
            
        })
    }
    
    func get(id: Int, refresh: Bool, completionHandler: @escaping (VlogUserModel?) -> Void) {
        vlogRepository.get(id: id, refresh: refresh, completionHandler: { (vlogModel) -> Void in
            self.userRepository.get(id: vlogModel!.ownerId, refresh: refresh, completionHandler: { (userModel) -> Void in
                completionHandler(VlogUserModel(user: userModel!, vlog: vlogModel!))
            })
        })
    }
}
