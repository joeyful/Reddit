//
//  Date+Offset.swift
//  Reddit
//
//  Created by Joey Wei on 3/29/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation

extension Date {
    
    func offsetFrom(_ date: Date) -> String {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self);
        
        let seconds = "number_of_seconds".pluralize(value: difference.second ?? 0)
        let minutes = "number_of_minutes".pluralize(value: difference.minute ?? 0)
        let hours = "number_of_hours".pluralize(value: difference.hour ?? 0)
        let days = "number_of_days".pluralize(value: difference.day ?? 0)
        
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
    
}
