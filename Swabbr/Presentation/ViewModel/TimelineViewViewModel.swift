//
//  VlogViewViewModel.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class TimelineViewViewModel {
    
    weak var delegate: TimelineViewViewModelDelegate?
    
    let vlogUserDataRetriever = VlogUserDataRetriever.shared
    var vlogs: [VlogUserRepositoryModel]! = [] {
        didSet {
            delegate?.didRetrieveVlogs(self)
        }
    }
    
    func getVlogs() {
        vlogUserDataRetriever.get(refresh: false, completionHandler: { (vlogUserModels) -> Void in
            self.vlogs = vlogUserModels!.compactMap({ (vlogUserModel) -> VlogUserRepositoryModel in
                VlogUserRepositoryModel.mapToPresentation(vlogUserModel: vlogUserModel)
            })
        })
    }
    
}

protocol TimelineViewViewModelDelegate: class {
    func didRetrieveVlogs(_ sender: TimelineViewViewModel)
}
