//
//  SearchViewControllerService.swift
//  Swabbr
//
//  Created by James Bal on 02-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class SearchViewControllerService {
    
    weak var delegate: SearchViewControllerServiceDelegate?
    
    private let userUseCase = UserUseCase.shared
    private let vlogUseCase = VlogUseCase.shared
    
    public private(set) var vlogs: [VlogItem]! = [] {
        didSet {
            delegate?.foundVlogs(self)
        }
    }
    
    func findUsersVlogs(term: String) {
        let dispatchGroup = DispatchGroup()
        userUseCase.get(term: term, refresh: true, completionHandler: {(userModels) -> Void in
            var innerVlogs: [VlogItem] = []
            
            for userModel in userModels {
                dispatchGroup.enter()
                self.vlogUseCase.get(id: userModel.id, refresh: false, multiple: {(vlogModels) -> Void in
                    innerVlogs += vlogModels.compactMap({ (vlogModel) -> VlogItem in
                        VlogItem.mapToPresentation(vlogModel: vlogModel)
                    })
                    dispatchGroup.leave()
                })
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                self.vlogs = innerVlogs
            })
        })
    }
    
    func getVlogs() {
        vlogUseCase.get(refresh: true, completionHandler: {(vlogModels) -> Void in
            self.vlogs = vlogModels.compactMap({ (vlogModel) -> VlogItem in
                VlogItem.mapToPresentation(vlogModel: vlogModel)
            })
        })
    }

}

protocol SearchViewControllerServiceDelegate: class {
    func foundVlogs(_ sender: SearchViewControllerService)
}
