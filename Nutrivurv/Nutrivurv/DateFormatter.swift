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
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
}
