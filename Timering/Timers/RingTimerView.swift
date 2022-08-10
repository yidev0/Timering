//
//  RingTimerView.swift
//  Timering
//
//  Created by Yuto on 2022/03/31.
//

import SwiftUI

struct RingTimerView: View {
    
    @AppStorage("RingPlayVibration", store: userDefaults) var vibrate = false
    
    @State var showSettings = false
    @State var isActive = false
    @State var isAdjusting = false
    
//    @State var size:CGSize = .zero
    @State var counter = 0.001
    @State var times:[Double] = []
    @State var maxSize:Double = 100
    @State var startTime = Date()
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @AppStorage("Settings.Ring.DefaultColor", store: userDefaults) var defaultColor = 0
    let defaultBlue = [Color(hue: 219/359, saturation: 0.20, brightness: 100/100),
                       Color(hue: 219/359, saturation: 0.40, brightness: 100/100),
                       Color(hue: 219/359, saturation: 0.60, brightness: 100/100),
                       Color(hue: 219/359, saturation: 0.80, brightness: 100/100),
                       Color(hue: 219/359, saturation: 0.94, brightness: 100/100),
                       Color(hue: 219/359, saturation: 0.96, brightness:  75/100)]
    let defaultGray = [.gray, Color(.systemGray2), Color(.systemGray3), Color(.systemGray4), Color(.systemGray5), Color(.systemGray6)]
    let defaultRainbow:[Color] = [.red, .orange, .yellow, .blue, .green, .purple]
    
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
            RingView(counter: $counter, times: $times, startTime: $startTime)
                .ignoresSafeArea()
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .onTapGesture {
            triggerTimer()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .onReceive(timer) { output in
            if isActive{
                counter += 0.01
                (0..<times.count).forEach({ times[$0] += 0.01 })
                adjustTime()
            }
        }
    }
    
    func adjustTime(){
        if isAdjusting == true { return }
        
        isAdjusting = true
        let currentTime = Date()
        let dif = currentTime.timeIntervalSince(startTime)
        if let last = times.last, dif > last{
            let adjustTime = dif - times.last!
            print("dif", adjustTime)
            (0..<times.count).forEach({ times[$0] += adjustTime })
            counter += adjustTime
        }
        isAdjusting = false
    }
    
    func triggerTimer(){
        if isActive{
            print(times)
        } else {
            startTime = Date()
            withAnimation {
                times.append(0.001)
            }
        }
        
        if vibrate{
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.impactOccurred()
        }
        isActive.toggle()
    }
    
}

struct RingView: View{
    
    @AppStorage("DynamicRing", store: userDefaults) var dynamicRing = true
    @AppStorage("RingPlayVibration", store: userDefaults) var vibrate = false
    @AppStorage("RingLimitTime", store: userDefaults) var limit = 30.0
    @AppStorage("RingSetTime", store: userDefaults) var setLimit = true
    
    @Binding var counter:Double
    @Binding var times:[Double]
    @State var maxSize:Double = 100
    @Binding var startTime:Date
    
    @AppStorage("Settings.Ring.DefaultColor", store: userDefaults) var defaultColor = 0
    let defaultBlue = [Color(hue: 219/359, saturation: 0.20, brightness: 100/100),
                       Color(hue: 219/359, saturation: 0.40, brightness: 100/100),
                       Color(hue: 219/359, saturation: 0.60, brightness: 100/100),
                       Color(hue: 219/359, saturation: 0.80, brightness: 100/100),
                       Color(hue: 219/359, saturation: 0.94, brightness: 100/100),
                       Color(hue: 219/359, saturation: 0.96, brightness:  75/100)]
    let defaultGray = [.gray, Color(.systemGray2), Color(.systemGray3), Color(.systemGray4), Color(.systemGray5), Color(.systemGray6)]
    let defaultRainbow:[Color] = [.red, .orange, .yellow, .blue, .green, .purple]
    
    var body: some View{
        GeometryReader { geometry in
            ZStack{
                Circle()
                    .hidden()
                    .frame(width: maxSize, height: maxSize, alignment: .center)
                
                ForEach(0..<times.count, id: \.self) { i in
                    Circle()
                        .ignoresSafeArea()
                        .frame(width: times[i]/(setLimit ? (dynamicRing ? counter:limit):times[0]) * maxSize, alignment: .center)
                        .aspectRatio(1, contentMode: .fill)
                        .foregroundColor([defaultBlue, defaultGray, defaultRainbow][defaultColor][i%6])
                }
            }
            .offset(x: (geometry.size.width < geometry.size.height) ? -(geometry.size.height - geometry.size.width)/2:0,
                    y: (geometry.size.width > geometry.size.height) ? -(geometry.size.width  - geometry.size.height)/2:0)
            .onChange(of: geometry.size) { newValue in
                maxSize = (newValue.width > newValue.height) ? newValue.width:newValue.height
            }
            .onAppear {
                maxSize = (geometry.size.width > geometry.size.height) ? geometry.size.width:geometry.size.height
            }
        }
    }
}

struct RingTimerView_Previews: PreviewProvider {
    static var previews: some View {
        RingTimerView()
    }
}
