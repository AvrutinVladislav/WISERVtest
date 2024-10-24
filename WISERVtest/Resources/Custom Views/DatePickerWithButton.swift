//
//  DatePickerWithButton.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 23.10.2024.
//

import SwiftUI

struct PickerWithButtons: View {
    
    @Binding var showPicker: Bool
    @Binding var date: Date?
    var prompt: String
    var isDate: Bool
    @State var selectedDate: Date = Date()
    
    var body: some View {
        VStack {
            Button(action: {
                showPicker = true
            }, label: {
                Text($date.wrappedValue == nil ? prompt : convertDateToString(date: date, isDate: isDate))
                    .foregroundStyle($date.wrappedValue == nil ? .textFieldPlaceholder : .mainBlack)
                    .padding(16)
                    .frame(width: 159)
                    .multilineTextAlignment(.leading)
            })
            .sheet(isPresented: $showPicker) {
                VStack {
                    picker(isDate: isDate)
                    
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
                }
            }
        }
    }
    
    @ViewBuilder private func picker(isDate: Bool) -> some View {
        if isDate {
            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: isDate ? .date : .hourAndMinute
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
        }
        else {
            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: isDate ? .date : .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
        }
    }
    
    func convertDateToString(date: Date?, isDate: Bool) -> String {
        guard let date else { return ""}
        let formatter = DateFormatter()
        if isDate {
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.string(from: date)
        }
        else {
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    }
}
