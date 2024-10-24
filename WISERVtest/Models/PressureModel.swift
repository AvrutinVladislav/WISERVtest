//
//  PressureModel.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 22.10.2024.
//

import Foundation

struct PressureModel: Identifiable {
    let id: String
    let systolic: Int
    let daistolic: Int
    let pulse: Int?
    let date: Date
    let note: String?
}
