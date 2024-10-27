//
//  MainViewModel.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 21.10.2024.
//

import Foundation
import SwiftUI

final class MainViewModel: ObservableObject {
    
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
    
    func prepareDate(items: FetchedResults<Record>) -> String {
        if let date = items.first?.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM HH:mm"
            return "\(formatter.string(from: date))"
        }
        return ""
    }
    
    func isNoteEmpty(items: FetchedResults<Record>) -> Bool {
        guard let note = items.first?.note, !note.isEmpty else { return true }
        return false
    }
    
    func prepareNote(items: FetchedResults<Record>) -> String {
        guard let note = items.first?.note, !note.isEmpty else { return "" }
        return note
    }
}
