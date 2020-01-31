//
//  VlogPreviewViewControllerService.swift
//  Swabbr
//
//  Created by James Bal on 29-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

class VlogPreviewViewControllerService {
    
    weak var delegate: VlogPreviewViewControllerServiceDelegate?
    
    private let livestreamUseCase = LivestreamUseCase()
    private let vlogReactionUseCase = VlogReactionUseCase()
    
    func publishStream(id: String) {
        livestreamUseCase.publish(id: id) { (errorString) in
            self.delegate?.saveVlog(errorString: errorString)
        }
    }
    
    func createReaction(createdVlogReactionItem: CreatedVlogReactionItem) {
        vlogReactionUseCase.createReaction(vlogReaction: createdVlogReactionItem.mapToBusiness()) { (errorString) in
            self.delegate?.saveVlog(errorString: errorString)
        }
    }
    
}

protocol VlogPreviewViewControllerServiceDelegate: class {
    
    func saveVlog(errorString: String?)
    
}
