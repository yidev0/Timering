//
//  DebugData.swift
//  Timering
//
//  Created by Yuto on 2023/02/28.
//

import Foundation

#if DEBUG
class DebugData {
    
}

extension Date {
    static let today = Foundation.Date()
    
    static let start = Calendar.current.startOfDay(for: Foundation.Date())
    
    static let yesterday = {
        return Calendar.current.date(
            byAdding: .day,
            value: -1,
            to: Foundation.Date() ?? Date()
        )
    }
    
    static let newYear = {
        let calendar = Calendar.current
        let component = DateComponents(
            calendar: calendar,
            year: Calendar.current.component(.year, from: Foundation.Date()),
            month: 1,
            day: 1,
            hour: 0,
            minute: 0,
            second: 0
        )
        return calendar.date(from: component) ?? Date()
    }
    
    static let nextNewYear = {
        let calendar = Calendar.current
        let component = DateComponents(
            calendar: calendar,
            year: Calendar.current.component(.year, from: Foundation.Date()) + 1,
            month: 1,
            day: 1,
            hour: 0,
            minute: 0,
            second: 0
        )
        return calendar.date(from: component) ?? Date()
    }
    
    static let iPhone = {
        let calendar = Calendar.current
        let component = DateComponents(
            calendar: calendar,
            year: 2007,
            month: 1,
            day: 9,
            hour: 9,
            minute: 41,
            second: 0
        )
        return calendar.date(from: component) ?? Date()
    }
}
#endif
