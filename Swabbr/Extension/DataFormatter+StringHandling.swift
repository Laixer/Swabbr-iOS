//
//  DataFormatter+StringHandling.swift
//  Swabbr
//
//  Created by James Bal on 18-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    /**
     This function is almost the same as the date(from: "stringdate") function but this will set the
     timezone if it is required for a particular value.
     - parameter format: A string value which represents the value of the incoming date string.
     - parameter value: A string value which represents the actual date string.
     - Returns: A nullable date.
    */
    func stringToBaseDate(format: String, value: String) -> Date? {
        self.dateFormat = format
        self.timeZone = TimeZone(abbreviation: "UTC")
        return self.date(from: value)
    }
    
}
