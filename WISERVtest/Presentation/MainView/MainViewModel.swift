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
    
    func getLastData(items: FetchedResults<Record>) -> PressureModel {
        if let item = items.last {
            return PressureModel(id: item.id ?? "",
                                 systolic: Int(item.systolic),
                                 daistolic: Int(item.daistolic),
                                 pulse: Int(item.pulse),
                                 date: item.date ?? Date(),
                                 note: item.note)
        }
        return PressureModel(id: "", systolic: 0, daistolic: 0, pulse: 0, date: Date(), note: "")
    }
    
    func preparePressure(items: FetchedResults<Record>) -> String {
        let pressure = getLastData(items: items)
        return "\(pressure.systolic) / \(pressure.daistolic)"
    }
    
    func preparePulse(items: FetchedResults<Record>) -> String {
        let pressure = getLastData(items: items)
        return "\(pressure.pulse ?? 0)"
    }
    
    func prepareDate(items: FetchedResults<Record>) -> String {
        let pressure = getLastData(items: items)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM HH:mm"
        return "\(formatter.string(from: pressure.date))"
    }
    
    func isNoteEmpty(items: FetchedResults<Record>) -> Bool {
        guard let note = getLastData(items: items).note, !note.isEmpty else { return true }
        return false
    }
    
    func prepareNote(items: FetchedResults<Record>) -> String {
        guard let note = getLastData(items: items).note, !note.isEmpty else { return "" }
        return note
    }
}
