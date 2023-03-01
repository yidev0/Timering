//
//  OverviewView.swift
//  Timering
//
//  Created by Yuto on 2022/08/18.
//

import SwiftUI

struct OverviewView: View {
    
    let column = [GridItem(.adaptive(minimum: (375-32-8),
                                     maximum: (420-32-8)),
                           spacing: 8)]
    
    var trGroups:FetchRequest<TRGroup>
    @State var showSettings = false
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: column, spacing: 8) {
                ForEach(0..<3) { i in
                    TotalOverviewGrid(type: [.overall, .today, .session][i])
                }
            }.padding(.horizontal, 16)
        }
        .navigationTitle(Text("Sidebar.Section.Overview"))
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    init(){
        self.trGroups = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TRGroup.title,
                                                                        ascending: true)],
                                     animation: .default)
    }
}

struct TotalOverviewGrid: View{
    
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
        .groupBoxStyle(ColorGroupBox(color: Color(.secondarySystemGroupedBackground)))
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

struct ColorGroupBox: GroupBoxStyle {
    
    var hideLabel = false
    var color:Color
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            if !hideLabel{
                HStack {
                    configuration.label
                        .font(.headline)
                    Spacer()
                }
            }
            
            configuration.content
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(color)) // Set your color here!!
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewView()
    }
}
