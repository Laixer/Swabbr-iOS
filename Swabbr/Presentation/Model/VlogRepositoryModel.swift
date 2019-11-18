//
//  VlogRepositoryModel.swift
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

struct VlogRepositoryModel {
    
    var vlogName: String
    
    init(vlogModel: VlogModel) {
        vlogName = vlogModel.duration
    }
    
}

extension VlogRepositoryModel {
    static func mapToPresentation(vlogModel: VlogModel) -> VlogRepositoryModel {
        return VlogRepositoryModel(vlogModel: vlogModel)
    }
}
