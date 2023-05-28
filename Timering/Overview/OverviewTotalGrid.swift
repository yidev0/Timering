//
//  OverviewTotalGrid.swift
//  Timering
//
//  Created by Yuto on 2023/03/03.
//

import SwiftUI

struct OverviewTotalGrid: View{
    
    enum TotalType:Int{
        case overall, today, session
    }
    
    var type:TotalType
    @State var value:Double?
    var trGroups:FetchRequest<TRGroup>
    var trEntries:FetchRequest<TREntry>
    
    var body: some View{
        GroupBox {
            if let value = value{
                HStack(alignment: .lastTextBaseline, spacing: 4){
                    Text("\(value, specifier: "%.2f")")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("s")
                        .font(.body)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.top, 4)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        } label: {
            Label(("Overview.Header." + ["Total", "TodayTotal", "SessionTotal"][type.rawValue]).localize(),
                  systemImage: "calendar")
            .foregroundColor(.blue)
            .font(.system(.subheadline).weight(.semibold))
        }
//        .groupBoxStyle(ColorGroupBox(color: Color(.secondarySystemGroupedBackground)))
        .onAppear{
            Task{
                switch type {
                case .overall:
                    calculateOverall()
                case .today:
                    calculateToday()
                case .session:
                    calculateSession()
                }
            }
        }
        .refreshable {
            switch type {
            case .overall:
                calculateOverall()
            case .today:
                calculateToday()
            case .session:
                calculateSession()
            }
        }
    }
    
    init(type: TotalType){
        self.type = type
        self.trGroups = FetchRequest(sortDescriptors: [], animation: .default)
        self.trEntries = FetchRequest(sortDescriptors: [], animation: .default)
    }
    
    func calculateOverall() {
        var updateValue:Double = 0
        trGroups.wrappedValue.forEach{ group in
            updateValue += group.overallTime()
        }
        value = updateValue
    }
    
    func calculateToday(){
        var updateValue:Double = 0
        let entries = trEntries.wrappedValue
        let validEntries = entries.filter{ $0.startDate?.isToday() == true }
        for entry in validEntries{
            updateValue += entry.totalTime
        }
        value = updateValue
    }
    
    func calculateSession(){
        var updateValue:Double = 0
        trGroups.wrappedValue.forEach{ group in
            updateValue += group.totalTime()
        }
        value = updateValue
    }
}
