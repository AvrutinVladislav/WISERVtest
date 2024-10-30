//
//  NewRecordView.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 22.10.2024.
//

import SwiftUI

struct NewRecordView: View {
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    init(allRecords: RecordModel) {
        UITextView.appearance().textContainerInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        UITextView.appearance().tintColor = .black
        self.allRecords = allRecords
    }
    
    @StateObject private var viewModel = NewRecordViewModel()
    @ObservedObject private var allRecords: RecordModel
    
    @State private var systoliticsPressure = ""
    @State private var diastoliticsPressure = ""
    @State private var pulse = ""
    @State private var note = ""
    @State private var date: Date?
    
    @State private var noteHeight: CGFloat = 45
    @State private var showDatePicker = false
    @State private var showTimePicker = false
    
    @FocusState private var isFocusedNote: Bool
    @FocusState private var isFocusedSystolitics: Bool
    @FocusState private var isFocusedDiastolitics: Bool
    @FocusState private var isFocusedPulse: Bool
    
    //MARK: - Body
    var body: some View {
        ZStack {
            GradientView(colors: [.gradientRed],
                         startPoint: .trailing,
                         endPoint: .leading,
                         rotation: Angle(degrees: 180),
                         width: 78,
                         height: 78,
                         blurRadius: 50,
                         xOffset: 42,
                         yOffset: 50)
            GradientView(colors: [.gradientYellow],
                         startPoint: .trailing,
                         endPoint: .leading,
                         rotation: Angle(degrees: 180),
                         width: 138,
                         height: 138,
                         blurRadius: 100,
                         xOffset: 42,
                         yOffset: 50)
            VStack {
                blodPressureAndPulse()
                dateAndTime()
                noteTextEditor()
                Spacer()
                saveButton()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.mainBackground))
            .onAppear {
                viewModel.updateTextEditorHeight(newText: note,
                                                 height: $noteHeight)
            }
        }
    }
    //MARK: - Blood pressure and pulse
    @ViewBuilder private func blodPressureAndPulse() -> some View {
        HStack {
            VStack {
                Text(Resource.Strings.bloodPressure)
                    .font(.custom(Resource.Font.interRegular, size: 16))
                    .foregroundStyle(.mainBlack)
                HStack {
                    VStack {
                        Text(Resource.Strings.systolitics)
                            .font(.custom(Resource.Font.interRegular, size: 12))
                            .foregroundStyle(.lightGrayText)
                            .frame(width: 91)
                        CustomTextField(note: $systoliticsPressure,
                                        isFocused: $isFocusedSystolitics,
                                        width: 103,
                                        prompt: "120")
                    }
                    VStack {
                        Text(Resource.Strings.diastolics)
                            .font(.custom(Resource.Font.interRegular, size: 12))
                            .foregroundStyle(.lightGrayText)
                            .frame(width: 98)
                        CustomTextField(note: $diastoliticsPressure,
                                        isFocused: $isFocusedDiastolitics,
                                        width: 103,
                                        prompt: "90")
                    }
                }
            }
            Spacer()
            VStack {
                Text(Resource.Strings.pulse)
                    .font(.custom(Resource.Font.interRegular, size: 16))
                    .foregroundStyle(.mainBlack)
                Spacer()
                CustomTextField(note: $pulse,
                                isFocused: $isFocusedPulse,
                                width: 103,
                                prompt: "70")
            }
        }
        .frame(height: 89)
        .padding(.init(top: 24, leading: 16, bottom: 0, trailing: 16))
    }
    
    //MARK: - Date and time
    @ViewBuilder private func dateAndTime() -> some View {
        HStack {
            VStack {
                Text(Resource.Strings.date)
                    .font(.custom(Resource.Font.interRegular, size: 16))
                    .foregroundStyle(.mainBlack)
                
                PickerWithButtons(showPicker: $showDatePicker,
                                  date: $date,
                                  prompt: viewModel.prepareDateToPrompt(),
                                  isDate: true)
            }
            
            Spacer(minLength: 24)
            
            VStack {
                Text(Resource.Strings.time)
                    .font(.custom(Resource.Font.interRegular, size: 16))
                    .foregroundStyle(.mainBlack)
                PickerWithButtons(showPicker: $showTimePicker,
                                  date: $date,
                                  prompt: viewModel.prepareTimeToPrompt(),
                                  isDate: false)
            }
        }
        .padding(.init(top: 24, leading: 16, bottom: 24, trailing: 16))
    }
    
    //MARK: - Note
    @ViewBuilder private func noteTextEditor() -> some View {
        VStack {
            HStack {
                Text(Resource.Strings.note)
                    .font(.custom(Resource.Font.interRegular, size: 16))
                Spacer()
            }
            .padding(.horizontal, 16)
            ZStack {
                if note.isEmpty {
                    HStack {
                        Text(Resource.Strings.healthСondition)
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom(Resource.Font.interRegular, size: 18))
                            .foregroundStyle(.textFieldPlaceholder)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal, 16)
                }
                TextEditor( text: $note)
                    .font(.custom(Resource.Font.interRegular, size: 18))
                    .foregroundStyle(.mainBlack)
                    .focused($isFocusedNote)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 45, maxHeight: noteHeight)
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(!isFocusedNote ? Color.clear : Color.mainBlack, lineWidth: 1)
                    }
                    .onChange(of: note) { newValue in
                        viewModel.updateTextEditorHeight(newText: newValue,
                                                         height: $noteHeight)
                    }
                    .background(isFocusedNote || !note.isEmpty ? Color.white : Color.clear)
                    .cornerRadius(14)
                    .padding(16)
            }
            .frame(height: noteHeight)
            .animation(.easeInOut, value: note)
            .background(Color.clear)
            Spacer()
        }
    }
    
    //MARK: - Save Button
    @ViewBuilder private func saveButton() -> some View {
        HStack {
            Button {
                viewModel.saveButtonDidTap(systolic: Int(systoliticsPressure),
                                           diastolic: Int(diastoliticsPressure),
                                           pulse: Int(pulse),
                                           date: date,
                                           note: note,
                                           context: viewContext,
                                           allRecords: _allRecords)
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text(Resource.Strings.save)
                    .font(.custom(Resource.Font.interRegular, size: 18))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(systoliticsPressure.isEmpty || diastoliticsPressure.isEmpty
                                ? .saveNewRecordButton.opacity(0.3)
                                : .saveNewRecordButton)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(systoliticsPressure.isEmpty || diastoliticsPressure.isEmpty)
        }
        .padding(.init(top: 0, leading: 16, bottom: 24, trailing: 16))
    }
    
}

