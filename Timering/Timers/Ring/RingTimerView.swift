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
    
    var group:TRGroup
    var fetchedTimers: FetchRequest<TRTimer>
    var trEntries: FetchRequest<TREntry>
    
//    @State var size:CGSize = .zero
    @State var counter:Double// = 0.001
//    @State var times:[Double] = []
//    @State var maxSize:Double = 100
    @State var startTime = Date()
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
            RingView(counter: $counter, entries: trEntries, timers: fetchedTimers)
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
//            triggerTimer()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .onReceive(timer) { output in
            
        }
    }
    
    init(group:TRGroup){
        self.group = group
        self.fetchedTimers = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TRTimer.title,
                                                                             ascending: true)],
                                          predicate: NSPredicate(format: "group == %@", group),
                                          animation: .default)
        self.trEntries = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TREntry.input,
                                                                         ascending: true)],
                                      animation: .default)
        self._counter = .init(initialValue: group.totalTime())
    }
    
//    func adjustTime(){
//        if isAdjusting == true { return }
//
//        isAdjusting = true
//        let currentTime = Date()
//        let dif = currentTime.timeIntervalSince(startTime)
//        if let last = times.last, dif > last{
//            let adjustTime = dif - times.last!
//            print("dif", adjustTime)
//            (0..<times.count).forEach({ times[$0] += adjustTime })
//            counter += adjustTime
//        }
//        isAdjusting = false
//    }
    
//    func triggerTimer(){
//        if isActive{
//            print(times)
//        } else {
//            startTime = Date()
//            withAnimation {
//                times.append(0.001)
//            }
//        }
//
//        if vibrate{
//            let generator = UIImpactFeedbackGenerator(style: .soft)
//            generator.impactOccurred()
//        }
//        isActive.toggle()
//    }
    
}

//struct RingTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        RingTimerView()
//    }
//}
