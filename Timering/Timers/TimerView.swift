//
//  TimerViews.swift
//  Timering
//
//  Created by Yuto on 2022/07/30.
//

import SwiftUI

struct TimerView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @State var showSettings = false
    @State var timerType:TimerType
    @State var totalValue:Double
    
    var trGroup:TRGroup
    var fetchedTimers: FetchRequest<TRTimer>
    
    @AppStorage("DynamicRing", store: userDefaults) var dynamicRing = true
    @AppStorage("RingPlayVibration", store: userDefaults) var vibrate = false
    
    var body: some View {
        ZStack{
            switch timerType {
            case .ring:
                RingTimerView(group: trGroup)
            case .grid:
                GridTimerView(group: trGroup)
            case .gauge:
                GaugeTimerView()
            }
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    TimerControlView(trGroup: trGroup)
                        .padding([.bottom, .trailing], 12)
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Menu {
                    Section{
                        Toggle(isOn: $dynamicRing) {
                            Label("Settings.Ring.Dynamic", systemImage: "circle.circle")
                        }
                        Toggle(isOn: $vibrate) {
                            Label("Settings.Ring.PlayVibration", systemImage: "waveform")
                        }
                    }
                    
                    Section{
                        Button(action: { showSettings = true }) {
                            Text("Ring.Title.Settings")
                        }
                    }
                } label: {
                    Text("\(totalValue, specifier: "%.2f")")
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .padding(.all, 8)
                        .background(.thinMaterial)
                        .cornerRadius(8)
                }
                .onReceive(timer) { output in
                    totalValue = trGroup.totalTime()
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Menu{
                    Button {
                        showSettings = true
                    } label: {
                        Text("Settings.OpenSettings")
                    }
                    
                    Picker(selection: $timerType) {
                        Label("Settings.Title.Ring", systemImage: "circle.circle")
                            .tag(TimerType.ring)
                        Label("Settings.Title.Grid", systemImage: "square.grid.2x2")
                            .tag(TimerType.grid)
                        Label("Settings.Title.Gauge", systemImage: "barometer")
                            .tag(TimerType.gauge)
                    } label: {
                        Text("Settings.Title.TimerType")
                    }
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .onChange(of: timerType) { newValue in
            trGroup.timerType = Int16(newValue.rawValue)
            try? viewContext.save()
        }
    }
    
    init(group:TRGroup){
        self.trGroup = group
        self.fetchedTimers = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TRTimer.title,
                                                                             ascending: true)],
                                          predicate: NSPredicate(format: "group == %@", group),
                                          animation: .default)
        self._timerType = .init(initialValue: TimerType(rawValue: Int(group.timerType)) ?? .ring)
        self._totalValue = .init(initialValue: group.totalTime())
    }
    
}

struct TimerControlView: View{
    
    var trGroup:TRGroup
    var trTimers:FetchRequest<TRTimer>
    
    var body: some View{
        HStack{
            Spacer()
            
            HStack(spacing: 12){
                ForEach(trTimers.wrappedValue, id: \.self) { timer in
                    TimerControlButton(trTimer: timer)
                }
            }
            .padding(.all, 10)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(28)
            .frame(height: 56)
            .shadow(radius: 4)
        }
    }
    
    init(trGroup:TRGroup){
        self.trGroup = trGroup
        self.trTimers = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TRTimer.title,
                                                                        ascending: true)],
                                     predicate: NSPredicate(format: "group = %@", trGroup))
    }
    
}

struct TimerControlButton: View{
    
    @Environment(\.managedObjectContext) private var viewContext
    var trTimer:TRTimer
    
    var body: some View{
        Button {
            buttonPressed()
        } label: {
            ZStack{
                Circle()
                    .foregroundColor(trTimer.isActive ? Color(trTimer.tint as? UIColor ?? .systemBlue):.clear)
                Image(systemName: trTimer.icon ?? "folder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 24, maxHeight: 24)
                    .foregroundColor(trTimer.isActive ? .white:Color(trTimer.tint as? UIColor ?? .systemBlue))
            }
            .frame(width: 60 - 20, height: 60 - 20)
        }
    }
    
    func buttonPressed(){
        trTimer.adjustTime()
        trTimer.isActive.toggle()
        
        if trTimer.isActive{
            let newEntry = TREntry(context: viewContext)
            newEntry.input = Date()
            newEntry.value = 0.001
            newEntry.timer = trTimer
            do{
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do{
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
//        trTimer.isActive == false ? stopTimer():startTimer()
    }
    
}

//struct TimerView_Previews: PreviewProvider {
//    
//    @State static var timerType:TimerType = .ring
//    
//    static var previews: some View {
//        TimerView(group: <#Binding<TRGroup>#>, timers: <#Binding<[TRTimer]>#>)
//    }
//}
