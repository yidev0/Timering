//
//  TimerViews.swift
//  Timering
//
//  Created by Yuto on 2022/07/30.
//

import SwiftUI

struct TimerView: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @State var showSettings = false
    @State var showTimers = true
    @State var timerType:TimerType
    @State var totalValue:Double
    
    var trGroup:TRGroup
    var trSession:TRSession
    
    var body: some View {
        ZStack{
            switch timerType {
            case .ring:
                RingTimerView(group: trGroup)
            case .grid:
                GridTimerView(group: trGroup)
            case .gauge:
                GaugeTimerView(timers: testGaugeTimers)
            }
            
            VStack{
                if horizontalSizeClass == .compact{
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Image(systemName: "chevron.compact.down")
                            .foregroundColor(.secondary)
                            .font(.system(.body).weight(.bold))
                            .padding(.vertical, 8)
                    }
                }
                Spacer()
                
                ZStack{
                    TimerValueControlView(totalValue: $totalValue)
                        .padding(.bottom, 12)
                    
                    HStack{
                        TimerTypeControlView(timerType: $timerType, showTimers: $showTimers)
                            .padding([.bottom, .leading], 12)
                        Spacer()
                    }
                    
                    HStack{
                        Spacer()
                        TimerControlView(trGroup: trGroup, showTimers: $showTimers)
                            .padding([.bottom, .trailing], 12)
                    }
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                TimerValueControlView(totalValue: $totalValue)
                .onReceive(timer) { output in
                    totalValue = trGroup.totalTime()
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Menu{
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
                    
                    Button {
                        showSettings = true
                    } label: {
                        Text("Settings.OpenSettings")
                    }
                } label: {
                    switch timerType {
                    case .ring:
                        Image(systemName: "circle.circle")
                    case .grid:
                        Image(systemName: "square.grid.2x2")
                    case .gauge:
                        Image(systemName: "barometer")
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        //TODO: Session
                    } label: {
                        Label("Session.Close", systemImage: "checkmark.circle")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
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
        self.trSession = group.getActiveSession()!
        self._timerType = .init(initialValue: TimerType(rawValue: Int(group.timerType)) ?? .ring)
        self._totalValue = .init(initialValue: group.totalTime())
    }
    
}

struct TimerValueControlView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var totalValue:Double
    
    @AppStorage("RingPlayVibration", store: userDefaults) var vibrate = false
    
    @State var showSettings:Bool = false
    
    var body: some View{
        Menu {
            Section{
                Toggle(isOn: $vibrate) {
                    Label("Settings.Ring.PlayVibration", systemImage: "waveform")
                }
            }
            
            Section{
                Button(action: { showSettings = true }) {
                    Text("Timer.Button.OpenSettings")
                }
            }
        } label: {
            Text("\(totalValue, specifier: "%.2f")")
                .font(.system(.body, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.all, horizontalSizeClass == .compact ? 12:8)
                .background(.thinMaterial)
                .cornerRadius(8)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

struct TimerTypeControlView: View{
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding var timerType:TimerType
    @Binding var showTimers:Bool
    
    var body: some View{
        HStack{
            Menu{
                Picker("Settings.Title.TimerType", selection: $timerType) {
                    Label("Settings.Title.Ring", systemImage: "circle.circle")
                        .tag(TimerType.ring)
                    Label("Settings.Title.Grid", systemImage: "square.grid.2x2")
                        .tag(TimerType.grid)
                    Label("Settings.Title.Gauge", systemImage: "barometer")
                        .tag(TimerType.gauge)
                }
            } label: {
                ZStack{
                    Circle()
                        .frame(width: 56, height: 56, alignment: .center)
                        .foregroundColor(Color(.secondarySystemBackground))
                    
                    switch timerType {
                    case .ring:
                        Image(systemName: "circle.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 24, maxHeight: 24, alignment: .center)
                    case .grid:
                        Image(systemName: "square.grid.2x2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 24, maxHeight: 24, alignment: .center)
                    case .gauge:
                        Image(systemName: "barometer")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 24, maxHeight: 24, alignment: .center)
                    }
                }.overlay(Circle().strokeBorder(lineWidth: 1))
            }
            .accessibilityLabel(Text("Settings.Title.TimerType"))
            .onTapGesture {
                if showTimers{
                    showTimers = false
                }
            }
            .shadow(color: .gray, radius: 2)
            
            Spacer()
        }
    }
}

struct TimerControlView: View{
    
    var trGroup:TRGroup
    var trSession:TRSession
    var trTimers:FetchRequest<TRTimer>
    
    @Binding var showTimers:Bool
    
    var body: some View{
        HStack{
            Spacer()
            
            ZStack(){
                if showTimers{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 12){
                            if trTimers.wrappedValue.count < 6{
                                Button {
                                    // TODO: 追加処理
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                }.frame(width: 36, height: 36)
                            }
                            
                            ForEach(trTimers.wrappedValue, id: \.self) { timer in
                                TimerControlButton(trTimer: timer, isActive: timer.isActive)
                            }
                        }.padding(.horizontal, 12)
                    }
                    .padding(.vertical, 10)
                }
                
                HStack{
                    if showTimers{
                        Spacer()
                    }
                    
                    Button {
                        withAnimation {
                            showTimers.toggle()
                        }
                    } label: {
                        ZStack{
                            Circle()
                                .frame(width: 56, height: 56, alignment: .center)
                                .foregroundColor(Color(.secondarySystemBackground))
                            
                            Image(systemName: "timer")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 24, maxHeight: 24, alignment: .center)
                        }
                        .frame(width: 56, height: 56, alignment: .center)
                        .overlay(Circle().strokeBorder(lineWidth: 1))
                    }
                }
            }
            .frame(maxWidth: showTimers ? ((36 + 12) * CGFloat(isTimerLimit() ? 6:trTimers.wrappedValue.count + 1) + 56+12):56)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(28)
            .frame(height: 56)
            .shadow(color: .gray, radius: 2)
        }
    }
    
    init(trGroup:TRGroup, showTimers:Binding<Bool>){
        self.trGroup = trGroup
        self.trSession = trGroup.getActiveSession()!
        self.trTimers = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TRTimer.title,
                                                                        ascending: true)],
                                     predicate: NSPredicate(format: "session = %@", trSession))
        
        self._showTimers = showTimers
    }
    
    func isTimerLimit() -> Bool{
        if trTimers.wrappedValue.count == 6{
            return true
        }
        return false
    }
    
}

struct TimerControlButton: View{
    
    @Environment(\.managedObjectContext) private var viewContext
    var trTimer:TRTimer
    @State var isActive:Bool
    
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
            .frame(width: 56 - 20, height: 56 - 20)
        }
        .onChange(of: isActive) { newValue in
            trTimer.isActive = newValue
            do{
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func buttonPressed(){
        trTimer.adjustTime()
        isActive.toggle()
        
        if isActive{
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
        
//        isActive == false ? stopTimer():startTimer()
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
