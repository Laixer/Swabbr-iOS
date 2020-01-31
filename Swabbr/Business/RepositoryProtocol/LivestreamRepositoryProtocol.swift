//
//  LivestreamRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 20-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

protocol LivestreamRepositoryProtocol {
    
    /**
     Start a livestream.
     - parameter id: A string value representing the id of the stream.
     - parameter completionHandler: The callback will return an optional String.
    */
    func start(id: String, completionHandler: @escaping (String?) -> Void)
    
    /**
     Stop a livestream.
     - parameter id: A string value representing the id of the stream.
     - parameter completionHandler: The callback will return an optional String.
     */
    func stop(id: String, completionHandler: @escaping (String?) -> Void)
    
    /**
     Publish a livestream.
     - parameter id: A string value representing the id of the stream.
     - parameter completionHandler: The callback will return an optional String.
     */
    func publish(id: String, completionHandler: @escaping (String?) -> Void)
    
}
