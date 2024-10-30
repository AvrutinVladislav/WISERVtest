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
    
    /// Сохранение даты в CoreData и в массив записей
    /// - Parameter systolic: систолическое давление
    /// - Parameter diastolic: диастолическое давление
    /// - Parameter pulse: пульс
    /// - Parameter date: дата проведения замера и добавления
    /// - Parameter note: заметка
    /// - Parameter context: контекст для работы CoreData
    /// - Parameter allRecords: локальный массив записей
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
    
    /// Обновление высоты поля ввода заметки при длинном тексте
    /// - Parameter newText: вводимый текст
    /// - Parameter height: высота поля ввода
    func updateTextEditorHeight(newText: String,
                                height: Binding<CGFloat>) {
        let lineHeight: CGFloat = 20
        let newHeight = max(45, CGFloat(newText.split(separator: "\n").count) * lineHeight)
        height.wrappedValue = newHeight > 250 ? 250 : newHeight
    }
    
    /// Подготовка  подсказки в поле ввода даты замера
    /// - Returns: возвращает строку вида 30.10.2024
    func prepareDateToPrompt() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    /// Подготовка подсказки для поля ввода времмени замера
    /// - Returns: возвращает строку вида 12:00
    func prepareTimeToPrompt() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
