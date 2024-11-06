//
//  DateTimeSheetView.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 02.11.2024.
//

import SwiftUI

struct DateTimeSheetView: View {
    
    @Binding var date: Date?
    @Binding var showPicker: Bool
    @State var selectedDate: Date = Date()
    var isDate: Bool
    
    var body: some View {
        VStack {
            picker(isDate: isDate)
                .padding(16)
            
            HStack {
                Spacer()
                Button(action: {
                    showPicker = false
                }, label: {
                    Text("Cancel")
                        .font(.custom(Resource.Font.interRegular, size: 14))
                        .foregroundStyle(.lightGrayText)
                        .padding(.trailing, 34)
                })
                
                Button(action: {
                    date = selectedDate
                    showPicker = false
                }, label: {
                    Text("OK".uppercased())
                        .font(.custom(Resource.Font.interMedium, size: 14))
                        .foregroundStyle(.saveNewRecordButton)
                        .padding(.trailing, 34)
                })
            }
            .padding(.bottom, 22)
        }
        .frame(width: 348)
        .background(Color.white)
        .cornerRadius(28)
        .shadow(radius: 10)
        .padding()
    }
    
    /// Создание пикера времени и даты
    /// - Parameter isDate: флаг, показывающий пикер даты или времени стоит вывести
    /// - Returns: возвращает пикер
    @ViewBuilder private func picker(isDate: Bool) -> some View {
        if isDate {
            DatePicker(
                "",
                selection: $selectedDate,
                in: Date()...,
                displayedComponents: isDate ? .date : .hourAndMinute
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
        }
        else {
            DatePicker(
                "",
                selection: $selectedDate,
                in: Date()...,
                displayedComponents: isDate ? .date : .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
        }
    }
}
