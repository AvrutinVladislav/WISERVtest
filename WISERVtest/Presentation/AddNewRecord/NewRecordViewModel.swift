//
//  NewRecordViewModel.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 22.10.2024.
//

import Foundation

class NewRecordViewModel: ObservableObject {
    
    func combineDateAndTime(date: Date?, time: Date?) -> Date {
        guard let date, let time else { return Date() }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: time)
        let fullDate = "\(dateString) \(timeString)"
        guard let result = formatter.date(from: fullDate) else { return Date() }
        return result
    }
    
    func prepareDateToPrompt() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    func prepareTimeToPrompt() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func formateDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
