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
    @EnvironmentObject private var router: Router
    
    @StateObject private var viewModel = MainViewModel()
    @StateObject private var allRecords = RecordModel()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Record.date, ascending: false)],
        animation: .default)
    private var records: FetchedResults<Record>
    
    var body: some View {
        RouterView {
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
                        headerView()
                        .padding(.bottom, 24)
                        timeSelect()
                        previewData()
                        notes()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.mainBackground))
            .onAppear {
                allRecords.healthData = viewModel.getDate(items: records)
            }
        }
    }
    
    //MARK: - Header
    @ViewBuilder private func headerView() -> some View {
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
                    Text(viewModel.translateMonth(Date()))
                }
                .offset(x: 30)
                Spacer()
                Button {
                    router.push(.goToNewRecordView(allRecords))
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
    @ViewBuilder private func previewData() -> some View {
        let healthData = allRecords.healthData
        VStack {
            if healthData.count > 0,
               healthData.first?.systolic != 0 && healthData.first?.daistolic != 0 {
                HStack {
                    VStack(alignment: .leading) {
                        Text(Resource.Strings.pressure)
                            .font(.custom(Resource.Font.interRegular, size: 12))
                            .foregroundStyle(.lightGrayText)
                            .padding(.bottom, 8)
                        Text(Resource.Strings.pulse)
                            .frame(width: 58, alignment: .leading)
                            .font(.custom(Resource.Font.interRegular, size: 12))
                            .foregroundStyle(.lightGrayText)
                            .multilineTextAlignment(.trailing)
                    }
                    .frame(width: 60)
                    .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 8))
                    
                    VStack {
                        HStack {
                            Text("\(healthData.first?.systolic ?? 0) / \(healthData.first?.daistolic ?? 0)")
                                .font(.custom(Resource.Font.interMedium, size: 18))
                            Text(Resource.Strings.mmHg)
                                .font(.custom(Resource.Font.interRegular, size: 12))
                                .foregroundStyle(.lightGrayText)
                            Spacer()
                        }
                        
                        HStack {
                            Text("\(healthData.first?.pulse ?? 0)")
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
                .padding(.horizontal, 16)
            }
            else {
                VStack(spacing: 8) {
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
                .padding(8)
            
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
            Chart {
                RuleMark(y: .value("", 50))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundStyle(Color.blue)
                RuleMark(y: .value("", 150))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundStyle(Color.red)
                RuleMark(x: .value("", 0))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundStyle(Color.mainBlack.opacity(0.2))
                
                ForEach(healthData) { point in
                    LineMark(
                        x: .value("", viewModel.formateDateFromChart(point.date)),
                        y: .value("", point.systolic),
                        series: .value("Pressure", "Systolic")
                    )
                    .foregroundStyle(.chartCoral)
                    .symbol {
                        Circle()
                            .fill(Color.chartCoral)
                            .frame(width: 10)
                    }
                    .interpolationMethod(.catmullRom)
                }
                ForEach(healthData) { point in
                    LineMark(
                        x: .value("", viewModel.formateDateFromChart(point.date)),
                        y: .value("", point.daistolic)
                    )
                    .foregroundStyle(.chartYellow)
                    .symbol {
                        Circle()
                            .fill(Color.chartYellow)
                            .frame(width: 10)
                    }
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 200)
            .padding(16)
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
            .chartYAxis {
                AxisMarks(values: [0, 50, 100, 150, 200]) { value in
                    AxisGridLine(centered: true,
                                 stroke: StrokeStyle(lineWidth: 1, dash: [5]))
                    
                    AxisValueLabel {
                        if let intValue = value.as(Int.self) {
                            Text("\(intValue)")
                        }
                    }
                    .foregroundStyle(value.as(Int.self) == 50 ? Color.blue : (value.as(Int.self) == 150 ? Color.red : Color.mainBlack.opacity(0.5)))
                }
            }
            .chartYScale(domain: 0...200)
            
            .chartXAxis {
                AxisMarks(values: [0, 6, 12, 18, 24]) { value in
                    AxisValueLabel {
                        if let intValue = value.as(Int.self) {
                            Text(intValue == 24 ? "0" : "\(intValue)")
                        }
                    }
                    .foregroundStyle(Color.mainBlack.opacity(0.5))
                }
            }
            .chartXScale(domain: 0...24)
            
            HStack {
                Spacer()
                Button {
                    router.push(.goToNewRecordView(allRecords))
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
    @ViewBuilder private func notes() -> some View {
        VStack {
            HStack {
                Image(.edit)
                    .padding(.horizontal, 16)
                Text(Resource.Strings.note)
                    .font(.custom(Resource.Font.interMedium, size: 16))
                Spacer()
                Image(systemName: viewModel.isNoteEmpty(items: allRecords.healthData) ? "plus" : "chevron.right")
                    .frame(width: 18, height: 18)
                    .foregroundStyle(.noteArrowGray)
                    .padding(.trailing, 28)
            }
            .padding(.vertical, 8)
            
            Divider()
                .padding(.init(top: 0, leading: 16, bottom: 8, trailing: 16))
            
            if !viewModel.isNoteEmpty(items: allRecords.healthData) {
                HStack {
                    Text(viewModel.prepareDate(items: allRecords.healthData))
                        .padding(.leading, 16)
                        .foregroundStyle(.lightGrayText)
                        .font(.custom(Resource.Font.interRegular, size: 12))
                    Spacer()
                }
            }
            
            HStack {
                Text(viewModel.isNoteEmpty(items: allRecords.healthData)
                     ? Resource.Strings.healthСondition
                     : viewModel.prepareNote(items: allRecords.healthData))
                .padding(.init(top: 0, leading: 16, bottom: 16, trailing: 16))
                .font(.custom(Resource.Font.interRegular, size: 14))
                .foregroundStyle(viewModel.isNoteEmpty(items: allRecords.healthData) ? .lightGrayText : .mainBlack)
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
}

#Preview {
    MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
