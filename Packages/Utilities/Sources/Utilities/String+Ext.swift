//
//  File.swift
//  Utilities
//
//  Created by George Magdy on 19/08/2025.
//

import Foundation

public extension String {
    var year: String {
        if let year = formattedDateComponent(.year) {
            return "\(year)"
        }else {
            return ""
        }
    }
    
    var monthNum: String {
        if let month = formattedDateComponent(.month) {
            return "\(month)"
        }else {
            return ""
        }
    }
    
    var month: String {
        guard let date = formattedDate() else { return "" }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "LLL" // "LLL" gives abbreviated month like "Jan"

        return formatter.string(from: date)
    }
    
    private func formattedDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)
    }

    private func formattedDateComponent(_ component: Calendar.Component) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: self) else { return nil }
        return Calendar.current.component(component, from: date)
    }
}
