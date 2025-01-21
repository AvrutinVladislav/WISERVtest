//
//  RootView.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 31.10.2024.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var manager: DataManager
    
    var body: some View {
        RouterView {
            MainView(manager: _manager)
               }
    }
}
