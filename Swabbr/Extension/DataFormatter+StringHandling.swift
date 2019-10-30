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
     timezone correctly and ensure that the date is UTC.
     - parameter format: A string value which represents the value of the incoming date string.
     - parameter value: A string value which represents the actual date string.
     - Returns: A nullable date.
    */
    func stringToBaseDate(format: String, value: String) -> Date? {
        self.dateFormat = format
        self.locale = Locale(identifier: "en_US_POSIX")
        self.timeZone = TimeZone(abbreviation: "UTC")
        return self.date(from: value)
    }
    
    /**
     This will convert the given date to a readable date, this date has a format according to the
     users locale settings.
     - parameter date: A date value which will be converted.
     - Returns: A string representation of the given date in the correct format and time according to timezone.
    */
    func displayDateAsString(date: Date, localeId: String = Locale.current.identifier, timeZoneId: String = TimeZone.current.identifier) -> String {
        self.timeZone = TimeZone.init(identifier: timeZoneId)
        self.locale = Locale(identifier: localeId)
        self.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd HH:mm", options: 0, locale: locale)
        var daylightTimeSeconds: TimeInterval {
            if self.timeZone.isDaylightSavingTime() {
                return self.timeZone.daylightSavingTimeOffset()
            }
            return 0
        }
        return self.string(from: date + daylightTimeSeconds)
        
    }
    
}
