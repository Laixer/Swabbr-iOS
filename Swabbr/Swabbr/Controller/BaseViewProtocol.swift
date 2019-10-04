//
//  File.swift
//  Swabbr
//
//  Created by James Bal on 04-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

protocol BaseViewProtocol {
    
    /**
     Initialize all UI elements that will appear on the screen with the correct values and setup.
     */
    func initElements()
    
    /**
     Apply all constraints to show the initialized elements correctly on the screen.
     */
    func applyConstraints()
    
}
