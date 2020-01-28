//
//  VlogPageViewControllerService.swift
//  Swabbr
//
//  Created by James Bal on 18-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class VlogPageViewControllerService {
    
    weak var delegate: VlogPageViewControllerServiceDelegate?
    
    private let vlogUseCase = VlogUseCase()
    private let userUseCase = UserUseCase()
    
    public private(set) var vlog: VlogUserItem! {
        didSet {
            delegate?.didRetrieveVlog(self)
        }
    }
    
    /**
     Getting a specific vlog. Will run a callback on completion.
     - parameter vlogId: A vlog id
    */
    func getVlog(vlogId: String) {
        vlogUseCase.get(id: vlogId, refresh: false, completionHandler: { (vlogModel) -> Void in
            guard let vlogModel = vlogModel else {
                return
            }
            self.userUseCase.get(id: vlogModel.ownerId, refresh: false, completionHandler: { (userModel) -> Void in
                self.vlog = VlogUserItem(vlogModel: vlogModel, userModel: userModel!)
            })
        })
    }
    
    /**
     Give a vlog a like (love it).
     - parameter vlogId: A vlog id.
    */
    func giveLoveIt(for vlogId: String, completionHandler: @escaping (String?) -> Void) {
        vlogUseCase.createLike(id: vlogId) { (errorString) in
            completionHandler(errorString)
        }
    }
    
}

protocol VlogPageViewControllerServiceDelegate: class {
    func didRetrieveVlog(_ sender: VlogPageViewControllerService)
}
