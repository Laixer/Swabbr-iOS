//
//  PermissionHandlerProtocol.swift
//  Swabbr
//
//  Created by Anonymous on 16-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

protocol PermissionHandlerProtocol {
    
    // keeping track of permission status throughout
    static var hasPermission: Bool {get set}
    
}
