//
//  RecordModel.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 28.10.2024.
//

import Foundation

class RecordModel: ObservableObject {
    @Published var healthData: [PressureModel] = []
    private let id = UUID()
}

///Реализуем Equitable для реализации Hashable
extension RecordModel: Hashable {
    static func == (lhs: RecordModel, rhs: RecordModel) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
