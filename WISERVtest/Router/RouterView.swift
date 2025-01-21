//
//  RouterView.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 31.10.2024.
//

import SwiftUI

struct RouterView<Content: View>: View {
    
    @StateObject private var router = Router()
    private let content: Content
    
    @inlinable
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: Route.self) {
                    router.view(for: $0, titile: Resource.Strings.addData)
                    /// Этот модификатор ломает свайп назад, исправляем в расширении UINavigationController
                        .navigationBarBackButtonHidden()
                }
        }
        .environmentObject(router)
    }
}
