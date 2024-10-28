//
//  PressureModel.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 22.10.2024.
//

import Foundation

struct PressureModel: Identifiable {
    let id: String
    var systolic: Int
    var daistolic: Int
    var pulse: Int?
    var date: Date
    var note: String?
    
    var hours: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter.string(from: date)
    }
}
