//
//  RecordModel.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 28.10.2024.
//

import Foundation

class RecordModel: ObservableObject {
    @Published var healthData: [PressureModel] = []
}
