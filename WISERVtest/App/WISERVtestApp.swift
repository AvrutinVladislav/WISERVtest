//
//  WISERVtestApp.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 21.10.2024.
//

import SwiftUI

@main
struct WISERVtestApp: App {
    @StateObject private var manager: DataManager = DataManager()
    @StateObject private var router: Router = Router()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, manager.container.viewContext)
        }
    }
}
