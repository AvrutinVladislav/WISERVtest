//
//  DatePickerWithButton.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 23.10.2024.
//

import SwiftUI

struct DateTimeButton: View {
    

    @Binding var showPicker: Bool
    @Binding var date: Date?
    var prompt: String
    var isDate: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                showPicker = true
            }, label: {
                Text(date == nil ? prompt : convertDateToString(date: date, isDate: isDate))
                    .foregroundStyle(date == nil ? .textFieldPlaceholder : .mainBlack)
                    .padding(16)
                    .frame(width: 159)
                    .multilineTextAlignment(.leading)
                    .font(.custom(Resource.Font.interRegular, size: 18))
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            })
        }
    }
    /// Формотирование даты  в строку
    /// - Parameter date: исходная дата
    /// - Parameter isDate: флаг, показывающий в дату или время необходимо сконвертировать
    /// - Returns: возвращает время или дату в виде строки
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
