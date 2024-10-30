//
//  CustomTextField.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 30.10.2024.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var note: String
    @FocusState<Bool>.Binding var isFocused: Bool
    var width: CGFloat
    let prompt: String
    
    var body: some View {

            TextField("",
                      text: $note,
                      prompt: Text(prompt)
                .foregroundColor(.textFieldPlaceholder)
            )
            .padding(16)
            .focused($isFocused)
            .frame(width: width)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isFocused ? Color(.mainBlack) : Color(.mainBackground))
            })
            .background(.white)
            .cornerRadius(16)
            .font(.custom(Resource.Font.interRegular, size: 18))
            .keyboardType(.numberPad)
            .onChange(of: note) { newValue in
                note = newValue.filter { $0.isNumber }
            }
        }
    }
