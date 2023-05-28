//
//  Date.swift
//  Timering
//
//  Created by Yuto on 2023/03/03.
//

import Foundation

extension Date {
    func toString (
        dateFormat: DateFormatter.Style = .short,
        timeFormat: DateFormatter.Style = .none
    ) -> String {
        var formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = dateFormat
            formatter.timeStyle = timeFormat
            return formatter
        }()

        return formatter.string(from: self)
    }
}
