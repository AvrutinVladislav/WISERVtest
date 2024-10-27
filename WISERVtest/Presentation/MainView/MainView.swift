//
//  ContentView.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 21.10.2024.
//

import SwiftUI
import Charts

struct MainView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var manager: DataManager
    
    @StateObject private var viewModel = MainViewModel()
    @State private var path: [String] = []

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Record.date, ascending: false)],
        animation: .default)
    private var records: FetchedResults<Record>
    
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
                            .padding(.bottom, 24)
                            timeSelect()
                            previewData(data: viewModel.getDate(items: records),
                                        path: $path,
                                        destination: Resource.Destinations.newRecord)
                            notes(viewModel, records)
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
            .offset(x: 30)
            Spacer()
            Button {
                path.wrappedValue.append(destination)
            } label: {
                Image(.addPressure)
            }
            .frame(maxWidth: 32, maxHeight: 32)
            .padding(.trailing, 16)
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

//MARK: - Pressure and pulse data
@ViewBuilder private func previewData(data: [PressureModel],
                                      path: Binding<[String]>,
                                      destination: String) -> some View {
    VStack {
        if data.first?.systolic != 0
            && data.first?.daistolic != 0 {
            HStack {
                VStack(alignment: .leading) {
                    Text(Resource.Strings.pressure)
                        .font(.custom(Resource.Font.interRegular, size: 12))
                        .foregroundStyle(.lightGrayText)
                        .padding(.bottom, 16)
                    Text(Resource.Strings.pulse)
                        .frame(width: 58, alignment: .leading)
                        .font(.custom(Resource.Font.interRegular, size: 12))
                        .foregroundStyle(.lightGrayText)
                        .multilineTextAlignment(.trailing)
                }
                .frame(width: 60)
                .padding(.init(top: 24, leading: 16, bottom: 16, trailing: 8))
                
                VStack {
                    HStack {
                        Text("\(data.first?.systolic ?? 0) / \(data.first?.daistolic ?? 0)")
                            .font(.custom(Resource.Font.interMedium, size: 18))
                        Text(Resource.Strings.mmHg)
                            .font(.custom(Resource.Font.interRegular, size: 12))
                            .foregroundStyle(.lightGrayText)
                        Spacer()
                    }
                    .padding(.init(top: 0, leading: 0, bottom: 8, trailing: 0))
                    
                    HStack {
                        Text("\(data.first?.pulse ?? 0)")
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
                    .foregroundStyle(.lightGrayText)
                Spacer()
            }
            .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
        }
        else {
            VStack(spacing: 16) {
                HStack {
                    Text("Нет данных")
                        .font(.custom(Resource.Font.interMedium, size: 18))
                        .foregroundStyle(.mainBlack)
                    Spacer()
                }
                .padding(.init(top: 24, leading: 16, bottom: 0, trailing: 16))
                HStack {
                    Text(Resource.Strings.today)
                        .font(.custom(Resource.Font.interRegular, size: 10))
                        .foregroundStyle(.lightGrayText)
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
        }
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
            .foregroundStyle(.systolitic)
            .lineStyle(StrokeStyle(lineWidth: 2))
            .interpolationMethod(.catmullRom)
            .symbol {
                Circle()
                    .fill(Color.systolitic)
                    .frame(width: 10)
            }

            PointMark(
                x: .value("", formateDateFromChart(point.date)),
                y: .value("Diastolic", point.daistolic)
            )
            .foregroundStyle(.diastolitic)
            .lineStyle(StrokeStyle(lineWidth: 2))
            .interpolationMethod(.catmullRom)
            .symbol {
                Circle()
                    .fill(Color.diastolitic)
                    .frame(width: 10)
            }
        }
        .frame(height: 150)
        .padding(16)
        .chartYAxis {
            AxisMarks(values: [0, 50, 100, 150, 200])
        }
        .chartPlotStyle { plotArea in
            plotArea
                .overlay(
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.black)
                            .frame(height: 1)
                    }
                )
                .overlay(
                    HStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 1)
                    }
                )
        }
        .chartXAxis {
            AxisMarks(values: [0, 6, 12, 18, 24]) {
                AxisValueLabel()
            }
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
@ViewBuilder private func notes(_ viewModel: MainViewModel,
                                _ items: FetchedResults<Record>) -> some View {
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
            Text(viewModel.isNoteEmpty(items: items) ? Resource.Strings.healthСondition
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

func formateDateFromChart(_ hour: Date) -> Int {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH"
    guard let date = Int(formatter.string(from: hour)) else { return 0 }
    return date
}

func getData(_ viewModel: MainViewModel,
             _ items: FetchedResults<Record>) -> [PressureModel] {
    return viewModel.getDate(items: items)
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "dd MMMM yyyy"
    return formatter
}()

#Preview {
    MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
