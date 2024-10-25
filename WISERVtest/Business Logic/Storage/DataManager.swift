//
//  DataManager.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 25.10.2024.
//

import Foundation
import CoreData

class DataManager: NSObject, ObservableObject {
    @Published var records: [Record] = [Record]()
    let container: NSPersistentContainer = NSPersistentContainer(name: "WISERVtest")
    override init() {
        super.init()
        container.loadPersistentStores { _, error in
        }
    }
}
