//
//  VlogStreamViewControllerService.swift
//  Swabbr
//
//  Created by James Bal on 20-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

class VlogStreamViewControllerService {
    
    weak var delegate: VlogStreamViewControllerServiceDelegate?
    
    private let livestreamUseCase = LivestreamUseCase()
    
    /**
     Starting the stream.
     - parameter id: The id of the stream that needs to be started.
     */
    func startLive(id: String) {
        livestreamUseCase.start(id: id) { (errorString) in
            self.delegate?.tryStartingStream(errorString: errorString)
        }
    }
    
    /**
     Stopping the stream.
     - parameter id: The id of the stream that needs to be stopped.
     */
    func endLive(id: String) {
        livestreamUseCase.stop(id: id) { (errorString) in
            self.delegate?.tryEndingStream(errorString: errorString)
        }
    }
    
}

protocol VlogStreamViewControllerServiceDelegate: class {
    
    /**
     Starting the stream.
     - parameter errorString: An optional String value representing the Error.
    */
    func tryStartingStream(errorString: String?)
    
    /**
     Stopping the stream.
     - parameter errorString: An optional String value representing the Error.
     */
    func tryEndingStream(errorString: String?)
    
}
