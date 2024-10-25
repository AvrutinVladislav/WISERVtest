//
//  CoreDataManager.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 21.10.2024.
//

import SwiftUI
import CoreData

public final class CoreDataManager {
        
    static let shared = CoreDataManager()
    
    init() {}
    
    func addItem(systolic: Int16, diastolic: Int16, pulse: Int16, date: Date?, note: String?, context: NSManagedObjectContext) {
        let context = context
        let newItem = Record(context: context)
        newItem.date = date
        newItem.id = UUID().uuidString
        newItem.systolic = systolic
        newItem.daistolic = diastolic
        newItem.pulse = pulse
        newItem.note = note
        do {
            try context.save()
            print("Record did saved")
        } catch {
            print("Ошибка сохранения записи: \(error.localizedDescription)")
        }
    }
    
}

enum CoreDataError: Error {
    case update
    case create
    
    var errorDescription: String {
        switch self {
        case .update:
            return "Ошибка при обновлении"
        case .create:
            return "Ошибка сохранения записи"
        }
    }
}

