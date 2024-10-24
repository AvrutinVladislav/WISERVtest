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
    
    var data: [PressureModel] = [
        PressureModel(id: "4", systolic: 143, daistolic: 80, pulse: 85, date: Date().addingTimeInterval(-3600 * 2), note: nil),
        PressureModel(id: "5", systolic: 49, daistolic: 64, pulse: 85, date: Date().addingTimeInterval(-3600 * 8), note: nil),
        PressureModel(id: "6", systolic: 145, daistolic: 76, pulse: 85, date: Date().addingTimeInterval(-3600 * 5), note: nil),
        PressureModel(id: "7", systolic: 134, daistolic: 66, pulse: 85, date: Date().addingTimeInterval(-3600 * 8), note: nil),
    ]
        
    

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                    ZStack {
                        GradientView(colors: [.gradientRed],
                                     startPoint: .trailing,
                                     endPoint: .leading,
                                     rotation: Angle(degrees: 180),
                                     width: 78,
                                     height: 78,
                                     blurRadius: 50,
                                     xOffset: 35,
                                     yOffset: -280)
                        GradientView(colors: [.gradientYellow],
                                     startPoint: .trailing,
                                     endPoint: .leading,
                                     rotation: Angle(degrees: 180),
                                     width: 138,
                                     height: 138,
                                     blurRadius: 100,
                                     xOffset: 42,
                                     yOffset: -280)
                        VStack {
                            headerView(path: $path,
                                       destination: Resource.Destinations.newRecord)
                            timeSelect()
                            previewData(viewModel: viewModel,
                                        items: items,
                                        data: data,
                                        path: $path,
                                        destination: Resource.Destinations.newRecord)
                            notes(viewModel, items)
                        }
                    }
                }
                .navigationDestination(for: String.self) { value in
                    if value == Resource.Destinations.newRecord {
                        NewRecordView()
                            .customNavBar(title: Resource.Strings.addData)
                    }
                }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.mainBackground))
        }
    }
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
            
            Button {
                path.wrappedValue.append(destination)
            } label: {
                Image(.addPressure)
            }
        }
    }
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

//MARK: - Chart and data
@ViewBuilder private func previewData(viewModel: MainViewModel,
                                      items: FetchedResults<Item>,
                                      data: [PressureModel],
                                      path: Binding<[String]>,
                                      destination: String) -> some View {
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
        .padding(.init(top: 0, leading: 16, bottom: 0, trailing: -16))
        
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
//MARK: - Chart
        Chart(data) { point in
            PointMark(
                x: .value("", formateDateFromChart(point.date)),
                y: .value("Systolic", point.systolic)
            )
            .foregroundStyle(.red)
            .lineStyle(StrokeStyle(lineWidth: 2))
            .interpolationMethod(.catmullRom)
            .symbol {
                Circle()
                    .fill(Color.red)
                    .frame(width: 10)
            }

            PointMark(
                x: .value("", formateDateFromChart(point.date)),
                y: .value("Diastolic", point.daistolic)
            )
            .foregroundStyle(.blue)
            .lineStyle(StrokeStyle(lineWidth: 2))
            .interpolationMethod(.catmullRom)
            .symbol {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 10)
            }
        }
        .frame(height: 150)
        .padding(16)
        .chartYAxis {
            AxisMarks(values: [0, 50, 100, 150, 200])
        }
        .chartXAxis {
            AxisMarks(values: [0, 6, 12, 18, 24])
        }

        HStack {
            Spacer()
            Button {
                path.wrappedValue.append(destination)
            } label: {
                Text(Resource.Strings.addData)
                    .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .font(.custom(Resource.Font.interRegular, size: 12))
                    .foregroundStyle(.orange)
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .stroke(.orangeButton)
                    )
            }
            .padding(.init(top: 0, leading: 0, bottom: 24, trailing: 16))
        }
    }
    .background(.white)
    .clipShape(RoundedRectangle(cornerRadius: 24))
    .padding(17)
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
func formateDateFromChart(_ hour: Date) -> Int {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH"
    return Int(formatter.string(from: hour))!
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

#Preview {
    MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
