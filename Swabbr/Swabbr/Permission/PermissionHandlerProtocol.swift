//
//  PermissionHandlerProtocol.swift
//  Swabbr
//
//  Created by Anonymous on 16-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit

protocol PermissionHandlerProtocol {
    
    // keeping track of permission status throughout
    static var hasPermission: Bool {get set}
    
    // creates an error dialog
    static func createErrorDialog(rootView: UIViewController)
    
}
