//
//  Date.swift
//  Twitter
//
//  Created by Ali Mir on 9/28/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

extension Date {
    var timeAgo: String {
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: self, to: now, options: [])
        
        if let year = components.year, year >= 1 {
            return "\(year)y"
        }
        
        if let month = components.month, month >= 1 {
            return "\(month)mo"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "\(week)w"
        }
        
        if let day = components.day, day >= 1 {
            return "\(day)d"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "\(hour)h"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "\(minute)m"
        }
        
        if let second = components.second, second >= 1 {
            return "\(second)s"
        }
        
        return "0s"
    }
    
}

