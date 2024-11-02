//
//  MainViewModel.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 21.10.2024.
//

import Foundation
import SwiftUI

final class MainViewModel: ObservableObject {

    /// Создается форматтер для Header для приведения даты к  виду  Октября 2024
    /// - Parameter date: дата для конвертации
    /// - Returns: возвращает дату в формате Октября 2024
    func translateMonth(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let result = dateFormatter.string(from: date)
        return result.prefix(1).uppercased() + result.dropFirst()
    }
    
    ///Конвертирует данные, полученные из базы данных в массив элементов PressureModel
    /// - Parameter items: данные из кордаты, полученные в результате FeathRequest
    /// - Returns: возвращает массив элементов PressureModel
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
    
    /// Конвертирует дату для отображения заметки последнего добавленного элемента
    /// - Parameter items: массив сконвертированных данных из CoreData
    /// - Returns: возвращает строку вида 30.10 12:00
    func prepareDate(items: [PressureModel]) -> String {
        if let date = items.first?.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM HH:mm"
            return "\(formatter.string(from: date))"
        }
        return ""
    }
    
    /// Проверяет наличие заметки в новой записи
    /// - Parameter items: массив сконвертированных данных из CoreData
    /// - Returns: true если заметка была добавленна при создании новой записи измерений
    func isNoteEmpty(items: [PressureModel]) -> Bool {
        guard let note = items.first?.note, !note.isEmpty else { return true }
        return false
    }
    
    /// Получение текста заметки
    /// - Parameter items: массив сконвертированных данных из CoreData
    /// - Returns: строку, если заметка была добавлена в записи
    func prepareNote(items: [PressureModel]) -> String {
        guard let note = items.first?.note, !note.isEmpty else { return "" }
        return note
    }
    
    /// Получение часа создания записи давления в формате Int для соотношения с осью Х графика давления
    /// - Parameter hour: дата добавления записи
    /// - Returns: час в формате 24 часов
    func formateDateFromChart(_ hour: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        guard let date = Int(formatter.string(from: hour)) else { return 0 }
        return date
    }
}
