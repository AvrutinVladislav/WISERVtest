//
//  NewRecordView.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 22.10.2024.
//

import SwiftUI

struct NewRecordView: View {
    
    init() {
        UITextView.appearance().textContainerInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        UITextView.appearance().tintColor = .black
    }
    @StateObject private var viewModel = NewRecordViewModel()
    
    @State private var systoliticsPressure = ""
    @State private var diastoliticsPressure = ""
    @State private var pulse = ""
    @State private var note = ""
    @State private var noteHeight: CGFloat = 45
    @State private var selectedDate: Date?
    @State private var selectedTime: Date?
    @State private var showDatePicker = false
    @State private var showTimePicker = false
    
    @FocusState private var isFocusedNote: Bool
    @FocusState private var isFocusedSystolitics: Bool
    @FocusState private var isFocusedDiastolitics: Bool
    @FocusState private var isFocusedPulse: Bool
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
    
    
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
                blodPressureAndPulse(systoliticsPressure: $systoliticsPressure,
                                     isFocusedSystolitics: $isFocusedSystolitics,
                                     diastoliticsPressure: $diastoliticsPressure,
                                     isFocusedDiastolitics: $isFocusedDiastolitics,
                                     pulse: $pulse,
                                     isFocusedPulse: $isFocusedPulse)
                
                dateAndTime(showDatePicker: $showDatePicker,
                            showTimePicker: $showTimePicker,
                            viewModel: viewModel,
                            selectedDate: $selectedDate,
                            selectedTime: $selectedTime)
                
                noteTextEditor(note: $note,
                               isFocusedTextEditor: $isFocusedNote,
                               textEditorHeight: noteHeight,
                               updateTextEditorHeight: updateTextEditorHeight)
                
                Spacer()
                
                saveButton(systoliticsPressure: $systoliticsPressure,
                           diastoliticsPressure: $diastoliticsPressure,
                           saveToCoreData: saveButtonDidTap)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.mainBackground))
        .onAppear {
            updateTextEditorHeight(note)
            
        }
    }
}

//MARK: - Blood pressure and pulse
@ViewBuilder private func blodPressureAndPulse(systoliticsPressure: Binding<String>,
                                               isFocusedSystolitics: FocusState<Bool>.Binding,
                                               diastoliticsPressure: Binding<String>,
                                               isFocusedDiastolitics: FocusState<Bool>.Binding,
                                               pulse: Binding<String>,
                                               isFocusedPulse: FocusState<Bool>.Binding) -> some View {
    HStack {
        VStack {
            Text(Resource.Strings.bloodPressure)
            HStack {
                VStack {
                    Text(Resource.Strings.systolitics)
                        .font(.custom(Resource.Font.interRegular, size: 12))
                        .foregroundStyle(.lightGrayText)
                        .frame(width: 91)
                    customTextField(text: systoliticsPressure,
                                    prompt: "120",
                                    width: 103,
                                    isFocused: isFocusedSystolitics)
                }
                VStack {
                    Text(Resource.Strings.diastolics)
                        .font(.custom(Resource.Font.interRegular, size: 12))
                        .foregroundStyle(.lightGrayText)
                        .frame(width: 98)
                    customTextField(text: diastoliticsPressure,
                                    prompt: "90",
                                    width: 103,
                                    isFocused: isFocusedDiastolitics)
                }
            }
        }
        Spacer()
        VStack {
            Text(Resource.Strings.pulse)
            Spacer()
            customTextField(text: pulse,
                            prompt: "70",
                            width: 103,
                            isFocused: isFocusedPulse)
        }
    }
    .frame(height: 89)
    .padding(.init(top: 24, leading: 16, bottom: 0, trailing: 16))
}

//MARK: - Date and time
@ViewBuilder private func dateAndTime(showDatePicker: Binding<Bool>,
                                      showTimePicker: Binding<Bool>,
                                      viewModel: NewRecordViewModel,
                                      selectedDate: Binding<Date?>,
                                      selectedTime: Binding<Date?>
) -> some View {
    HStack {
        VStack {
            Text(Resource.Strings.date)
                .font(.custom(Resource.Font.interRegular, size: 16))

            PickerWithButtons(showPicker: showDatePicker,
                              date: selectedDate,
                              prompt: viewModel.prepareDateToPrompt(),
                              isDate: true)
        }
        
        Spacer(minLength: 24)
        
        VStack {
            Text(Resource.Strings.time)
                .font(.custom(Resource.Font.interRegular, size: 16))
            PickerWithButtons(showPicker: showTimePicker,
                              date: selectedTime,
                              prompt: viewModel.prepareTimeToPrompt(),
                              isDate: false)
        }
    }
    .padding(.init(top: 24, leading: 16, bottom: 24, trailing: 16))
}

//MARK: - Note
@ViewBuilder private func noteTextEditor(note: Binding<String>,
                                         isFocusedTextEditor: FocusState<Bool>.Binding,
                                         textEditorHeight: CGFloat,
                                         updateTextEditorHeight: @escaping (String) -> Void
) -> some View {
    VStack {
        HStack {
            Text(Resource.Strings.note)
                .font(.custom(Resource.Font.interRegular, size: 16))
            Spacer()
        }
        .padding(.horizontal, 16)
        VStack {
            TextEditor(text: note)
                .focused(isFocusedTextEditor)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 45, maxHeight: textEditorHeight)
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(!isFocusedTextEditor.wrappedValue ? Color.clear : Color.mainBlack, lineWidth: 1)
                }
                .onChange(of: note.wrappedValue) { newValue in
                    updateTextEditorHeight(newValue)
                }
                .background(isFocusedTextEditor.wrappedValue || !note.wrappedValue.isEmpty ? Color.white : Color.clear)
                .cornerRadius(14)
                .padding(16)
        }
        .frame(height: textEditorHeight)
        .animation(.easeInOut, value: note.wrappedValue)
        .background(Color.clear)
        Spacer()
    }
}

//MARK: - Save Button
@ViewBuilder private func saveButton(systoliticsPressure: Binding<String>,
                                     diastoliticsPressure: Binding<String>,
                                     saveToCoreData: @escaping () -> Void) -> some View {
    HStack {
        Button {
            saveToCoreData()
        } label: {
            Text(Resource.Strings.save)
                .font(.custom(Resource.Font.interRegular, size: 18))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(systoliticsPressure.wrappedValue.isEmpty
                            || diastoliticsPressure.wrappedValue.isEmpty ? .saveNewRecordButton.opacity(0.3)
                                                            : .saveNewRecordButton)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(systoliticsPressure.wrappedValue.isEmpty || diastoliticsPressure.wrappedValue.isEmpty)
    }
    .padding(.init(top: 0, leading: 16, bottom: 24, trailing: 16))
}

//MARK: - Custom TF
@ViewBuilder private func customTextField(text: Binding<String>,
                                          prompt: String,
                                          width: CGFloat,
                                          isFocused: FocusState<Bool>.Binding) -> some View {
    TextField("",
              text: text,
              prompt: Text(prompt)
                .foregroundColor(.textFieldPlaceholder)
    )
        .padding(16)
        .focused(isFocused)
        .frame(width: width)
        .overlay(content: {
            RoundedRectangle(cornerRadius: 16)
                .stroke(isFocused.wrappedValue ? Color(.mainBlack) : Color(.mainBackground))
        })
        .background(.white)
        .cornerRadius(16)
        .font(.custom(Resource.Font.interRegular, size: 18))
        .keyboardType(.numberPad)
}

//MARK: - Extension
extension NewRecordView {
    func updateTextEditorHeight(_ newText: String) {
        let lineHeight: CGFloat = 20
        let newHeight = max(45, CGFloat(newText.split(separator: "\n").count) * lineHeight)
        $noteHeight.wrappedValue = newHeight > 250 ? 250 : newHeight
    }
    
    func saveButtonDidTap() {
        
    }
}

#Preview {
    NewRecordView()
}
