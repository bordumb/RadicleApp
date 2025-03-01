//
//  DateUtils.swift
//  RadicleApp
//
//  Created by bordumb on 27/02/2025.
//

import Foundation

struct DateUtils {
    /// Returns the number of days between the given date and today
    static func daysAgo(from timestamp: Int) -> Int {
        let calendar = Calendar.current
        let now = Date()
        
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        guard date <= now else { return 0 } // If it's in the future, return 0
        
        let components = calendar.dateComponents([.day], from: date, to: now)
        return components.day ?? 0
    }
    
    static func formatDate(_ timestamp: Int) -> String {
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy HH:mm"
            return formatter.string(from: date)
    }
}



