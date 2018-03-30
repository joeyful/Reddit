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
        
        let seconds = "\(difference.second ?? 0) seconds"
        let minutes = "\(difference.minute ?? 0) minutes"
        let hours = "\(difference.hour ?? 0) hours"
        let days = "\(difference.day ?? 0) days"
        
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
    
}
