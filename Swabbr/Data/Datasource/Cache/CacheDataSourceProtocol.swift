//
//  CacheDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 02-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import CodableCache

protocol CacheDataSourceProtocol: DataSourceProtocol {
    func set(object: Entity?)
    func set(objects: [Entity]?)
}
