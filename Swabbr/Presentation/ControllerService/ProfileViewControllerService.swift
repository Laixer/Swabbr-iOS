//
//  ProfileViewControllerService.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class ProfileViewControllerService {
    
    weak var delegate: ProfileViewControllerServiceDelegate?
    
    let userUseCase = UserUseCase.shared
    let vlogUseCase = VlogUseCase.shared
    
    var user: UserItem! {
        didSet {
            delegate?.didRetrieveUser(self)
        }
    }
    var vlogs: [VlogItem]! = [] {
        didSet {
            delegate?.didRetrieveVlogs(self)
        }
    }
    
    /**
     Get certain user. Runs a callback when ready.
     - parameter userId: A user id.
    */
    func getUser(userId: Int) {
        userUseCase.get(id: userId, refresh: false) { (userModel) in
            self.user = UserItem.mapToPresentation(model: userModel!)
        }
    }
    
    /**
     Get vlogs from a specific user. Runs a callback when ready.
    */
    func getVlogs() {
        vlogUseCase.get(id: user.id, refresh: false, multiple: { (vlogModels) -> Void in
            self.vlogs = vlogModels?.compactMap({ (vlogModel) -> VlogItem in
                VlogItem.mapToPresentation(vlogModel: vlogModel)
            })
        })
    }
    
}

protocol ProfileViewControllerServiceDelegate: class {
    func didRetrieveUser(_ sender: ProfileViewControllerService)
    func didRetrieveVlogs(_ sender: ProfileViewControllerService)
}
