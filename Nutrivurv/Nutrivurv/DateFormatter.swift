//
//  DateFormatter.swift
//  Nutrivurv
//
//  Created by Dillon on 7/28/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

extension Date {
    public func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        
        return dateFormatter.string(from: self)
    }
    
    public func localToUTC(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddTh:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-ddTH:mm:ss"

        return dateFormatter.string(from: dt!)
    }

    public func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddTH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-ddTh:mm a"

        return dateFormatter.string(from: dt!)
    }
}
