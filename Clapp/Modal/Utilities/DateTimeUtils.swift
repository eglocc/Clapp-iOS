//
//  DateTimeUtils.swift
//  Clapp
//
//  Created by Ergiz Work on 24/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import Foundation

class DateTimeUtils {
    
    static func formatDate(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
    static func formatTime(time : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: time)
    }
    
}
