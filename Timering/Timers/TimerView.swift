//
//  TimerViews.swift
//  Timering
//
//  Created by Yuto on 2022/07/30.
//

import SwiftUI

struct TimerView: View {
    
    @State var showSettings = false
    @State var timerType:TimerType = .ring
    
    var group:TRGroup
    var fetchedTimers: FetchRequest<TRTimer>
    
    @AppStorage("DynamicRing", store: userDefaults) var dynamicRing = true
    @AppStorage("RingPlayVibration", store: userDefaults) var vibrate = false
    
    var body: some View {
        ZStack{
            switch timerType {
            case .ring:
                RingTimerView()
            case .grid:
                GridTimerView()
            case .gauge:
                GaugeTimerView()
            }
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    TimerControlView()
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
//                    Text("\(counter, specifier: "%.2f")")
//                        .font(.system(.body, design: .rounded))
//                        .fontWeight(.semibold)
//                        .foregroundColor(.primary)
//                        .padding(.all, 8)
//                        .background(.thinMaterial)
//                        .cornerRadius(8)
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
                        Label("Settings.Title.Gauge", systemImage: "gauge.medium")
                            .tag(TimerType.gauge)
                    } label: {
                        Text("Settings.Title.TimerType")
                    }
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        
    }
    
    init(group:TRGroup){
        self.group = group
        self.fetchedTimers = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TRTimer.title,
                                                                             ascending: true)],
                                          predicate: NSPredicate(format: "group == %@", group),
                                          animation: .default)
    }
    
}

struct TimerControlView: View{
    
//    @State var timers = testTimers
    
    var body: some View{
        HStack{
            Spacer()
            
            HStack(spacing: 12){
//                ForEach($timers) { $timer in
//                    TimerControlButton(timer: $timer, isActive: timer.isActive)
//                }
            }
            .padding(.all, 10)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(28)
            .frame(height: 56)
            .shadow(radius: 4)
        }
    }
}

struct TimerControlButton: View{
    
    @Binding var timer:TRTimer
    @State var isActive:Bool
    
    var body: some View{
        Button {
            // TODO:
            isActive.toggle()
        } label: {
            ZStack{
                Circle()
//                    .foregroundColor(isActive ? timer.tint:.clear)
//                Image(systemName: timer.icon)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(maxWidth: 24, maxHeight: 24)
//                    .foregroundColor(isActive ? .white:timer.tint)
            }
            .frame(width: 60 - 20, height: 60 - 20)
        }
        .onChange(of: isActive) { newValue in
//            timer.isActive = newValue
//
//            if newValue{
//                timer.lastInput.append(Date())
//                timer.times.append(0.001)
//            }
        }
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
