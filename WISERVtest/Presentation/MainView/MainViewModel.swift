//
//  MainViewModel.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 21.10.2024.
//

import Foundation
import SwiftUI

final class MainViewModel: ObservableObject {

    //Formatter for header date
    let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    //Convert Core Data items for model array
    func getDate(items: FetchedResults<Record>) -> [PressureModel] {
        var result: [PressureModel] = []
        items.forEach { item in
            result.append(PressureModel(id: item.id ?? "",
                                        systolic: Int(item.systolic),
                                        daistolic: Int(item.daistolic),
                                        pulse: Int(item.pulse),
                                        date: item.date ?? Date(),
                                        note: item.note))
        }
        return result
    }
    
    //Prepare date for note
    func prepareDate(items: FetchedResults<Record>) -> String {
        if let date = items.first?.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM HH:mm"
            return "\(formatter.string(from: date))"
        }
        return ""
    }
    
    //Checks for a note
    func isNoteEmpty(items: FetchedResults<Record>) -> Bool {
        guard let note = items.first?.note, !note.isEmpty else { return true }
        return false
    }
    
    //Return note
    func prepareNote(items: FetchedResults<Record>) -> String {
        guard let note = items.first?.note, !note.isEmpty else { return "" }
        return note
    }
    
    //Preparing values ​​for the x-axis of the graph
    func formateDateFromChart(_ hour: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        guard let date = Int(formatter.string(from: hour)) else { return 0 }
        return date
    }
}
