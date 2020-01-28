//
//  LivestreamRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 20-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

protocol LivestreamRepositoryProtocol {
    
    func start(id: String, completionHandler: @escaping (String?) -> Void)
    
    func stop(id: String, completionHandler: @escaping (String?) -> Void)
    
}
