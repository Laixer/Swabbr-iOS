//
//  CacheDataSourceAllProtocol.swift
//  Swabbr
//
//  Created by James Bal on 13-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

protocol CacheDataSourceAllProtocol: CacheDataSourceProtocol {
    func getAll(completionHandler: @escaping ([Entity]) -> Void) throws
    func setAll(objects: [Entity])
}
