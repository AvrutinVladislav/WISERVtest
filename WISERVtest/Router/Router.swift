//
//  Router.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 31.10.2024.
//

import SwiftUI

@MainActor
final class Router: ObservableObject {
    
    @Published var path = NavigationPath()
    
    @inlinable
    @inline(__always)
    func push(_ appRoute: Route) {
        path.append(appRoute)
    }
    
    @inlinable
    @inline(__always)
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    @inlinable
    @inline(__always)
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func view(for route: Route, titile: String) -> some View {
        switch route {
        case .goToNewRecordView(let record):
            NewRecordView(allRecords: record)
                .customNavBar(title: titile)
        }
    }
    
}
