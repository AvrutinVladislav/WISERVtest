//
//  ContentView.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 21.10.2024.
//

import SwiftUI
import Charts

struct MainView: View {
    
    @StateObject private var viewModel = MainViewModel()
    @State private var path: [String] = []
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.date, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack {
                    headerView(path: $path, destination: Resource.Destinations.newRecord)
                    timeSelect()
                    previewData(viewModel, items)
                    notes(viewModel, items)
                }
                .navigationDestination(for: String.self) { value in
                    if value == Resource.Destinations.newRecord {
                        NewRecordView()
                            .customNavBar(title: Resource.Strings.addData)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.mainBackground))
        }
    }
}

//MARK: - Notes
@ViewBuilder private func notes(_ viewModel: MainViewModel, _ items: FetchedResults<Item>) -> some View {
    VStack {
        HStack {
            Image(.edit)
                .padding(.horizontal, 16)
            Text(Resource.Strings.note)
                .font(.custom(Resource.Font.interMedium, size: 16))
            Spacer()
            Image(systemName: viewModel.isNoteEmpty(items: items) ? "plus" : "chevron.right")
                .frame(width: 18, height: 18)
                .foregroundStyle(.noteArrowGray)
                .padding(.trailing, 28)
        }
        .padding(.vertical, 8)
        
        Divider()
            .padding(.init(top: 0, leading: 16, bottom: 8, trailing: 16))
        
        if !viewModel.isNoteEmpty(items: items) {
            HStack {
                Text(viewModel.prepareDate(items: items))
                    .padding(.leading, 16)
                    .foregroundStyle(.lightGrayText)
                    .font(.custom(Resource.Font.interRegular, size: 12))
                Spacer()
            }
        }
        
        HStack {
            Text(viewModel.isNoteEmpty(items: items) ?Resource.Strings.healthСondition
                 : viewModel.prepareNote(items: items))
            .padding(.init(top: 0, leading: 16, bottom: 16, trailing: 16))
            .font(.custom(Resource.Font.interRegular, size: 14))
            .foregroundStyle(viewModel.isNoteEmpty(items: items) ? .lightGrayText : .mainBlack)
            Spacer()
        }
    }
    .background(.white)
    .clipShape(RoundedRectangle(cornerRadius: 24))
    .padding(16)
}

//MARK: - Grafic and data
@ViewBuilder private func previewData(_ viewModel: MainViewModel, _ items: FetchedResults<Item>) -> some View {
    VStack {
        HStack {
            VStack(alignment: .leading) {
                Text(Resource.Strings.pressure)
                    .font(.custom(Resource.Font.interRegular, size: 12))
                    .foregroundStyle(.lightGrayText)
                    .padding(.bottom, 16)
                Text(Resource.Strings.pulse)
                    .frame(maxWidth: .infinity)
                    .font(.custom(Resource.Font.interRegular, size: 12))
                    .foregroundStyle(.lightGrayText)
                    .multilineTextAlignment(.trailing)
            }
            .frame(width: 60)
            .padding(.init(top: 24, leading: 16, bottom: 16, trailing: 8))
            
            VStack {
                HStack {
                    
                    Text(viewModel.preparePressure(items: items))
                        .font(.custom(Resource.Font.interMedium, size: 18))
                    Text(Resource.Strings.mmHg)
                        .font(.custom(Resource.Font.interRegular, size: 12))
                        .foregroundStyle(.lightGrayText)
                    Spacer()
                }
                .padding(.init(top: 0, leading: 0, bottom: 8, trailing: 0))
                
                HStack {
                    
                    Text(viewModel.preparePulse(items: items))
                        .font(.custom(Resource.Font.interMedium, size: 18))
                    Text(Resource.Strings.bitsPerMinute)
                        .font(.custom(Resource.Font.interRegular, size: 12))
                        .foregroundStyle(.lightGrayText)
                    Spacer()
                }
            }
        }
        
        HStack {
            Text(Resource.Strings.today)
                .font(.custom(Resource.Font.interRegular, size: 10))
                .foregroundStyle(.mainBlack)
            Spacer()
        }
        .padding(.init(top: 16, leading: 16, bottom: 0, trailing: -16))
        
        Divider()
            .padding(16)
        
        HStack {
            Image(.ellipseRed)
                .padding(.leading, 16)
            Text(Resource.Strings.systolitics)
                .font(.custom(Resource.Font.interRegular, size: 12))
                .padding(.trailing, 16)
            Image(.ellipseYellow)
            Text(Resource.Strings.diastolics)
                .font(.custom(Resource.Font.interRegular, size: 12))
            Spacer()
        }
        
        // Тут надо сделать график
        HStack {
            Spacer()
            Button {
                
            } label: {
                Text(Resource.Strings.addData)
                    .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .font(.custom(Resource.Font.interRegular, size: 12))
                    .foregroundStyle(.orange)
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .stroke(.orangeButton)
                    )
            }
            .padding(.init(top: 16, leading: 0, bottom: 24, trailing: 16))
        }
    }
    .background(.white)
    .clipShape(RoundedRectangle(cornerRadius: 24))
    .padding(17)
}

//MARK: - Time selector
@ViewBuilder private func timeSelect() -> some View {
    HStack {
        timeButton(Resource.Strings.day, true)
        timeButton(Resource.Strings.week, false)
        timeButton(Resource.Strings.month, false)
        
    }
    .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
    .frame(width: 341)
    .background(Color(.white))
    .clipShape(Capsule())
}

//MARK: - Header
@ViewBuilder private func headerView(path: Binding<[String]>, destination: String) -> some View {
    VStack {
        HStack {
            Spacer()
            Image(.logo)
            Text(Resource.Strings.title)
                .font(.custom(Resource.Font.exo2Medium, size: 16))
                .fontWeight(.medium)
            Spacer()
        }
        HStack {
            Spacer()
            VStack {
                Text(Resource.Strings.pressure)
                    .font(.custom(Resource.Font.interMedium, size: 18))
                    .fontWeight(.medium)
                Text(Date(), formatter: itemFormatter)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
            ZStack {
                Spacer()
                LinearGradient(colors: [Color(.gradientRed)],
                               startPoint: .trailing,
                               endPoint: .leading)
                .frame(width: 78, height: 78)
                .blur(radius: 20)
                .offset(.init(width: -30, height: -10))
                .rotationEffect(Angle(degrees: 180))
                
                Button {
                    path.wrappedValue.append(destination)
                } label: {
                    Image(.addPressure)
                }
            }
        }
    }
}

//MARK: - Custom elements
@ViewBuilder private func timeButton(_ title: String, _ isSelected: Bool) -> some View {
    Button {
        
    } label: {
        Text(title)
            .font(.custom(isSelected ? Resource.Font.interMedium : Resource.Font.interRegular, size: 14))
            .foregroundColor(.mainBlack)
    }
    .frame(width: 99, height: 26)
    .background(isSelected ? Color.timeButtonSelect : Color.white)
    .clipShape(Capsule())
}

//MARK: - Extension
extension MainView {
    func deleteItems(offsets: IndexSet) {
        CoreDataManager().deleteItems(offsets: offsets, viewContext: viewContext, items: Array(items))
    }
    
    func addItems() {
        CoreDataManager().addItem(viewContext: viewContext)
    }
    
    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

#Preview {
    MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
