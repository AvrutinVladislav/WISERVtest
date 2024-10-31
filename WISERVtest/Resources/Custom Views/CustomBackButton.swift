//
//  CustomBackButton.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 22.10.2024.
//

import SwiftUI

struct CustomNavBar: ViewModifier {
    
    @EnvironmentObject private var router: Router
    var title: String?

    func body(content: Content) -> some View {
        content
            .navigationTitle(title ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .font(.custom(Resource.Font.interMedium, size: 18))
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        router.pop()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .padding(.init(top: 5, leading: 8, bottom: 5, trailing: 9))
                                .foregroundStyle(.mainBlack)
                        }
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
    }
}

extension View {
    func customNavBar(title: String) -> some View {
        modifier(CustomNavBar(title: title))
    }
}
