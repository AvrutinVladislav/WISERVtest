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
    
    @State private var systoliticsPressure = "222"
    @State private var diastoliticsPressure = "111"
    @State private var pulse = ""
    @State private var date = ""
    @State private var time = ""
    @State private var note = ""
    @State private var textEditorHeight: CGFloat = 45
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: Date = Date()
    @State private var showDatePicker = false
    @State private var showTimePicker = false
    
    @FocusState private var isFocusedTextEditor: Bool
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
        VStack {
            HStack {
                VStack {
                    Text(Resource.Strings.bloodPressure)
                    HStack {
                        VStack {
                            Text(Resource.Strings.systolitics)
                                .font(.custom(Resource.Font.interRegular, size: 12))
                                .foregroundStyle(.lightGrayText)
                                .frame(width: 91)
                            customTextField($systoliticsPressure, "120", 103, $isFocusedSystolitics)
                        }
                        VStack {
                            Text(Resource.Strings.diastolics)
                                .font(.custom(Resource.Font.interRegular, size: 12))
                                .foregroundStyle(.lightGrayText)
                                .frame(width: 98)
                            customTextField($diastoliticsPressure, "90", 103, $isFocusedDiastolitics)
                        }
                    }
                }
                Spacer()
                VStack {
                    Text(Resource.Strings.pulse)
                    Spacer()
                    customTextField($pulse, "70", 103, $isFocusedPulse)
                }
            }
            .frame(height: 89)
            .padding(.init(top: 24, leading: 16, bottom: 0, trailing: 16))
            
            HStack {
                
                //MARK: - Date
                VStack {
                    Text(Resource.Strings.date)
                        .font(.custom(Resource.Font.interRegular, size: 16))
                    VStack {
                        Button(action: {
                            showDatePicker = true
                        }, label: {
                            Text(date.isEmpty ? viewModel.prepareDateToPrompt() : date)
                                .foregroundStyle(date.isEmpty ? .textFieldPlaceholder : .mainBlack)
                                .padding(16)
                                .frame(width: 159)
                        })
                        .sheet(isPresented: $showDatePicker) {
                            DatePicker(
                                "",
                                selection: $selectedDate,
                                displayedComponents: .date
                            )
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .labelsHidden()
                            HStack {
                                Spacer()
                                Button(action: {
                                    showDatePicker = false
                                }, label: {
                                    Text("Cancel")
                                        .font(.custom(Resource.Font.interRegular, size: 14))
                                        .foregroundStyle(.lightGrayText)
                                        .padding(.trailing, 34)
                                })
                                
                                Button(action: {
                                    date = dateFormatter.string(from: selectedDate)
                                    showDatePicker = false
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
                
                Spacer(minLength: 24)
                
                //MARK: - Time
                VStack {
                    Text(Resource.Strings.time)
                        .font(.custom(Resource.Font.interRegular, size: 16))
                    VStack {
                        Button(action: {
                            showTimePicker = true
                        }, label: {
                            Text(time.isEmpty ? viewModel.prepareTimeToPrompt() : time)
                                .foregroundStyle(time.isEmpty ? .textFieldPlaceholder : .mainBlack)
                                .padding(16)
                                .frame(width: 159)
                        })
                        .sheet(isPresented: $showTimePicker) {
                            VStack {
                                DatePicker(
                                    "",
                                    selection: $selectedTime,
                                    displayedComponents: .hourAndMinute
                                )
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                                
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        showTimePicker = false
                                    }, label: {
                                        Text("Cancel")
                                            .font(.custom(Resource.Font.interRegular, size: 14))
                                            .foregroundStyle(.lightGrayText)
                                            .padding(.trailing, 34)
                                    })
                                    
                                    Button(action: {
                                        time = timeFormatter.string(from: selectedTime)
                                        showTimePicker = false
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
            }
            .padding(.init(top: 24, leading: 16, bottom: 24, trailing: 16))
            
            //MARK: - Note
            VStack {
                HStack {
                    Text(Resource.Strings.note)
                        .font(.custom(Resource.Font.interRegular, size: 16))
                    Spacer()
                }
                .padding(.horizontal, 16)
                ZStack {
                    TextEditor(text: $note)
                        .focused($isFocusedTextEditor)
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 45, maxHeight: textEditorHeight)
                        .overlay {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(!isFocusedTextEditor ? Color.clear : Color.mainBlack, lineWidth: 1)
                        }
                        .onChange(of: note) { newValue in
                            updateTextEditorHeight(newValue)
                        }
                        .background(note.isEmpty ? Color.clear : Color.white)
                        .cornerRadius(14)
                        .padding(16)
                }
                .frame(height: textEditorHeight)
                .animation(.easeInOut, value: note)
                .background(Color.mainBackground)
                Spacer()
            }
            
            Spacer()
            
            //MARK: - Save Button
            HStack {
                Button {
                    
                } label: {
                    Text(Resource.Strings.save)
                        .font(.custom(Resource.Font.interRegular, size: 18))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(systoliticsPressure.isEmpty
                                    && diastoliticsPressure.isEmpty ? .saveNewRecordButton.opacity(0.3)
                                                                    : .saveNewRecordButton)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .disabled(systoliticsPressure.isEmpty && diastoliticsPressure.isEmpty)
                }
            }
            .padding(.init(top: 0, leading: 16, bottom: 24, trailing: 16))

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.mainBackground))
        .onAppear {
            updateTextEditorHeight(note)
        }
    }
}

//MARK: - Custom views
@ViewBuilder private func customTextField(_ text: Binding<String>, _ prompt: String, _ width: CGFloat, _ isFocused: FocusState<Bool>.Binding) -> some View {
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
        
}

//MARK: - Extension
extension NewRecordView {
    func updateTextEditorHeight(_ newText: String) {
        let lineHeight: CGFloat = 20
        let newHeight = max(45, CGFloat(newText.split(separator: "\n").count) * lineHeight)
        $textEditorHeight.wrappedValue = newHeight
    }
}

#Preview {
    NewRecordView()
}
