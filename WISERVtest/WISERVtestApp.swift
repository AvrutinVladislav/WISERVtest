//
//  WISERVtestApp.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 21.10.2024.
//

import SwiftUI

@main
struct WISERVtestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
