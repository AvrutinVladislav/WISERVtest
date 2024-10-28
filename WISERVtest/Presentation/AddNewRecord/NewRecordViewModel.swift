//
//  NewRecordViewModel.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 22.10.2024.
//

import Foundation
import SwiftUI
import CoreData

class NewRecordViewModel: ObservableObject {
    
    //Save data to CoreData
    func saveButtonDidTap(systolic: Int?,
                          diastolic: Int?,
                          pulse: Int?,
                          date: Date?,
                          note: String?,
                          context: NSManagedObjectContext,
                          allRecords: ObservedObject<RecordModel>) {
        let id = UUID().uuidString
        if let systolic, let diastolic {
            
            CoreDataManager.shared.addItem(systolic: Int16(systolic),
                                           diastolic: Int16(diastolic),
                                           pulse: Int16(pulse ?? 0),
                                           date: date == nil ? Date() : date,
                                           note: note,
                                           id: id,
                                           context: context)
            allRecords.wrappedValue.healthData.append(PressureModel(id: id,
                                                                    systolic: Int(systolic),
                                                                    daistolic: Int(diastolic),
                                                                    pulse: Int(pulse ?? 0),
                                                                    date: date ?? Date(),
                                                                    note: note))
        }
    }
    
    //Updates the height of the note input field when entering long text
    func updateTextEditorHeight(newText: String,
                                height: Binding<CGFloat>) {
        let lineHeight: CGFloat = 20
        let newHeight = max(45, CGFloat(newText.split(separator: "\n").count) * lineHeight)
        height.wrappedValue = newHeight > 250 ? 250 : newHeight
    }
    
    //Prepare placeholder for date field
    func prepareDateToPrompt() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    //Prepare placeholder for time field
    func prepareTimeToPrompt() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
